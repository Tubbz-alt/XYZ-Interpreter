module Types where

import AbsGrammar

import Data.Map as Map
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Except

data Mode = Interactive | FileMode

type IdentString = String
type Location = Integer

type Env = Map IdentString Location

data Memory = IntVar Integer | BoolVar Bool | StringVar String
type PState = (Map Location Memory, Location, Mode)

data RuntimeException = OperationNotSupportedException | ZeroDivException | ZeroModException

type PStateMonad = ReaderT Env (StateT PState (ExceptT RuntimeException IO)) (Maybe Memory)
