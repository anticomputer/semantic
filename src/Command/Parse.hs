{-# LANGUAGE DataKinds, GADTs, GeneralizedNewtypeDeriving, ScopedTypeVariables, TypeFamilies, TypeOperators #-}
module Command.Parse where

import Arguments
import Category
import Data.Aeson (ToJSON, toJSON, encode, object, (.=))
import Data.Aeson.Types (Pair)
import Data.Functor.Foldable hiding (Nil)
import Data.Record
import Data.String
import qualified Data.Text as T
import Git.Blob
import Git.Libgit2
import Git.Repository
import Git.Types
import qualified Git
import Info
import Language
import Language.Markdown
import Parser
import Prologue
import Source
import Syntax
import System.FilePath
import Term
import TreeSitter
import Renderer.JSON()
import Renderer.SExpression
import Text.Parser.TreeSitter.C
import Text.Parser.TreeSitter.Go
import Text.Parser.TreeSitter.JavaScript
import Text.Parser.TreeSitter.Ruby
import Text.Parser.TreeSitter.TypeScript

data ParseTreeFile = ParseTreeFile { parseTreeFilePath :: FilePath, node :: Rose ParseNode } deriving (Show)

data Rose a = Rose a [Rose a]
  deriving (Eq, Show)

instance ToJSON ParseTreeFile where
  toJSON ParseTreeFile{..} = object [ "filePath" .= parseTreeFilePath, "programNode" .= cata algebra node ]
    where algebra (RoseF a as) = object $ parseNodeToJSONFields a <> [ "children" .= as ]


data IndexFile = IndexFile { indexFilePath :: FilePath, nodes :: [ParseNode] } deriving (Show)

instance ToJSON IndexFile where
  toJSON IndexFile{..} = object [ "filePath" .= indexFilePath, "programNodes" .= foldMap (singleton . object . parseNodeToJSONFields) nodes ]
    where singleton a = [a]

data ParseNode = ParseNode
  { category :: Text
  , sourceRange :: Range
  , sourceText :: Maybe SourceText
  , sourceSpan :: SourceSpan
  , identifier :: Maybe Text
  }
  deriving (Show)

-- | Produce a list of JSON 'Pair's for the fields in a given ParseNode.
parseNodeToJSONFields :: ParseNode -> [Pair]
parseNodeToJSONFields ParseNode{..} =
     [ "category" .= category, "sourceRange" .= sourceRange, "sourceSpan" .= sourceSpan ]
  <> [ "sourceText" .= sourceText | isJust sourceText ]
  <> [ "identifier" .= identifier | isJust identifier ]

-- | Parses file contents into an SExpression format for the provided arguments.
parseSExpression :: Arguments -> IO ByteString
parseSExpression =
  pure . printTerms TreeOnly <=< parse <=< sourceBlobsFromArgs
  where parse = traverse (\sourceBlob@SourceBlob{..} -> parserForType (toS (takeExtension path)) sourceBlob)

type RAlgebra t a = Base t (t, a) -> a

parseRoot :: (FilePath -> f ParseNode -> root) -> (ParseNode -> [f ParseNode] -> f ParseNode) -> Arguments -> IO [root]
parseRoot construct combine args@Arguments{..} = do
  blobs <- sourceBlobsFromArgs args
  for blobs (\ sourceBlob@SourceBlob{..} -> do
    parsedTerm <- parseWithDecorator (decorator source) path sourceBlob
    pure $! construct path (para algebra parsedTerm))
  where algebra (annotation :< syntax) = combine (makeNode annotation (Prologue.fst <$> syntax)) (toList (Prologue.snd <$> syntax))
        decorator = parseDecorator debug
        makeNode :: Record (Maybe SourceText ': DefaultFields) -> Syntax Text (Term (Syntax Text) (Record (Maybe SourceText ': DefaultFields))) -> ParseNode
        makeNode (head :. range :. category :. sourceSpan :. Nil) syntax =
          ParseNode (toS category) range head sourceSpan (identifierFor syntax)

-- | Constructs IndexFile nodes for the provided arguments and encodes them to JSON.
parseIndex :: Arguments -> IO ByteString
parseIndex = fmap (toS . encode) . parseRoot IndexFile (\ node siblings -> node : concat siblings)

-- | Constructs ParseTreeFile nodes for the provided arguments and encodes them to JSON.
parseTree :: Arguments -> IO ByteString
parseTree = fmap (toS . encode) . parseRoot ParseTreeFile Rose

-- | Determines the term decorator to use when parsing.
parseDecorator :: (Functor f, HasField fields Range) => Bool -> (Source -> TermDecorator f fields (Maybe SourceText))
parseDecorator True = termSourceTextDecorator
parseDecorator False = const . const Nothing

-- | For the given absolute file paths, retrieves their source blobs.
sourceBlobsFromPaths :: [FilePath] -> IO [SourceBlob]
sourceBlobsFromPaths filePaths =
  for filePaths (\filePath -> do
                  source <- readAndTranscodeFile filePath
                  pure $ Source.SourceBlob source mempty filePath (Just Source.defaultPlainBlob))

