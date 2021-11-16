source plugin/valign.vim

describe 'how to run vim-spec'

  before
    new
    put! = [
                \ 'line 1',
                \ 'line 2',
                \ 'line 3',
                \ ]
    normal gg0
  end

  after
    close!
  end

  it 'should run'
    Expect 1 == 1
  end

  it 'can read the contents of the buffer'
    Expect getline(1) == "line 1"
    Expect getline(".") == "line 1"
    normal! jj
    Expect getline(".") == "line 3"
  end

  it 'can do some debugging'
    execute "normal! Vjj\<Esc>"
    " Debug getpos("`<")
    " Debug getpos("`>")
    " Debug getpos("'<")
    " Debug getpos("'>")
    Expect visualmode() ==# "V"
  end

end


describe 'vis'

  before
    new
    put! = [
                \ 'abcdef',
                \ 'ghijkl',
                \ 'mnopqr',
                \ ]
    normal gg0
  end

  after
    close!
  end

  it 'should get V coords'
    " ABCDEF
    " GHIJKL
    " mnopqri
    execute "normal! Vj\<Esc>"
    Expect visualmode() ==# "V"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 1, 6],
                \ [2, 1, 6],
                \ ]
  end

  it 'should get V coords'
    " abcdef
    " GHIJKL
    " mnopqri
    execute "normal! jV\<Esc>"
    Expect visualmode() ==# "V"
    Expect valign#GetVCoords(visualmode()) == [
                \ [2, 1, 6],
                \ ]
  end

  it 'should get v coords'
    " abCDEF
    " GHIJKL
    " MNopqri
    execute "normal! llvjjh\<Esc>"
    Expect visualmode() ==# "v"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 3, 6],
                \ [2, 1, 6],
                \ [3, 1, 2],
                \ ]
  end
  it 'should get <c-v> coords'
    " aBCdef
    " gHIjkl
    " mNOpqri
    execute "normal! ll\<c-v>jjh\<Esc>"
    Expect visualmode() ==# "\<C-V>"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 2, 3],
                \ [2, 2, 3],
                \ [3, 2, 3],
                \ ]
  end
end


describe 'vis non-rect'

  before
    new
    put! = [
                \ 'abcdef',
                \ 'ghij',
                \ 'mn',
                \ ]
    normal gg0
  end

  after
    close!
  end

  it 'should get V coords'
    " abcdef
    " ghij
    " mn
    execute "normal! Vj\<Esc>"
    Expect visualmode() ==# "V"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 1, 6],
                \ [2, 1, 4],
                \ ]
  end

  it 'should get V coords'
    " abcdef
    " ghij
    " mn
    execute "normal! jV\<Esc>"
    Expect visualmode() ==# "V"
    Expect valign#GetVCoords(visualmode()) == [
                \ [2, 1, 4],
                \ ]
  end

  it 'should get V coords'
    " abcdef
    " ghij
    " mn
    execute "normal! Vjj\<Esc>"
    Expect visualmode() ==# "V"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 1, 6],
                \ [2, 1, 4],
                \ [3, 1, 2],
                \ ]
  end

  it 'should get v coords'
    " aBCDEF
    " GHIJ
    " Mn
    execute "normal! lvjjh\<Esc>"
    Expect visualmode() ==# "v"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 2, 6],
                \ [2, 1, 4],
                \ [3, 1, 1],
                \ ]
  end
  it 'should get v coords'
    " abcDEF
    " GHIJ
    " MN
    execute "normal! lllvjj\<Esc>"
    Expect visualmode() ==# "v"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 4, 6],
                \ [2, 1, 4],
                \ [3, 1, 2],
                \ ]
  end
  it 'should get <c-v> coords'
    " aBCdef
    " gHIj
    " mN
    execute "normal! ll\<c-v>jjh\<Esc>"
    Expect visualmode() ==# "\<C-V>"
    Expect valign#GetVCoords(visualmode()) == [
                \ [1, 2, 3],
                \ [2, 2, 3],
                \ [3, 2, 2],
                \ ]
  end
end


