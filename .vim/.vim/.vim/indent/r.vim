if exists("b:did_r_indent")
    "finish
endif
let b:did_r_indent = 1

let s:skipflag = 'synIDattr(synID(line("."), col("."), 0), "name") =~ ''Comment\|String'''
let s:envpat = '\%(\%(for\|if\|while\|function\)\s*([^)]*)\|else\)\s*$'
let s:oprpat = '\%(+\|=\|-\||\|&\)\s*$'

let s:openpat = '{\|(\|\['
let s:closepat ='}\|)\|\]'

let b:R_Last_Indent_Line = 1

setlocal indentkeys=0{,0},:,!^F,o,O,e
setlocal indentexpr=GetRIndent()


function! s:CleanText(text)
    let text = substitute(a:text, '\(['."'".'"]\)\%([^\\]\|\\.\)\{-}\1','', 'g')
    let text = substitute(text, '#.*', '', '')
    while text =~ '\%((.*\)\@<=([^()]*)'
        let text = substitute(text, '\%((.*\)\@<=([^()]*)', 'foo', 'g')
    endwhile
    return text
endfunction

function! GetRIndent()

    let lnum_curr = v:lnum
    let lnum_prev = prevnonblank(lnum_curr-1)

    let line_curr = getline(lnum_curr)
    let line_prev = getline(lnum_prev)

    let line_curr = s:CleanText(line_curr)
    let line_prev = s:CleanText(line_prev)

    let n = 0

    " if the prev line is for/if/else/while/function
    if  line_prev =~ s:envpat
        let n += 1
        if line_curr =~ '^\s*{'
            let n -= 1
        endif
        return indent(lnum_prev) + n * &sw

        " if the previous 2 lines are complete
    else if line_prev !~ s:oprpat
        let lnum_prev2 = prevnonblank(lnum_prev-1)
        let line_prev2 = getline(lnum_prev2)
        let line_prev2 = s:CleanText(line_prev2)
        if  line_prev2 !~ s:envpat
            call cursor(lnum_prev2,1)
            let lnum2 = searchpair(s:openpat, '', s:closepat,'nW', s:skipflag, lnum_prev)
            if lnum2 == 0
                call cursor(lnum_curr,1)
                let lnum1 = searchpair(s:openpat, '', s:closepat,'bnW', s:skipflag, lnum_prev2)
                if lnum1 ==0
                    if line_curr =~ '^\s*}'
                        let n -= 1
                    endif
                    return indent(lnum_prev) + n * &sw
                endif
            endif
        endif
    endif


    " do a globol search for unmatched pair
    if lnum_curr< b:R_Last_Indent_Line
        let b:R_Last_Indent_Line = 1
    endif
    call cursor(lnum_curr,1)
    let [lnum, col] = searchpairpos(s:openpat, '', s:closepat,'bnW', s:skipflag, b:R_Last_Indent_Line)
    let curchar = strpart(getline(lnum),col-1,1)

    " if there is a unmatched "(" or "["
    if  curchar!= "{"
        return col
    endif

    " if previous line ends with operator
    if line_prev =~ s:oprpat
        let n += 1
        if line_curr =~ '^\s*{'
            let n -= 1
        endif
        return indent(lnum_prev) + n * &sw
    endif

    " if there is a unmatched "{"
    if lnum != 0
        let n += 1
        if line_curr =~ '^\s*}'
            let n -= 1
        endif
        let indentstep = indent(lnum) + n * &sw
        if indentstep ==0
            let b:R_Last_Indent_Line = lnum_curr
        endif
        return indentstep
    endif

    return 0

endfunction

