if exists("b:current_syntax")
  finish
endif
syntax clear
let b:current_syntax = 1


syntax case match
setlocal iskeyword=@,192-255
let mathevn = ['align', 'alignat', 'displaymath', 'displaymath', 'eqnarray', 'equation', 'flalign', 'gather', 'math', 'multline', 'xalignat']
let specialmacro = ['label', 'ref', 'eqref', 'cite\w*', 'eq', 'includegraphics']


syn match texNumber '[0-9]' contained
syn match texChar '[a-zA-Z]' contained contains=@NoSpell
syn match texParen '\(\\\@<!\(\\\\\)*\)\@<=\({\|}\|\[\|\]\)' contained
syn match texLB '\\\@<!\\\\\%(\s*\[.\{-}\]\)\=' contains=texNumber,texChar,texComment
syn region texMatcher matchgroup=texParen start='\(\\\@<!\(\\\\\)*\)\@<={' end='\(\\\@<!\(\\\\\)*\)\@<=}'  contains=TOP

syn region texInput matchgroup=texParen start='\(\\\@<!\(\\\\\)*\)\@<={'  end='\(\\\@<!\(\\\\\)*\)\@<=}'   contained contains=@NoSpell,texComment,texInput nextgroup=texInput
syn region texOption matchgroup=texParen start='\(\\\@<!\(\\\\\)*\)\@<=\['  end='\(\\\@<!\(\\\\\)*\)\@<=\]' contained contains=@NoSpell,texComment nextgroup=texOption,texInput

syn match texMacro '\(\\\@<!\(\\\\\)*\)\@<=\\[a-zA-Z]\+'  contains=@NoSpell
exe 'syn match texSpecialMacro ''\(\\\@<!\(\\\\\)*\)\@<=\\\%(' . join(specialmacro, '\|') . '\)'' contains=@NoSpell,texMacro nextgroup=texOption,texInput'
syn match texMathMacro '\(\\\@<!\(\\\\\)*\)\@<=\\[a-zA-Z]\+' contained contains=@NoSpell
syn match texMathText '\(\\\@<!\(\\\\\)*\)\@<=\\\(text\|mbox\|hbox\)\>\s*' contained contains=texMacro nextgroup=texMatcher
syn match texBeginEnd '\(\\\@<!\(\\\\\)*\)\@<=\(\\begin\|\\end\)\s*{.\{-}}' contains=@NoSpell,texComment,texParen,texEnvName,texMacro nextgroup=texOption
syn match texEnvName '[a-zA-Z]\+' contained contains=@NoSpell



" use texMathZoneX in order to be compartible with Latex-box
syn cluster texMathArgs contains=texComment,texSpecialMacro,texBeginEnd,texMathText,texMathMacro,texNumber,texChar
syn region texMathZoneX start='\(\\\@<!\(\\\\\)*\)\@<=\$' end='\(\\\@<!\(\\\\\)*\)\@<=\$' keepend extend  contains=@NoSpell,@texMathArgs
syn region texMathZone start='\(\\\@<!\(\\\\\)*\)\@<=\$\$' end='\(\\\@<!\(\\\\\)*\)\@<=\$\$' keepend extend contains=@NoSpell,@texMathArgs
syn region texMathZone start='\(\\\@<!\(\\\\\)*\)\@<=\\\[' end='\(\\\@<!\(\\\\\)*\)\@<=\\\]' contains=@NoSpell,@texMathArgs
syn region texMathZone start='\(\\\@<!\(\\\\\)*\)\@<=\\(' end='\(\\\@<!\(\\\\\)*\)\@<=\\)' contains=@NoSpell,@texMathArgs
exe 'syn region texMathZone start=''\(\\\@<!\(\\\\\)*\)\@<=\\begin\s*{\s*\%(' . join(mathevn, '\|') . '\)\*\=\s*}'' end=''\(\\\@<!\(\\\\\)*\)\@<=\\end\s*{\s*\%(' . join(mathevn, '\|') . '\)\*\=\s*}'' keepend extend contains=@NoSpell,@texMathArgs'
syn cluster texMath contains=texMathZoneX,texMathZone

syn match texComment '\(\\\@<!\(\\\\\)*\)\@<=%.*$' extend contains=@NoSpell

hi def link texMathZoneX texMath
hi def link texMathZone texMath

hi def link texMath Special
hi def link texMathMacro Preproc
hi def link texNumber Number
hi def link texChar Number

hi def link texLB Special
hi def link texParen Special

hi def link texEnvName Special
hi def link texMacro Statement
hi def link texInput String
hi def link texComment Comment