describe 'GetPadding'
    it 'should work'
        " OOO
        " OOO
        " OOO
        let lst = [
                    \ [1, 1, 3],
                    \ [2, 1, 3],
                    \ [3, 1, 3]
                    \ ]
        Expect valign#GetPadding(lst) == [[0, 0, 0], [0, 0, 0]]
    end
    it 'should work2'
        " OOO
        " OO
        " OOO
        let lst = [
                    \ [1, 1, 3],
                    \ [2, 1, 2],
                    \ [3, 1, 3]
                    \ ]
        Expect valign#GetPadding(lst) == [[0, 0, 0], [0, 1, 0]]
    end
    it 'should work3'
        " -OO
        " OO
        " O
        let lst = [
                    \ [1, 2, 3],
                    \ [2, 1, 2],
                    \ [3, 1, 1]
                    \ ]
        Expect valign#GetPadding(lst) == [[0, 1, 1], [0, 0, 1]]
    end
    it 'should work4'
        " -OO
        " OOO
        " O
        let lst = [
                \ [1, 2, 3],
                \ [2, 1, 3],
                \ [3, 1, 1],
                \ ]
        Expect valign#GetPadding(lst) == [[0, 1, 1], [1, 0, 2]]
    end
end


describe 'PadOut'
  before
    new
    put! = [
                \ 'abcdef',
                \ 'ghij',
                \ 'mn',
                \ 'opqrst',
                \ ]
    normal gg0
  end

  after
    close!
  end
  it 'should pad out V'
    " ABCDEF
    " GHIJ
    " mn
    execute "normal! Vj\<Esc>"
    Expect valign#PadOut() == [1, 2, 1, 6]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ 'ghij  ',
                \ 'mn',
                \ ]
  end

  it 'should pad out V'
    " abcdef
    " GHIJ
    " MN
    execute "normal! jVj\<Esc>"
    Expect valign#PadOut() == [2, 3, 1, 4]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ 'ghij',
                \ 'mn  ',
                \ ]
  end

  it 'should pad out v1'
    " --- BEFORE ---
    " aBCDEF
    " GHIj
    " mn
    " --- AFTER ---
    " aBCDEF
    "  GHI  j
    " mn
    execute "normal! lvjl\<Esc>"
    Expect valign#PadOut() == [1, 2, 2, 6]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ ' ghi  j',
                \ 'mn',
                \ ]
  end

  it 'should pad out v2'
    " --- BEFORE ---
    " abcdEF
    " GHIJ
    " Mn
    " --- AFTER ---
    " abcdEF
    "     GHIJ
    "     M   n
    execute "normal! 4lvjjhh\<Esc>"
    Expect valign#PadOut() == [1, 3, 5, 8]
    Expect getline(1,3) ==# [
                \ 'abcdef  ',
                \ '    ghij',
                \ '    m   n',
                \ ]
  end

  it 'should pad out <c-v>1'
    " --- BEFORE ---
    " ABCDEf
    " GHIJ
    " mn
    " --- AFTER ---
    " ABCDEf
    " GHIJ 
    " mn
    execute "normal! \<c-v>j4l\<Esc>"
    Expect valign#PadOut() == [1, 2, 1, 5]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ 'ghij ',
                \ 'mn',
                \ ]
  end

  it 'should pad out <c-v>2'
    " --- BEFORE ---
    " ABcdef
    " GHij
    " MN
    " --- AFTER ---
    " ABcdef
    " GHij
    " MN
    execute "normal! \<c-v>l2j\<Esc>"
    Expect valign#PadOut() == [1, 3, 1, 2]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ 'ghij',
                \ 'mn',
                \ ]
  end

  it 'should pad out <c-v>3'
    " --- BEFORE ---
    " aBCDef
    " gHIJ
    " mn
    " --- AFTER ---
    " aBCDef
    " gHIJ
    " mn
    execute "normal! l\<c-v>llj\<Esc>"
    Expect valign#PadOut() == [1, 2, 2, 4]
    Expect getline(1,3) ==# [
                \ 'abcdef',
                \ 'ghij',
                \ 'mn',
                \ ]
  end

  it 'should pad out <c-v>4'
    " --- BEFORE ---
    " abcDEf
    " ghiJ
    " mn
    " opqRSt
    " --- AFTER ---
    " abcDEf
    " ghiJ 
    " mn   
    " opqRSt
    execute "normal! 3l\<c-v>l3j\<Esc>"
    Expect valign#PadOut() == [1, 4, 4, 5]
    Expect getline(1,4) ==# [
                \ 'abcdef',
                \ 'ghij ',
                \ 'mn   ',
                \ 'opqrst',
                \ ]
  end
