(**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

type t =
  | Assertion of string
  | UnexpectedToken of string
  | UnexpectedTokenWithSuggestion of string * string
  | UnexpectedNumber
  | UnexpectedString
  | UnexpectedIdentifier
  | UnexpectedReserved
  | UnexpectedEOS
  | UnexpectedTypeAlias
  | UnexpectedTypeAnnotation
  | UnexpectedTypeDeclaration
  | UnexpectedTypeImport
  | UnexpectedTypeExport
  | UnexpectedTypeInterface
  | NewlineAfterThrow
  | InvalidRegExp
  | InvalidRegExpFlags of string
  | UnterminatedRegExp
  | InvalidLHSInAssignment
  | InvalidLHSInForIn
  | InvalidLHSInForOf
  | InvalidLHSInFormalsList
  | MultipleDefaultsInSwitch
  | NoCatchOrFinally
  | UnknownLabel of string
  | Redeclaration of string * string
  | IllegalContinue
  | IllegalBreak
  | IllegalReturn
  | IllegalYield
  | StrictModeWith
  | StrictCatchVariable
  | StrictVarName
  | StrictParamName
  | StrictParamDupe
  | StrictFunctionName
  | StrictOctalLiteral
  | StrictDelete
  | StrictDuplicateProperty
  | AccessorDataProperty
  | AccessorGetSet
  | StrictLHSAssignment
  | StrictLHSPostfix
  | StrictLHSPrefix
  | StrictReservedWord
  | JSXAttributeValueEmptyExpression
  | InvalidJSXAttributeValue
  | ExpectedJSXClosingTag of string
  | NoUninitializedConst
  | NoUninitializedDestructuring
  | NewlineBeforeArrow
  | StrictFunctionStatement
  | AdjacentJSXElements
  | ParameterAfterRestParameter
  | AsyncGenerator
  | DeclareAsync
  | DeclareExportLet
  | DeclareExportConst
  | DeclareExportType
  | DeclareExportInterface
  | UnexpectedExportStarAs

exception Error of (Loc.t * t) list

let error loc e =
  raise (Error [loc, e])

module PP =
  struct
    let error = function
      | Assertion str -> "Unexpected parser state: "^str
      | UnexpectedToken token->  "Unexpected token "^token
      | UnexpectedTokenWithSuggestion (token, suggestion) ->
          Printf.sprintf "Unexpected token `%s`. Did you mean `%s`?"
            token
            suggestion
      | UnexpectedNumber ->  "Unexpected number"
      | UnexpectedString ->  "Unexpected string"
      | UnexpectedIdentifier ->  "Unexpected identifier"
      | UnexpectedReserved ->  "Unexpected reserved word"
      | UnexpectedEOS ->  "Unexpected end of input"
      | UnexpectedTypeAlias -> "Type aliases are not allowed in untyped mode"
      | UnexpectedTypeAnnotation -> "Type annotations are not allowed in untyped mode"
      | UnexpectedTypeDeclaration -> "Type declarations are not allowed in untyped mode"
      | UnexpectedTypeImport -> "Type imports are not allowed in untyped mode"
      | UnexpectedTypeExport -> "Type exports are not allowed in untyped mode"
      | UnexpectedTypeInterface -> "Interfaces are not allowed in untyped mode"
      | NewlineAfterThrow ->  "Illegal newline after throw"
      | InvalidRegExp -> "Invalid regular expression"
      | InvalidRegExpFlags flags -> "Invalid flags supplied to RegExp constructor '"^flags^"'"
      | UnterminatedRegExp ->  "Invalid regular expression: missing /"
      | InvalidLHSInAssignment ->  "Invalid left-hand side in assignment"
      | InvalidLHSInForIn ->  "Invalid left-hand side in for-in"
      | InvalidLHSInForOf ->  "Invalid left-hand side in for-of"
      | InvalidLHSInFormalsList -> "Invalid left-hand side in formals list"
      | MultipleDefaultsInSwitch -> "More than one default clause in switch statement"
      | NoCatchOrFinally ->  "Missing catch or finally after try"
      | UnknownLabel label -> "Undefined label '"^label^"'"
      | Redeclaration (what, name)-> what^" '"^name^"' has already been declared"
      | IllegalContinue -> "Illegal continue statement"
      | IllegalBreak -> "Illegal break statement"
      | IllegalReturn -> "Illegal return statement"
      | IllegalYield -> "Illegal yield expression"
      | StrictModeWith ->  "Strict mode code may not include a with statement"
      | StrictCatchVariable ->  "Catch variable may not be eval or arguments in strict mode"
      | StrictVarName ->  "Variable name may not be eval or arguments in strict mode"
      | StrictParamName ->  "Parameter name eval or arguments is not allowed in strict mode"
      | StrictParamDupe -> "Strict mode function may not have duplicate parameter names"
      | StrictFunctionName ->  "Function name may not be eval or arguments in strict mode"
      | StrictOctalLiteral ->  "Octal literals are not allowed in strict mode."
      | StrictDelete ->  "Delete of an unqualified identifier in strict mode."
      | StrictDuplicateProperty ->  "Duplicate data property in object literal not allowed in strict mode"
      | AccessorDataProperty ->  "Object literal may not have data and accessor property with the same name"
      | AccessorGetSet ->  "Object literal may not have multiple get/set accessors with the same name"
      | StrictLHSAssignment ->  "Assignment to eval or arguments is not allowed in strict mode"
      | StrictLHSPostfix ->  "Postfix increment/decrement may not have eval or arguments operand in strict mode"
      | StrictLHSPrefix ->  "Prefix increment/decrement may not have eval or arguments operand in strict mode"
      | StrictReservedWord ->  "Use of future reserved word in strict mode"
      | JSXAttributeValueEmptyExpression -> "JSX attributes must only be assigned a non-empty expression"
      | InvalidJSXAttributeValue -> "JSX value should be either an expression or a quoted JSX text"
      | ExpectedJSXClosingTag name -> "Expected corresponding JSX closing tag for "^name
      | NoUninitializedConst -> "Const must be initialized"
      | NoUninitializedDestructuring -> "Destructuring assignment must be initialized"
      | NewlineBeforeArrow ->  "Illegal newline before arrow"
      | StrictFunctionStatement -> "In strict mode code, functions can only be"^
          " declared at top level or immediately within another function."
      | AdjacentJSXElements -> "Unexpected token <. Remember, adjacent JSX "^
          "elements must be wrapped in an enclosing parent tag"
      | ParameterAfterRestParameter ->
          "Rest parameter must be final parameter of an argument list"
      | AsyncGenerator -> "A function may not be both async and a generator"
      | DeclareAsync -> "async is an implementation detail and isn't necessary for your declare function statement. It is sufficient for your declare function to just have a Promise return type."
      | DeclareExportLet -> "`declare export let` is not supported. Use \
          `declare export var` instead."
      | DeclareExportConst -> "`declare export const` is not supported. Use \
          `declare export var` instead."
      | DeclareExportType -> "`declare export type` is not supported. Use \
          `export type` instead."
      | DeclareExportInterface -> "`declare export interface` is not supported. Use \
          `export interface` instead."
      | UnexpectedExportStarAs -> "`export * as` is an early-stage proposal \
          and is not enabled by default. To enable support in the parser, use \
          the `esproposal_export_star_as` option"
  end
