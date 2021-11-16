let g:Valign_PadChar = " "


function! valign#SayHi() abort
  return "Hi!"
endfunction


function! valign#GetTopLeft()
  let [line_start, column_start] = getpos("'<")[1:2]
  return [line_start, column_start]
endfunction


function! valign#GetBottomRight()
  " Why is this not a built-in Vim script function?!
  let [line_end, column_end] = getpos("'>")[1:2]
  " let column_end = column_end - (&selection == 'inclusive' ? 1 : 2)
  return [line_end, column_end]
endfunction

function! valign#GetVCoords(visualmode) abort
    let [line_start, column_start] = valign#GetTopLeft()
    let [line_end, column_end] = valign#GetBottomRight()

    let ret = []
    for i in range(line_end - line_start + 1)
        let line = line_start + i
        let far_left = 1
        let far_right = len(getline(line_start + i))

        if a:visualmode ==# "V"
            let left = far_left
            let right = far_right

        elseif a:visualmode ==# "v"
            if line_start == line_end
                let left = column_start
                let right = column_end
            else
                if i == 0
                    let left = column_start
                    let right = far_right
                elseif i == line_end - line_start
                    let left = far_left
                    let right = min([column_end, far_right])
                else
                    let left = far_left
                    let right = far_right
                endif
            endif

        elseif a:visualmode == "\<C-V>"
            let left = min([column_start, column_end])
            let right = min([max([column_start, column_end]), far_right])

        else
            throw "unexpected mode: " . a:visualmode
        endif

        call add(ret, [line_start + i, left, right])
    endfor
    return ret
endfunction


function! valign#GetPadding(coords) abort
    let starts = map(copy(a:coords), {idx, v -> v[1]})
    let ends = map(copy(a:coords), {idx, v -> v[2]})
    let far_left = max(starts)
    let left_pad = map(copy(starts), {idx, v -> far_left - v})

    let ends = map(copy(a:coords), {idx, v -> v[2]})
    let new_ends = map(copy(ends), {idx, v -> left_pad[idx] + v})
    let far_right = max(new_ends)
    let right_pad = map(new_ends, {idx, v -> far_right - v})
    return [left_pad, right_pad]
endfunction


function! valign#PadOut() abort
    let coords = valign#GetVCoords(visualmode())
    let pads = valign#GetPadding(coords)
    let n = len(coords)
    for i in range(n)
        let [line_num, left, right] = coords[i]
        let left_pad = pads[0][i]
        let right_pad = pads[1][i]
        let s = getline(line_num)
        let replacement = [
                    \ (left == 1 ? "" : s[:left - 2]),
                    \ repeat(g:Valign_PadChar, left_pad),
                    \ s[left - 1 : right - 1],
                    \ repeat(g:Valign_PadChar, right_pad),
                    \ s[right:],
                    \ ]
        call setline(line_num, join(replacement, ""))
    endfor
    return [
                \ coords[0][0],
                \ coords[-1][0], 
                \ left + left_pad,
                \ left + left_pad + right - left + right_pad,
                \ ]
endfunction


function! valign#Match(top, bottom, left, right, ptrn) abort
    let ixs = []
    "       01vvv
    " echo '12345'[2:4]  345
    for i in range(a:bottom - a:top + 1)
        let s = getline(a:top + i)
        let j = match(s[a:left-1 : a:right-1], a:ptrn)
        call add(ixs, (j == -1 ? -1 : j + 1))
        " echom "Search for '" . ptrn . "' in:"
        " echom "'" . s "."
        " echom "'" . s[left-1:right-1] . "."
    endfor
    return ixs
endfunction


function! valign#Align() abort
    let [top, bottom, left, right] = valign#PadOut()
    let ptrn = getreg('/')
    let match_offsets = valign#Match(top, bottom, left, right, ptrn)
    if max(match_offsets) == -1
        " no matches, so nothing to do
        return
    endif
    let most_right = max(match_offsets)
    let most_left = min(filter(copy(match_offsets), {idx, val -> val >= 0}))
    for i in range(len(match_offsets))
        let line_num = top + i
        let mo = match_offsets[i]
        if mo == -1  " no matches
            let left_pad = 0
            let right_pad = most_right - most_left
        else
            let left_pad = most_right - mo
            let right_pad = mo - most_left
        endif
        echom "i=".i." ".left_pad." ".right_pad
        let s = getline(line_num)
        let replacement = [
                    \ (left == 1 ? "" : s[:left - 2]),
                    \ repeat(g:Valign_PadChar, left_pad),
                    \ s[left - 1 : right - 1],
                    \ repeat(g:Valign_PadChar, right_pad),
                    \ s[right:],
                    \ ]
        call setline(line_num, join(replacement, ""))
    endfor
endfunction
