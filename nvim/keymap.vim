" | cmd   | command   | normal | visual | operator pending | insert only | command line |
" |-------|-----------|--------|--------|------------------|-------------|--------------|
" | :map  | :noremap  | √      | √      | √                |             |              |
" | :nmap | :nnoremap | √      |        |                  |             |              |
" | :vmap | :vnoremap |        | √      |                  |             |              |
" | :omap | :onoremap |        |        | √                |             |              |
" | :map! | :noremap! |        |        |                  | √           | √            |
" | :imap | :inoremap |        |        |                  | √           |              |
" | :cmap | :cnoremap |        |        |                  |             | √            |

"--------------------
" Default
"--------------------

" source vimrc
nmap <leader>s :source $MYVIMRC<cr>

" no highlight
nmap <leader><cr> :nohlsearch<cr>

" exit terminal
tnoremap <Esc> <C-\><C-n>

" async run
:command -nargs=* Run call Run(<f-args>)
function! Run(...)
    execute 'AsyncRun -mode=term -focus=1 -rows=10' join(a:000)
endfunction

" mouse toggle
nmap <leader>m :call MouseToggle()<cr>
:command MouseToggle call MouseToggle()
function MouseToggle()
    if &mouse == ""
        let &mouse = "nvi"
    else
        let &mouse = ""
    endif
    echom "mouse_mode:" &mouse
endfunction

" read command output
:command -nargs=1 -complete=command ReadCommand redir @">|exe "<args>"|:redir END<CR>

"--------------------
" Bash
"--------------------

:command -nargs=* Bash call Bash (<f-args>)
function! Bash(...)
    let current_file = expand("%:t")
    if a:0
        execute 'AsyncRun -mode=term -focus=0 -rows=10 bash' a:1
    else
        execute 'AsyncRun -mode=term -focus=0 -rows=10 bash' current_file
    endif
endfunction

:command -nargs=* SuBash call SuBash (<f-args>)
function! SuBash(...)
    let current_file = expand("%:t")
    if a:0
        execute 'AsyncRun -mode=term -focus=0 -rows=10 sudo bash' a:1
    else
        execute 'AsyncRun -mode=term -focus=0 -rows=10 sudo bash' current_file
    endif
endfunction

"--------------------
" Golang
"--------------------

:command -nargs=* GoTest call GoTest(<f-args>)
function! GoTest(...)
    let cmds = ['AsyncRun']
    call add(cmds, '-mode=term')
    call add(cmds, '-focus=0')
    call add(cmds, '-rows=10')
    call add(cmds, 'go test')
    call add(cmds, '-v')
    if a:0 > 0
        let test_location = a:1
        call add(cmds, test_location)
    endif
    if a:0 > 1
        let test_name = a:2
        if test_name != '--'
            call add(cmds, '-test.run')
            call add(cmds, test_name)
        endif
    endif
    if a:0 > 2
        for i in range(3, a:0)
            call add(cmds, a:[i])
        endfor
    endif

    execute join(cmds, " ")
endfunction

:command -nargs=* GoRun call GoRun(<f-args>)
function! GoRun(...)
    if a:0
        execute 'AsyncRun -mode=term -focus=0 -rows=10 go run' a:1
    else
        execute 'AsyncRun -mode=term -focus=0 -rows=10 go run .'
    endif
endfunction

:command -nargs=* GoNotImpl call GoNotImpl()
function! GoNotImpl()
    execute "normal opanic(\"not implement\")"
endfunction

:command -nargs=* GoErrh call GoErrh(<f-args>)
function! GoErrh(...)
    if a:0
        if a:1 == 1
            execute "normal oif err != nil { return err }"
        elseif a:1 == 2
            execute "normal oif err != nil { return nil, err }"
        elseif a:1 == 3
            execute "normal oif err != nil { return nil, nil, err }"
        endif
    else
        execute "normal oif err != nil { return err }"
    endif
endfunction

:command -range -nargs=* GoTagsAdd <line1>,<line2>call GoTagsAdd(<f-args>)
function! GoTagsAdd(...) range
    execute 'w'
    let filename = expand('%:t')
    let line = a:firstline . ',' . a:lastline
    let cmds = ['!gomodifytags']
    call add(cmds, '-file')
    call add(cmds, filename)
    call add(cmds, '-line')
    call add(cmds, line)
    call add(cmds, '--skip-unexported')
    call add(cmds, '-w --quiet')
    let cmd = join(cmds, " ")

    if a:0 > 0
        let tags = a:1
        if tags != '--'
            call add(cmds, '-add-tags')
            call add(cmds, tags)
        endif
    else
        call add(cmds, '-add-tags json')
    endif

    if a:0 > 1
        let options = a:2
        if options != '--'
            call add(cmds, '-add-options')
            call add(cmds, options)
        endif
    else
        call add(cmds, '-add-options json=omitempty')
    endif

    if a:0 > 2
        let transform = a:3
        if transform != '--'
            call add(cmds, '-transform')
            call add(cmds, transform)
        endif
    else
        call add(cmds, '-transform camelcase')
    endif

    execute join(cmds, " ")
    return
endfunction

:command -range -nargs=* GoTagsRemove <line1>,<line2>call GoTagsRemove(<f-args>)
function! GoTagsRemove(...) range
    execute 'w'
    let filename = expand('%:t')
    let line = a:firstline . ',' . a:lastline
    let cmds = ['!gomodifytags']
    call add(cmds, '-file')
    call add(cmds, filename)
    call add(cmds, '-line')
    call add(cmds, line)
    call add(cmds, '-transform camelcase')
    call add(cmds, '--skip-unexported')
    call add(cmds, '-w --quiet')
    let cmd = join(cmds, " ")

    let tags = 'json'
    if a:0 > 0
        let tags = a:1
        if tags != '--'
            call add(cmds, '-remove-tags')
            call add(cmds, tags)
        endif
    endif

    let options = 'json=omitempty'
    if a:0 > 1
        let options = a:2
        if options != '--'
            call add(cmds, '-remove-options')
            call add(cmds, options)
        endif
    endif

    execute join(cmds, " ")
    return