-- | For the given sha, git repo path, and file paths, retrieves the source blobs.
sourceBlobsFromSha :: String -> String -> [FilePath] -> IO [SourceBlob]
sourceBlobsFromSha commitSha gitDir filePaths = do
  maybeBlobs <- withRepository lgFactory gitDir $ do
    repo   <- getRepository
    object <- parseObjOid (toS commitSha)
    commit <- lookupCommit object
    tree   <- lookupTree (commitTree commit)
    lift $ runReaderT (traverse (toSourceBlob tree) filePaths) repo

  pure $ catMaybes maybeBlobs

  where
    toSourceBlob :: Git.Tree LgRepo -> FilePath -> ReaderT LgRepo IO (Maybe SourceBlob)
    toSourceBlob tree filePath = do
      entry <- treeEntry tree (toS filePath)
      case entry of
        Just (BlobEntry entryOid entryKind) -> do
          blob <- lookupBlob entryOid
          bytestring <- blobToByteString blob
          let oid = renderObjOid $ blobOid blob
          s <- liftIO $ transcode bytestring
          pure . Just $ SourceBlob s (toS oid) filePath (Just (toSourceKind entryKind))
        _ -> pure Nothing
      where
        toSourceKind :: Git.BlobKind -> SourceKind
        toSourceKind (Git.PlainBlob mode) = Source.PlainBlob mode
        toSourceKind (Git.ExecutableBlob mode) = Source.ExecutableBlob mode
        toSourceKind (Git.SymlinkBlob mode) = Source.SymlinkBlob mode

-- | Returns a Just identifier text if the given Syntax term contains an identifier (leaf) syntax. Otherwise returns Nothing.
identifierFor :: (HasField fields (Maybe SourceText), HasField fields Category, StringConv leaf Text) => Syntax leaf (Term (Syntax leaf) (Record fields)) -> Maybe Text
identifierFor = fmap toS . extractLeafValue . unwrap <=< maybeIdentifier

-- | For the file paths and commit sha provided, extract only the BlobEntries and represent them as SourceBlobs.
sourceBlobsFromArgs :: Arguments -> IO [SourceBlob]
sourceBlobsFromArgs Arguments{..} =
  case commitSha of
    Just commitSha' -> sourceBlobsFromSha commitSha' gitDir filePaths
    _ -> sourceBlobsFromPaths filePaths

-- | Return a parser incorporating the provided TermDecorator.
parseWithDecorator :: TermDecorator (Syntax Text) DefaultFields field -> FilePath -> Parser (Syntax Text) (Record (field ': DefaultFields))
parseWithDecorator decorator path blob = decorateTerm decorator <$> parserForType (toS (takeExtension path)) blob

-- | Return a parser based on the file extension (including the ".").
parserForType :: String -> Parser (Syntax Text) (Record DefaultFields)
parserForType mediaType = maybe lineByLineParser parserForLanguage (languageForType mediaType)

-- | Select a parser for a given Language.
parserForLanguage :: Language -> Parser (Syntax Text) (Record DefaultFields)
parserForLanguage language = case language of
  C -> treeSitterParser C tree_sitter_c
  JavaScript -> treeSitterParser JavaScript tree_sitter_javascript
  TypeScript -> treeSitterParser TypeScript tree_sitter_typescript
  Markdown -> cmarkParser
  Ruby -> treeSitterParser Ruby tree_sitter_ruby
  Language.Go -> treeSitterParser Language.Go tree_sitter_go

-- | Decorate a 'Term' using a function to compute the annotation values at every node.
decorateTerm :: (Functor f) => TermDecorator f fields field -> Term f (Record fields) -> Term f (Record (field ': fields))
decorateTerm decorator = cata $ \ term -> cofree ((decorator term :. headF term) :< tailF term)

-- | A function computing a value to decorate terms with. This can be used to cache synthesized attributes on terms.
type TermDecorator f fields field = TermF f (Record fields) (Term f (Record (field ': fields))) -> field

-- | Term decorator extracting the source text for a term.
termSourceTextDecorator :: (Functor f, HasField fields Range) => Source -> TermDecorator f fields (Maybe SourceText)
termSourceTextDecorator source (ann :< _) = Just (SourceText (toText (Source.slice (byteRange ann) source)))

newtype Identifier = Identifier Text
  deriving (Eq, Show, ToJSON)

identifierDecorator :: (HasField fields Category, StringConv leaf Text) => TermDecorator (Syntax leaf) fields (Maybe Identifier)
identifierDecorator = fmap (Command.Parse.Identifier . toS) . extractLeafValue . unwrap <=< maybeIdentifier . tailF

-- | A fallback parser that treats a file simply as rows of strings.
lineByLineParser :: Parser (Syntax Text) (Record DefaultFields)
lineByLineParser SourceBlob{..} = pure . cofree . root $ case foldl' annotateLeaves ([], 0) lines of
  (leaves, _) -> cofree <$> leaves
  where
    lines = actualLines source
    root children = (sourceRange :. Program :. rangeToSourceSpan source sourceRange :. Nil) :< Indexed children
    sourceRange = Source.totalRange source
    leaf charIndex line = (Range charIndex (charIndex + T.length line) :. Program :. rangeToSourceSpan source (Range charIndex (charIndex + T.length line)) :. Nil) :< Leaf line
    annotateLeaves (accum, charIndex) line =
      (accum <> [ leaf charIndex (Source.toText line) ] , charIndex + Source.length line)

-- | Return the parser that should be used for a given path.
parserForFilepath :: FilePath -> Parser (Syntax Text) (Record DefaultFields)
parserForFilepath = parserForType . toS . takeExtension


data RoseF a b = RoseF a [b]
  deriving (Eq, Functor, Show)

type instance Base (Rose a) = RoseF a

instance Recursive (Rose a) where
  project (Rose a tree) = RoseF a tree

instance Corecursive (Rose a) where
  embed (RoseF a tree) = Rose a tree