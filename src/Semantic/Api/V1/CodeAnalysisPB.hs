-- Code generated by protoc-gen-haskell 0.1.0, DO NOT EDIT.
{-# LANGUAGE DerivingVia, DeriveAnyClass, DuplicateRecordFields #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-missing-export-lists #-}
module Semantic.Api.V1.CodeAnalysisPB where

import Control.DeepSeq
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Int
import Data.Text (Text)
import Data.Vector (Vector)
import Data.Word
import GHC.Generics
import Proto3.Suite
import Proto3.Wire (at, oneof)

data PingRequest = PingRequest
  { service :: Text
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message PingRequest where
  encodeMessage _ PingRequest{..} = mconcat
    [ encodeMessageField 1 service
    ]
  decodeMessage _ = PingRequest
    <$> at decodeMessageField 1
  dotProto = undefined

data PingResponse = PingResponse
  { status :: Text
  , hostname :: Text
  , timestamp :: Text
  , sha :: Text
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message PingResponse where
  encodeMessage _ PingResponse{..} = mconcat
    [ encodeMessageField 1 status
    , encodeMessageField 2 hostname
    , encodeMessageField 3 timestamp
    , encodeMessageField 4 sha
    ]
  decodeMessage _ = PingResponse
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
    <*> at decodeMessageField 4
  dotProto = undefined

data ParseTreeRequest = ParseTreeRequest
  { blobs :: Vector Blob
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ParseTreeRequest where
  encodeMessage _ ParseTreeRequest{..} = mconcat
    [ encodeMessageField 1 (NestedVec blobs)
    ]
  decodeMessage _ = ParseTreeRequest
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data ParseTreeSymbolResponse = ParseTreeSymbolResponse
  { files :: Vector File
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ParseTreeSymbolResponse where
  encodeMessage _ ParseTreeSymbolResponse{..} = mconcat
    [ encodeMessageField 1 (NestedVec files)
    ]
  decodeMessage _ = ParseTreeSymbolResponse
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data ParseTreeGraphResponse = ParseTreeGraphResponse
  { files :: Vector ParseTreeFileGraph
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ParseTreeGraphResponse where
  encodeMessage _ ParseTreeGraphResponse{..} = mconcat
    [ encodeMessageField 1 (NestedVec files)
    ]
  decodeMessage _ = ParseTreeGraphResponse
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data ParseTreeFileGraph = ParseTreeFileGraph
  { path :: Text
  , language :: Language
  , vertices :: Vector TermVertex
  , edges :: Vector TermEdge
  , errors :: Vector ParseError
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ParseTreeFileGraph where
  encodeMessage _ ParseTreeFileGraph{..} = mconcat
    [ encodeMessageField 1 path
    , encodeMessageField 2 language
    , encodeMessageField 3 (NestedVec vertices)
    , encodeMessageField 4 (NestedVec edges)
    , encodeMessageField 5 (NestedVec errors)
    ]
  decodeMessage _ = ParseTreeFileGraph
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> (nestedvec <$> at decodeMessageField 3)
    <*> (nestedvec <$> at decodeMessageField 4)
    <*> (nestedvec <$> at decodeMessageField 5)
  dotProto = undefined

data TermEdge = TermEdge
  { source :: Int64
  , target :: Int64
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message TermEdge where
  encodeMessage _ TermEdge{..} = mconcat
    [ encodeMessageField 1 source
    , encodeMessageField 2 target
    ]
  decodeMessage _ = TermEdge
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data TermVertex = TermVertex
  { vertexId :: Int64
  , term :: Text
  , span :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message TermVertex where
  encodeMessage _ TermVertex{..} = mconcat
    [ encodeMessageField 1 vertexId
    , encodeMessageField 2 term
    , encodeMessageField 3 (Nested span)
    ]
  decodeMessage _ = TermVertex
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
  dotProto = undefined

data ParseError = ParseError
  { error :: Text
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ParseError where
  encodeMessage _ ParseError{..} = mconcat
    [ encodeMessageField 1 error
    ]
  decodeMessage _ = ParseError
    <$> at decodeMessageField 1
  dotProto = undefined

data DiffTreeRequest = DiffTreeRequest
  { blobs :: Vector BlobPair
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeRequest where
  encodeMessage _ DiffTreeRequest{..} = mconcat
    [ encodeMessageField 1 (NestedVec blobs)
    ]
  decodeMessage _ = DiffTreeRequest
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data DiffTreeTOCResponse = DiffTreeTOCResponse
  { files :: Vector TOCSummaryFile
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeTOCResponse where
  encodeMessage _ DiffTreeTOCResponse{..} = mconcat
    [ encodeMessageField 1 (NestedVec files)
    ]
  decodeMessage _ = DiffTreeTOCResponse
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data TOCSummaryFile = TOCSummaryFile
  { path :: Text
  , language :: Language
  , changes :: Vector TOCSummaryChange
  , errors :: Vector TOCSummaryError
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message TOCSummaryFile where
  encodeMessage _ TOCSummaryFile{..} = mconcat
    [ encodeMessageField 1 path
    , encodeMessageField 2 language
    , encodeMessageField 3 (NestedVec changes)
    , encodeMessageField 4 (NestedVec errors)
    ]
  decodeMessage _ = TOCSummaryFile
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> (nestedvec <$> at decodeMessageField 3)
    <*> (nestedvec <$> at decodeMessageField 4)
  dotProto = undefined

data TOCSummaryChange = TOCSummaryChange
  { category :: Text
  , term :: Text
  , span :: Maybe Span
  , changeType :: ChangeType
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message TOCSummaryChange where
  encodeMessage _ TOCSummaryChange{..} = mconcat
    [ encodeMessageField 1 category
    , encodeMessageField 2 term
    , encodeMessageField 3 (Nested span)
    , encodeMessageField 4 changeType
    ]
  decodeMessage _ = TOCSummaryChange
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
    <*> at decodeMessageField 4
  dotProto = undefined

data TOCSummaryError = TOCSummaryError
  { error :: Text
  , span :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message TOCSummaryError where
  encodeMessage _ TOCSummaryError{..} = mconcat
    [ encodeMessageField 1 error
    , encodeMessageField 2 (Nested span)
    ]
  decodeMessage _ = TOCSummaryError
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data DiffTreeGraphResponse = DiffTreeGraphResponse
  { files :: Vector DiffTreeFileGraph
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeGraphResponse where
  encodeMessage _ DiffTreeGraphResponse{..} = mconcat
    [ encodeMessageField 1 (NestedVec files)
    ]
  decodeMessage _ = DiffTreeGraphResponse
    <$> (nestedvec <$> at decodeMessageField 1)
  dotProto = undefined

data DiffTreeFileGraph = DiffTreeFileGraph
  { path :: Text
  , language :: Language
  , vertices :: Vector DiffTreeVertex
  , edges :: Vector DiffTreeEdge
  , errors :: Vector ParseError
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeFileGraph where
  encodeMessage _ DiffTreeFileGraph{..} = mconcat
    [ encodeMessageField 1 path
    , encodeMessageField 2 language
    , encodeMessageField 3 (NestedVec vertices)
    , encodeMessageField 4 (NestedVec edges)
    , encodeMessageField 5 (NestedVec errors)
    ]
  decodeMessage _ = DiffTreeFileGraph
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> (nestedvec <$> at decodeMessageField 3)
    <*> (nestedvec <$> at decodeMessageField 4)
    <*> (nestedvec <$> at decodeMessageField 5)
  dotProto = undefined

data DiffTreeEdge = DiffTreeEdge
  { source :: Int64
  , target :: Int64
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeEdge where
  encodeMessage _ DiffTreeEdge{..} = mconcat
    [ encodeMessageField 1 source
    , encodeMessageField 2 target
    ]
  decodeMessage _ = DiffTreeEdge
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data DiffTreeVertexDiffTerm
  = Deleted { deleted :: Maybe DeletedTerm }
  | Inserted { inserted :: Maybe InsertedTerm }
  | Replaced { replaced :: Maybe ReplacedTerm }
  | Merged { merged :: Maybe MergedTerm }
  deriving stock (Eq, Ord, Show, Generic)
  deriving anyclass (Message, Named, FromJSON, ToJSON, NFData)

data DiffTreeVertex = DiffTreeVertex
  { diffVertexId :: Int64
  , diffTerm :: Maybe DiffTreeVertexDiffTerm
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DiffTreeVertex where
  encodeMessage _ DiffTreeVertex{..} = mconcat
    [ encodeMessageField 1 diffVertexId
    , case diffTerm of
         Nothing -> mempty
         Just (Deleted deleted) -> encodeMessageField 2 deleted
         Just (Inserted inserted) -> encodeMessageField 3 inserted
         Just (Replaced replaced) -> encodeMessageField 4 replaced
         Just (Merged merged) -> encodeMessageField 5 merged
    ]
  decodeMessage _ = DiffTreeVertex
    <$> at decodeMessageField 1
    <*> oneof
         Nothing
         [ (2, Just . Deleted <$> decodeMessageField)
         , (3, Just . Inserted <$> decodeMessageField)
         , (4, Just . Replaced <$> decodeMessageField)
         , (5, Just . Merged <$> decodeMessageField)
         ]
  dotProto = undefined

data DeletedTerm = DeletedTerm
  { term :: Text
  , span :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message DeletedTerm where
  encodeMessage _ DeletedTerm{..} = mconcat
    [ encodeMessageField 1 term
    , encodeMessageField 2 (Nested span)
    ]
  decodeMessage _ = DeletedTerm
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data InsertedTerm = InsertedTerm
  { term :: Text
  , span :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message InsertedTerm where
  encodeMessage _ InsertedTerm{..} = mconcat
    [ encodeMessageField 1 term
    , encodeMessageField 2 (Nested span)
    ]
  decodeMessage _ = InsertedTerm
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data ReplacedTerm = ReplacedTerm
  { beforeTerm :: Text
  , beforeSpan :: Maybe Span
  , afterTerm :: Text
  , afterSpan :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message ReplacedTerm where
  encodeMessage _ ReplacedTerm{..} = mconcat
    [ encodeMessageField 1 beforeTerm
    , encodeMessageField 2 (Nested beforeSpan)
    , encodeMessageField 3 afterTerm
    , encodeMessageField 4 (Nested afterSpan)
    ]
  decodeMessage _ = ReplacedTerm
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
    <*> at decodeMessageField 4
  dotProto = undefined

data MergedTerm = MergedTerm
  { term :: Text
  , beforeSpan :: Maybe Span
  , afterSpan :: Maybe Span
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message MergedTerm where
  encodeMessage _ MergedTerm{..} = mconcat
    [ encodeMessageField 1 term
    , encodeMessageField 2 (Nested beforeSpan)
    , encodeMessageField 3 (Nested afterSpan)
    ]
  decodeMessage _ = MergedTerm
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
  dotProto = undefined

data Blob = Blob
  { content :: Text
  , path :: Text
  , language :: Language
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message Blob where
  encodeMessage _ Blob{..} = mconcat
    [ encodeMessageField 1 content
    , encodeMessageField 2 path
    , encodeMessageField 3 language
    ]
  decodeMessage _ = Blob
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
  dotProto = undefined

data BlobPair = BlobPair
  { before :: Maybe Blob
  , after :: Maybe Blob
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message BlobPair where
  encodeMessage _ BlobPair{..} = mconcat
    [ encodeMessageField 1 (Nested before)
    , encodeMessageField 2 (Nested after)
    ]
  decodeMessage _ = BlobPair
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data File = File
  { path :: Text
  , language :: Language
  , symbols :: Vector Symbol
  , errors :: Vector ParseError
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message File where
  encodeMessage _ File{..} = mconcat
    [ encodeMessageField 1 path
    , encodeMessageField 2 language
    , encodeMessageField 3 (NestedVec symbols)
    , encodeMessageField 4 (NestedVec errors)
    ]
  decodeMessage _ = File
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> (nestedvec <$> at decodeMessageField 3)
    <*> (nestedvec <$> at decodeMessageField 4)
  dotProto = undefined

data Symbol = Symbol
  { symbol :: Text
  , kind :: Text
  , line :: Text
  , span :: Maybe Span
  , docs :: Maybe Docstring
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message Symbol where
  encodeMessage _ Symbol{..} = mconcat
    [ encodeMessageField 1 symbol
    , encodeMessageField 2 kind
    , encodeMessageField 3 line
    , encodeMessageField 4 (Nested span)
    , encodeMessageField 5 (Nested docs)
    ]
  decodeMessage _ = Symbol
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
    <*> at decodeMessageField 3
    <*> at decodeMessageField 4
    <*> at decodeMessageField 5
  dotProto = undefined

data Docstring = Docstring
  { docstring :: Text
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message Docstring where
  encodeMessage _ Docstring{..} = mconcat
    [ encodeMessageField 1 docstring
    ]
  decodeMessage _ = Docstring
    <$> at decodeMessageField 1
  dotProto = undefined

data Position = Position
  { line :: Int64
  , column :: Int64
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message Position where
  encodeMessage _ Position{..} = mconcat
    [ encodeMessageField 1 line
    , encodeMessageField 2 column
    ]
  decodeMessage _ = Position
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data Span = Span
  { start :: Maybe Position
  , end :: Maybe Position
  } deriving stock (Eq, Ord, Show, Generic)
    deriving anyclass (Named, FromJSON, ToJSON, NFData)

instance Message Span where
  encodeMessage _ Span{..} = mconcat
    [ encodeMessageField 1 (Nested start)
    , encodeMessageField 2 (Nested end)
    ]
  decodeMessage _ = Span
    <$> at decodeMessageField 1
    <*> at decodeMessageField 2
  dotProto = undefined

data ChangeType
  = None
  | Added
  | Removed
  | Modified
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Named, MessageField, FromJSON, ToJSON, NFData)
  deriving Primitive via PrimitiveEnum ChangeType
instance HasDefault ChangeType where def = None

data Language
  = Unknown
  | Go
  | Haskell
  | Java
  | Javascript
  | Json
  | Jsx
  | Markdown
  | Python
  | Ruby
  | Typescript
  | Php
  deriving stock (Eq, Ord, Show, Enum, Bounded, Generic)
  deriving anyclass (Named, MessageField, FromJSON, ToJSON, NFData)
  deriving Primitive via PrimitiveEnum Language
instance HasDefault Language where def = Unknown
