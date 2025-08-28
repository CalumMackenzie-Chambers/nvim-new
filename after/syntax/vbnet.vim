" Enhanced VB.NET syntax file
if exists("b:current_syntax")
    finish
endif

" VB is case insensitive
syn case ignore

" Sync method - tells vim how to resynchronize highlighting
syn sync linebreaks=1
syn sync maxlines=500

" Keywords
syn keyword vbKeyword If Then ElseIf Else Select Case
syn keyword vbKeyword AddressOf And ByRef ByVal In Is Like Mod Not Or To Xor
syn keyword vbKeyword True False Nothing
syn keyword vbKeyword Do For ForEach Loop Next Step To Until Wend While
syn keyword vbKeyword CBool CByte CCur CDate CDbl CInt CLng CSng CStr CVDate CVErr
syn keyword vbKeyword Alias As Base Begin Call Const Date Declare Dim Do
syn keyword vbKeyword Each ElseIf End Enum Error Event Exit Explicit For ForEach Function Get Sub
syn keyword vbKeyword GoTo Implements Let Lib Lock Loop Next On OnError
syn keyword vbKeyword Option Private Property Public RaiseEvent Redim Resume Return
syn keyword vbStringKeyword Set Static Step Until Wend While With
syn keyword vbKeyword Binary Date Error Friend Me New Optional ParamArray String WithEvents
syn keyword vbKeyword Class Module Imports Overridable Protected Overrides Structure
syn keyword vbKeyword OrElse AndAlso Interface Namespace ReadOnly AddHandler Overloads
syn keyword vbKeyword RemoveHandler CType DirectCast CDec Handles Async Await MyBase IsNot Of Try Catch Finally Throw
syn keyword vbKeyword Shared Not Using Shadows MustInherit MustOverride Inherits
syn keyword vbKeyword Operator Iterator Narrowing Widening Partial NotInheritable NotOverridable GetType Region

syn keyword vbTodo contained TODO
syn keyword vbTypes Boolean Byte Currency Date Decimal Double Empty
syn keyword vbTypes Integer Long Object Single String Variant

" Simple string matching - just start with " and end with "
syn region vbString start=+"+ end=+"+ 

" String interpolation
syn region vbInterpolatedString start=/\$"/ end=/"/
syn region vbStringInterpolation start=/{/ end=/}/ contained contains=vbKeyword,vbNumber,vbTypes

" Comments
syn region vbComment start="\(^\|\s\)REM\s" end="$" contains=vbTodo
syn region vbComment start="\(^\|\s\)\'" end="$" contains=vbTodo

" Operators
syn match vbOperator "[()+.,\-/*=&]"
syn match vbOperator "[<>]=\="
syn match vbOperator "<>"
syn match vbOperator "\s\+_$"

" Numbers
syn match vbNumber "\<\d\+\>"
syn match vbNumber "\<\d\+\.\d*\>"
syn match vbNumber "\.\d\+\>"
syn match vbFloat "[-+]\=\<\d\+[eE][\-+]\=\d\+"
syn match vbFloat "[-+]\=\<\d\+\.\d*\([eE][\-+]\=\d\+\)\="
syn match vbFloat "[-+]\=\<\.\d\+\([eE][\-+]\=\d\+\)\="

" Type specifiers
syn match vbTypeSpecifier "\<\a\w*[@\$%&!#]"ms=s+1
syn match vbTypeSpecifier "#[a-zA-Z0-9]"me=e-1

" Highlighting
hi def link vbComment           Comment
hi def link vbIdentifier        Identifier
hi def link vbNumber            Number
hi def link vbFloat             Float
hi def link vbOperator          Operator
hi def link vbString            String
hi def link vbInterpolatedString String
hi def link vbStringInterpolation Special
hi def link vbKeyword           Statement
hi def link vbTodo              Todo
hi def link vbTypes             Type
hi def link vbTypeSpecifier     Type

let b:current_syntax = "vbnet"