end


describe 'Match'
  before
    new
    put! = [
                \ 'abcdef',
                \ 'bcdefg',
                \ 'cdefgh',
                \ ]
    normal gg0
  end

  after
    close!
  end

  it 'should align 1'
    Expect valign#Match(1, 3, 1, 6, "a") == [1, -1, -1]
    Expect valign#Match(1, 3, 1, 6, "b") == [2, 1, -1]
    Expect valign#Match(1, 3, 1, 6, "h") == [-1, -1, 6]
    Expect valign#Match(1, 3, 1, 6, "\\v[ef]{2}g") == [-1, 4, 3]
  end
end

describe 'Align'
  before
    new
    put! = [
                \ 'abcdef',
                \ 'bcdefg',
                \ 'cdefgh',
                \ ]
    normal gg0
  end

  after
    close!
  end

  it 'should align 1'
    execute "normal! Vjj\<Esc>"
    execute "normal! /c\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'abcdef  ',
                \ ' bcdefg ',
                \ '  cdefgh',
                \ ]
  end

  it 'should align 2'
    execute "normal! Vjj\<Esc>"
    execute "normal! /\\v..def\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'abcdef ',
                \ ' bcdefg',
                \ 'cdefgh ',
                \ ]
  end

  it 'should align 3'
    " aBCDef
    " bCDEfg
    " cDEFgh
    execute "normal! l\<c-v>jjll\<Esc>"
    execute "normal! /d\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'abcd  ef',
                \ 'b cde fg',
                \ 'c  defgh',
                \ ]
  end

  it 'should align 4'
    " abcDEF
    " BCDEFG
    " CDEfgh
    execute "normal! lllvjjh\<Esc>"
    execute "normal! /c\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'abcdef    ',
                \ '   bcdefg ',
                \ '    cde   fgh',
                \ ]
  end

  it 'should align 5'
    " abcDEF
    " BCDEFG
    " CDEfgh
    execute "normal! Vjj\<Esc>"
    execute "normal! /bc\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'abcdef ',
                \ ' bcdefg',
                \ 'cdefgh ',
                \ ]
  end

end


describe 'Align with flanking chars'
  before
    new
    put! = [
                \ 'AAA oiooo BBB',
                \ 'AAA ooioo BBB',
                \ 'AAA oooio BBB',
                \ ]
    normal gg0
    let g:Valign_PadChar = "-"
  end

  after
    close!
  end

  it 'should align 1'
    execute "normal! wviw\<c-v>jj\<Esc>"
    execute "normal! /i\<cr>"
    call valign#Align()
    Expect getline(1,3) ==# [
                \ 'AAA --oiooo BBB',
                \ 'AAA -ooioo- BBB',
                \ 'AAA oooio-- BBB',
                \ ]
  end
end

describe 'Align'
  before
    new
    put! = [
                \ 'abcdef',
                \ 'bcdefg',
                \ 'cdefgh',
                \ ]
    normal gg0
    vnoremap gi <esc>:call valign#Align()<CR>
    let g:Valign_PadChar = "."
  end

  after
    close!
  end

  it 'should align 4'
    " abcDEF
    " BCDEFG
    " CDEfgh
    execute "normal! /c\<cr>"
    execute "normal! gg0"
    execute "normal! lllvjjh"
    execute "normal gi"
    Expect getline(1,3) ==# [
                \ 'abcdef....',
                \ '...bcdefg.',
                \ '....cde...fgh',
                \ ]
  end
end