endfunction

"--------------------
" Python
"--------------------

:command -nargs=* PyRun call PyRun(<f-args>)
function! PyRun(...)
    if a:0
        execute 'AsyncRun -mode=term -focus=0 -rows=10 python3' a:1
    else
        execute 'AsyncRun -mode=term -focus=0 -rows=10 python3 .'
    endif
endfunction

"--------------------
" Print
"--------------------

" date
:command PrintDate call PrintDate()
function! PrintDate()
    let l:date = system('date --iso-8601=seconds')
    let l:date = substitute(l:date, '\n$', '', '')
    execute 'normal a' . l:date
endfunction

" uuid
:command PrintUuid call PrintUuid()
function! PrintUuid()
    let l:uuid = system('uuidgen')
    let l:uuid = substitute(l:uuid, '\n$', '', '')
    execute 'normal a' . l:uuid
endfunction

" rand
:command -nargs=* PrintRand call PrintRand(<f-args>)
function! PrintRand(...)
    let l:count = 12
    if a:0
        let l:count = a:1
    endif
    let l:cmd = 'tr -dc A-Za-z0-9 </dev/urandom | head -c ' . l:count
    let l:rand = system(l:cmd)
    execute 'normal a' . l:rand
endfunction

:command -nargs=* PrintRandHex call PrintRandHex(<f-args>)
function! PrintRandHex(...)
    let l:count = 12
    if a:0
        let l:count = a:1
    endif
    let l:cmd = 'tr -dc 0-9a-f </dev/urandom | head -c ' . l:count
    let l:rand = system(l:cmd)
    execute 'normal a' . l:rand
endfunction

:command -nargs=* PrintRandNum call PrintRandNum(<f-args>)
function! PrintRandNum(...)
    let l:count = 12
    if a:0
        let l:count = a:1
    endif
    let l:cmd = 'tr -dc 0-9 </dev/urandom | head -c ' . l:count
    let l:rand = system(l:cmd)
    execute 'normal a' . l:rand
endfunction

"--------------------
" Format
"--------------------

" remove trailing spaces
:command RemoveTrailingSpaces call RemoveTrailingSpaces()
function! RemoveTrailingSpaces()
    %s/[ \t]*$//
    nohlsearch
    execute "normal \<C-o>"
endfunction

" escape
:command -range Escape <line1>,<line2> call Escape()
function! Escape() range
    silent! execute a:firstline ',' a:lastline 'substitute /\\"/"/g'
    silent! execute a:firstline ',' a:lastline 'substitute /\\n/\r/g'
    silent! execute a:firstline ',' a:lastline 'substitute /\\t/\t/g'
endfunction

" remove control characters
command! -nargs=0 -range -bar RemoveControlCharacters <line1>,<line2>call RemoveControlCharacters()
function! RemoveControlCharacters() range
    silent! execute a:firstline ',' a:lastline 'substitute /[[:cntrl:]]//g'
endfunction

" remove color
command! -nargs=0 -range -bar RemoveColor <line1>,<line2>call RemoveColor()
function! RemoveColor() range
    silent! execute a:firstline ',' a:lastline 'substitute /\[[^mK]*[mK]//g'
endfunction

" format ci log raw
:command FormatCiLogRaw call FormatCiLogRaw()
function! FormatCiLogRaw()
    %s/section_.*:\([0-9]*\):.*//g
    %s/\[[^mK]*[mK]//g
    %s/[ \t]*$//
    nohlsearch
    execute "normal \<C-o>"
endfunction

" fix tab
:command FixIndent call FixIndent()
function! FixIndent()
    execute "normal gg=G<C-o><C-o>zz"
endfunction

" base64 encode
command! -nargs=0 -range -bar Base64Encode <line1>,<line2>call Base64Encode()
function! Base64Encode() range
    " go to first line, last line, delete into @b, insert text
    " note the substitute() call to join the b64 into one line
    " this lets `:Base64Encode | Base64Decode` work without modifying the text
    " at all, regardless of line length -- although that particular command is
    " useless, lossless editing is a plus
    exe "normal! " . a:firstline . "GV" . a:lastline . "G"
    \ . "\"bdO0\<C-d>\<C-r>\<C-o>"
    \ . "=substitute(system('base64', @b), "
    \ . "'\\n', '', 'g')\<CR>\<ESC>"
endfunction

" base64 decode
command! -nargs=0 -range -bar Base64Decode <line1>,<line2>call Base64Decode()
function! Base64Decode() range
    let l:join = "\"bc"
    if a:firstline != a:lastline
        " gJ exits vis mode so we need a cc to change two lines
        let l:join = "gJ" . l:join . "c"
    endif
    exe "normal! " . a:firstline . "GV" . a:lastline . "G" . l:join
    \ . "0\<C-d>\<C-r>\<C-o>"
    \ . "=system('base64 --decode', @b)\<CR>\<BS>\<ESC>"
endfunction

" unix format
nmap <leader>ff :set ff=unix<cr>:set ff?<cr>

" remove ^M
nmap <leader>fm :%s/<C-V><C-M>//ge<CR>

" indent
nmap =b =iB<C-o>
