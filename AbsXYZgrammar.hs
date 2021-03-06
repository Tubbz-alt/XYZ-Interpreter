

module AbsXYZgrammar where

-- Haskell module generated by the BNF converter




newtype Ident = Ident String deriving (Eq, Ord, Show, Read)
data Program = Program [Stmt]
  deriving (Eq, Ord, Show, Read)

data Block = Block [Stmt]
  deriving (Eq, Ord, Show, Read)

data Stmt
    = Empty
    | BStmt Block
    | Decl Type [Item]
    | Ass Ident Expr
    | Ret Expr
    | VRet
    | Cond Expr Block
    | CondElse Expr Block Block
    | While Expr Block
    | ForGen Type Ident Expr Block
    | SExp Expr
    | Function Type Ident [Arg] Block
    | GeneratorDef Type Ident [Arg] Block
    | Yield Expr
    | Print Expr
    | PrintLn Expr
  deriving (Eq, Ord, Show, Read)

data Item = NoInit Ident | Init Ident Expr
  deriving (Eq, Ord, Show, Read)

data Arg = ValArg Type Ident | RefArg Type Ident
  deriving (Eq, Ord, Show, Read)

data Type = Int | Str | Bool | Void | Generator Type
  deriving (Eq, Ord, Show, Read)

data Expr
    = ENextGen Ident
    | ENextDefaultGen Ident Expr
    | EVar Ident
    | ELitInt Integer
    | ELitTrue
    | ELitFalse
    | EApp Ident [Expr]
    | EString String
    | Neg Expr
    | Not Expr
    | EMul Expr MulOp Expr
    | EAdd Expr AddOp Expr
    | ERel Expr RelOp Expr
    | EAnd Expr Expr
    | EOr Expr Expr
  deriving (Eq, Ord, Show, Read)

data AddOp = Plus | Minus
  deriving (Eq, Ord, Show, Read)

data MulOp = Times | Div | Mod
  deriving (Eq, Ord, Show, Read)

data RelOp = LTH | LE | GTH | GE | EQU | NE
  deriving (Eq, Ord, Show, Read)

