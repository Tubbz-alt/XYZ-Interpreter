-- automatically generated by BNF Converter with little changes
module Main where


import System.IO ( stdin, hGetContents, hPutStrLn, stderr )
import System.Environment ( getArgs, getProgName )
import System.Exit ( exitFailure, exitSuccess )

import LexXYZgrammar
import ParXYZgrammar
import SkelXYZgrammar
import PrintXYZgrammar
import AbsXYZgrammar

import Types
import Interpreter
import StaticCheck
import StaticCheckTypes

import ErrM

type ParseFun a = [Token] -> Err a

myLLexer = myLexer

runFile :: Mode -> FilePath -> IO ()
runFile mode f = readFile f >>= run mode

run :: Mode -> String -> IO ()
run mode s = let ts = myLLexer s in case pProgram ts of
           Bad s    -> do
                          hPutStrLn stderr "\nParse failed...\n"
                          exitFailure
           Ok  (Program tree) -> do
                          checkResult <- runStaticCheck tree

                          case checkResult of
                            Left exception -> do
                              hPutStrLn stderr "There was a static check exception\n"

                              case exception of
                                WrongTypeException s -> hPutStrLn stderr $ "Wrong types - " ++ s
                                UndefinedException s -> hPutStrLn stderr $ "Ident '" ++ s ++ "' not defined."
                                FunctionHasNotValueException -> hPutStrLn stderr $ "Function hasn't got any value.\nMaybe you meant 'function_name()' ?"
                                CanNotMakeVariableApplicationException -> hPutStrLn stderr $ "Can't make variable application.\nMaybe try without '()'"
                                WrongArgsCountException s -> hPutStrLn stderr $ "Function '" ++ s ++ "' needs different number of args."
                                ReturnNotInFunctionException -> hPutStrLn stderr $ "Return can be only inside function or main program."
                                YieldNotInGeneratorException -> hPutStrLn stderr $ "Yield can be only inside generators."
                              exitFailure
                            Right _ -> do
                              result <- runInterpret tree mode

                              case result of
                                Left exception -> do
                                  hPutStrLn stderr "There was a runtime exception\n"

                                  case exception of
                                    ZeroDivException -> hPutStrLn stderr "Dividing by 0 is forbidden."
                                    ZeroModException -> hPutStrLn stderr "Modulo by 0 is forbidden."
                                    NoReturnStmtException -> hPutStrLn stderr "Function should end with return statement."
                                    NoGenResultException -> hPutStrLn stderr "Generator next() should return value. Generator ended or do not have yield statement."
                                    WrongRefArgException -> hPutStrLn stderr "Function argument by reference shoulde be variable."
                                  exitFailure
                                Right _ -> do exitSuccess


usage :: IO ()
usage = do
  putStrLn $ unlines
    [ "usage: Call with one of the following argument combinations:"
    , "  --help          Display this help message."
    , "  (no arguments)  Parse stdin."
    , "  (files)         Parse content of files."
    ]
  exitFailure

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--help"] -> usage
    [] -> hGetContents stdin >>= run StdinMode
    fs -> mapM_ (runFile FileMode) fs
