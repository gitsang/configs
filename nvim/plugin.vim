filetype off
filetype plugin indent on
filetype plugin on

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
if empty(glob(data_dir . '/plugged/*'))
  "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let hostname = substitute(system('hostname'), '\n', '', '')
let main_ip = substitute(system('ifconfig ' . net_interface . ' | grep inet | grep -v inet6 | head -n1 | awk ''{print $2}\'''), '\n', '', '')

call plug#begin()

    "--------------------
    " Appearance
    "--------------------

    "[startify]"

        Plug 'mhinz/vim-startify'
            let g:startify_ascii = [
                \ '__     _____ __  __ ',
                \ '\ \   / /_ _|  \/  |',
                \ ' \ \ / / | || |\/| |',
                \ '  \ V /  | || |  | |',
                \ '   \_/  |___|_|  |_|',
                \ '                    ',
                \ ]
            let g:startify_custom_header = 'startify#pad(g:startify_ascii + startify#fortune#boxed())'

    "[easymotion]"

        Plug 'easymotion/vim-easymotion'
        nmap ss <Plug>(easymotion-s2)

    "[color]"

        Plug 'morhetz/gruvbox'

    "[airline]"

        Plug 'vim-airline/vim-airline'
            " statistic
            let g:airline#extensions#whitespace#enabled = 1
            let g:airline#extensions#wordcount#enabled = 1

            " powerline symbols
            let g:airline_powerline_fonts = 1
            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            let g:airline_left_sep = ''
            let g:airline_left_alt_sep = ''
            let g:airline_right_sep = ''
            let g:airline_right_alt_sep = ''
            let g:airline_symbols.branch = ''
            let g:airline_symbols.readonly = ''
            let g:airline_symbols.linenr = '☰'
            let g:airline_symbols.maxlinenr = ''
            let g:airline_symbols.dirty='⚡'

            " tab line
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#overflow_marker = '…'
            let g:airline#extensions#tabline#show_tabs = 1
            let g:airline#extensions#tabline#buffer_idx_mode = 1
            let g:airline#extensions#branch#enabled = 1
            let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]

            " section
            function! AirlineInit()
                let g:airline_section_a = airline#section#create_left(['mode', '%{ZFVimIME_IMEStatusline()}'])
                let g:airline_section_b = airline#section#create_left(['%{strftime("%H:%M:%S")}'])
            endfunction
            autocmd User AirlineAfterInit call AirlineInit()

            nmap <leader>1 <Plug>AirlineSelectTab1
            nmap <leader>2 <Plug>AirlineSelectTab2
            nmap <leader>3 <Plug>AirlineSelectTab3
            nmap <leader>4 <Plug>AirlineSelectTab4
            nmap <leader>5 <Plug>AirlineSelectTab5
            nmap <leader>6 <Plug>AirlineSelectTab6
            nmap <leader>7 <Plug>AirlineSelectTab7
            nmap <leader>8 <Plug>AirlineSelectTab8
            nmap <leader>9 <Plug>AirlineSelectTab9
            nmap <leader>- <Plug>AirlineSelectPrevTab
            nmap <leader>= <Plug>AirlineSelectNextTab
            nmap <leader>` :bdelete<cr>

        Plug 'vim-airline/vim-airline-themes'
            let g:airline_theme='luna'

    "--------------------
    " SideBar
    "--------------------

    "[tree]"

        nmap <leader>b :NERDTreeToggle<cr>:TagbarToggle<cr><C-w>l

        Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

        Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
            let g:NERDTreeGitStatusIndicatorMapCustom = {
                    \ "Modified"  : "✹",
                    \ "Staged"    : "✚",
                    \ "Untracked" : "✭",
                    \ "Renamed"   : "➜",
                    \ "Unmerged"  : "═",
                    \ "Deleted"   : "✖",
                    \ "Dirty"     : "✗",
                    \ "Clean"     : "✔︎",
                    \ "Ignored"   : "☒",
                    \ "Unknown"   : "?"
                    \ }
            nmap <leader>t :NERDTreeToggle<cr>
            nmap <leader>v :NERDTreeFind<cr>

    "[tagbar]"

        Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
            let g:tagbar_type_go = {
                    \ 'ctagstype' : 'go',
                    \ 'kinds'     : [
                        \ 'p:package',
                        \ 'i:imports:1',
                        \ 'c:constants',
                        \ 'v:variables',
                        \ 't:types',
                        \ 'n:interfaces',
                        \ 'w:fields',
                        \ 'e:embedded',
                        \ 'm:methods',
                        \ 'r:constructor',
                        \ 'f:functions'
                    \ ],
                    \ 'sro' : '.',
                    \ 'kind2scope' : {
                        \ 't' : 'ctype',
                        \ 'n' : 'ntype'
                    \ },
                    \ 'scope2kind' : {
                        \ 'ctype' : 't',
                        \ 'ntype' : 'n'
                    \ },
                    \ 'ctagsbin'  : 'gotags',
                    \ 'ctagsargs' : '-sort -silent',
                    \ 'sort' : 0
                \ }
            set tags=tags;
            set autochdir
            nmap <leader>y :TagbarToggle<cr>

        Plug 'lvht/tagbar-markdown'
            let g:tagbar_sort = 0

    "--------------------
    " Tools
    "--------------------

    "[diff]"

        Plug 'will133/vim-dirdiff'

    "[async]"

        Plug 'tpope/vim-dispatch'

        Plug 'skywind3000/asyncrun.vim'
           let g:asyncrun_open = 8
           let g:asyncrun_qfid = 10

    "--------------------
    " Coding Support
    "--------------------

    "[converter]"

        Plug 'gitsang/vim-case-converter'

    "[CoC]"

        Plug 'neoclide/coc.nvim', {'branch': 'release'}
            " coc-extensions
            let g:coc_global_extensions = [
                \ "coc-marketplace",
                \ "coc-explorer",
                \ "coc-sh",
                \ "coc-sql",
                \ "coc-json",
                \ "coc-css",
                \ "coc-html",
                \ "coc-go",
                \ "coc-clangd",
                \ "coc-pyright",
                \ "coc-prettier",
                \ "coc-highlight",
                \ "coc-vimlsp",
                \ "coc-snippets",
                \ "coc-vetur"
                \ ]

            " Coc restart
            nmap <leader>rr :CocRestart<CR>

            " coc-explorer
            " Use <Space-E> to open explorer
            noremap <space>e :CocCommand explorer<CR>
            " Close Coc-explorer if it is the only window
            autocmd BufEnter * if (&ft == 'coc-explorer' && winnr("$") == 1) | q | endif

            " coc-go
            nmap <silent> gp :CocCommand editor.action.organizeImport<CR>
            nmap <silent> gm :CocCommand go.gopls.tidy<CR>

            " Open Command list with Ctrl Shift P
            noremap <C-P> :CocList commands<CR>

            " Use tab for trigger completion with characters ahead and navigate
            " NOTE: There's always complete item selected by default, you may want to enable
            " no select by `"suggest.noselect": true` in your configuration file
            " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
            " other plugin before putting this into your config
            inoremap <silent><expr> <TAB>
                  \ coc#pum#visible() ? coc#pum#next(1) :
                  \ CheckBackspace() ? "\<Tab>" :
                  \ coc#refresh()
            inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

            " Make <CR> to accept selected completion item or notify coc.nvim to format
            " <C-g>u breaks current undo, please make your own choice
            inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                          \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

            function! CheckBackspace() abort
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~# '\s'
            endfunction

            " Use <c-space> to trigger completion
            if has('nvim')
              inoremap <silent><expr> <c-space> coc#refresh()
            else
              inoremap <silent><expr> <c-@> coc#refresh()
            endif

            " Use `[g` and `]g` to navigate diagnostics
            " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " GoTo code navigation
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " Use K to show documentation in preview window
            nnoremap <silent> K :call ShowDocumentation()<CR>

            function! ShowDocumentation()
              if CocAction('hasProvider', 'hover')
                call CocActionAsync('doHover')
              else
                call feedkeys('K', 'in')
              endif
            endfunction

            " Highlight the symbol and its references when holding the cursor
            autocmd CursorHold * silent call CocActionAsync('highlight')

            " Symbol renaming
            nmap <leader>rn <Plug>(coc-rename)

            " Formatting selected code
            xmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>F  <Plug>(coc-format)

            augroup mygroup
              autocmd!
              " Setup formatexpr specified filetype(s)
              autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
              " Update signature help on jump placeholder
              autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            augroup end

            " Applying code actions to the selected code block
            " Example: `<leader>aap` for current paragraph
            xmap <leader>a  <Plug>(coc-codeaction-selected)
            nmap <leader>a  <Plug>(coc-codeaction-selected)

            " Remap keys for applying code actions at the cursor position
            nmap <leader>ac  <Plug>(coc-codeaction-cursor)
            " Remap keys for apply code actions affect whole buffer
            nmap <leader>as  <Plug>(coc-codeaction-source)
            " Apply the most preferred quickfix action to fix diagnostic on the current line
            nmap <leader>qf  <Plug>(coc-fix-current)

            " Remap keys for applying refactor code actions
            nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
            xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
            nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

            " Run the Code Lens action on the current line
            nmap <leader>cl  <Plug>(coc-codelens-action)

            " Map function and class text objects
            " NOTE: Requires 'textDocument.documentSymbol' support from the language server
            xmap if <Plug>(coc-funcobj-i)
            omap if <Plug>(coc-funcobj-i)
            xmap af <Plug>(coc-funcobj-a)
            omap af <Plug>(coc-funcobj-a)
            xmap ic <Plug>(coc-classobj-i)
            omap ic <Plug>(coc-classobj-i)
            xmap ac <Plug>(coc-classobj-a)
            omap ac <Plug>(coc-classobj-a)

            " Remap <C-f> and <C-b> to scroll float windows/popups
            if has('nvim-0.4.0') || has('patch-8.2.0750')
              nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
              inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
              inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
              vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            endif

            " Use CTRL-S for selections ranges
            " Requires 'textDocument/selectionRange' support of language server
            nmap <silent> <C-s> <Plug>(coc-range-select)
            xmap <silent> <C-s> <Plug>(coc-range-select)

            " Add `:Format` command to format current buffer
            command! -nargs=0 Format :call CocActionAsync('format')

            " Add `:Fold` command to fold current buffer
            command! -nargs=? Fold :call     CocAction('fold', <f-args>)

            " Add `:OR` command for organize imports of the current buffer
            command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

            " Add (Neo)Vim's native statusline support
            " NOTE: Please see `:h coc-status` for integrations with external plugins that
            " provide custom statusline: lightline.vim, vim-airline
            "set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

            " Mappings for CoCList
            " Show all diagnostics
            " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
            " Manage extensions
            " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
            " Show commands
            " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
            " Find symbol of current document
            " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
            " Search workspace symbols
            " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
            " Do default action for next item
            " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
            " Do default action for previous item
            " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
            " Resume latest coc list
            " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

    "[linter]"

        Plug 'dense-analysis/ale'
            source ~/.config/nvim/proto.vim

            let g:ale_set_highlights = 0
            let g:ale_set_quickfix = 1
            let g:ale_sign_error = '✖'
            let g:ale_sign_warning = 'ℹ'
            let g:ale_statusline_format = ['✖ %d', 'ℹ %d', '✔ OK']
            let g:ale_echo_msg_error_str = 'E'
            let g:ale_echo_msg_warning_str = 'W'
            let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
            let g:ale_lint_on_enter = 1
            let g:ale_fix_on_save = 1

            nmap <Leader>ep <Plug>(ale_previous_wrap)
            nmap <Leader>en <Plug>(ale_next_wrap)
            nmap <Leader>et :ALEToggle<CR>
            nmap <Leader>ed :ALEDetail<CR>
            let g:ale_linters = {
                \ 'go': ['go vet', 'go fmt'],
                \ }
            let g:ale_fixers = {
                \   '*': ['remove_trailing_lines', 'trim_whitespace'],
                \   'javascript': ['eslint'],
                \}

        Plug 'itspriddle/vim-shellcheck'

    "[formater]"

        " Vim tools for comment stuff out
        Plug 'tpope/vim-commentary'

        " Vim script for text filtering and alignment
        Plug 'godlygeek/tabular'

    "[ai]"

        Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
            let g:codeium_no_map_tab = 1
            imap <script><silent><nowait><expr> <C-g> codeium#Accept()
            imap <C-;>   <Cmd>call codeium#CycleCompletions(1)<CR>
            imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>
            imap <C-x>   <Cmd>call codeium#Clear()<CR>

    "[jupyter]"

        " Plug 'luk400/vim-jukit'

    "[golang]"

        Plug 'sebdah/vim-delve'
            nmap <leader>B :DlvToggleBreakpoint<cr>
            nmap <leader>T :DlvToggleTracepoint<cr>

    "[git]"

        Plug 'airblade/vim-gitgutter'
            let g:gitgutter_max_signs = 500
            " map key
            let g:gitgutter_map_keys = 0
            " colors
            let g:gitgutter_override_sign_column_highlight = 0

            nmap <leader>g <Plug>(GitGutterPreviewHunk)
            nmap <leader><backspace> <Plug>(GitGutterUndoHunk)

    "[rego]"

        Plug 'tsandall/vim-rego'

        Plug 'sbdchd/neoformat'
            let g:neoformat_rego_opa = {
                  \ 'exe': 'opa',
                  \ 'args': ['fmt'],
                  \ 'stdin': 1,
                  \ }
            let g:neoformat_enabled_rego = ['opa']
            " augroup fmt
            "   autocmd!
            "   autocmd BufWritePre * undojoin | Neoformat
            " augroup END

    "[jinja]"

        Plug 'Glench/Vim-Jinja2-Syntax'

    "[markdown]"

        Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
            let g:vim_markdown_folding_disabled = 1
            let g:vim_markdown_toc_autofit = 1
            let g:vim_markdown_follow_anchor = 1

        Plug 'gitsang/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
            let g:mkdp_auto_start = 0
            let g:mkdp_auto_close = 1
            let g:mkdp_refresh_slow = 0
            let g:mkdp_command_for_global = 0
            let g:mkdp_open_to_the_world = 1
            let g:mkdp_open_ip = main_ip
            let g:mkdp_port = '7777'
            let g:mkdp_browser = default_browser
            let g:mkdp_echo_preview_url = 1
            let g:mkdp_browserfunc = ''
            let g:mkdp_preview_options = {
                \ 'mkit': {},
                \ 'katex': {},
                \ 'uml': {},
                \ 'maid': {},
                \ 'disable_sync_scroll': 0,
                \ 'sync_scroll_type': 'middle',
                \ 'hide_yaml_meta': 1,
                \ 'sequence_diagrams': {},
                \ 'flowchart_diagrams': {},
                \ 'content_editable': v:false,
                \ 'disable_filename': 0
                \ }
            let g:mkdp_markdown_css = ''
            let g:mkdp_highlight_css = ''
            let g:mkdp_page_title = '「${name}」'
            let g:mkdp_filetypes = ['markdown']

            nmap <leader>m <Plug>MarkdownPreviewToggle
            nmap <F8> <Plug>MarkdownPreviewToggle

        Plug 'mzlogin/vim-markdown-toc'
            let g:vmt_auto_update_on_save = 1
            let g:vmt_dont_insert_fence = 0
            let g:vmt_fence_text = 'markdown-toc'
            let g:vmt_fence_closing_text = '/markdown-toc'
            let g:vmt_fence_hidden_markdown_style = ''
            let g:vmt_cycle_list_item_markers = 0
            let g:vmt_list_item_char = '-'
            let g:vmt_include_headings_before = 0
            let g:vmt_list_indent_text = '  '
            let g:vmt_link = 1
            let g:vmt_min_level = 1
            let g:vmt_max_level = 6
            " :GenToc

    "[todo]"
        Plug 'nvim-lua/plenary.nvim'
        Plug 'folke/todo-comments.nvim'

    "[im]"

        Plug 'ZSaberLv0/ZFVimIM'
        Plug 'ZSaberLv0/ZFVimJob'
            let g:ZFVimIM_key_pageUp = [',']
            let g:ZFVimIM_key_pageDown = ['.']
            let g:ZFVimIM_showKeyHint = 0
            let g:ZFVimIM_cachePath = $HOME.'/.cache/zfvimim'

            " init
            function! s:zfvimim_init() abort
                let db = ZFVimIM_dbInit({
                            \   'name' : 'Pinyin',
                            \   'editable' : 0,
                            \ })
                call ZFVimIM_cloudRegister({
                            \   'mode' : 'local',
                            \   'dbId' : db['dbId'],
                            \   'repoPath' : expand('~/.local/share/nvim/zfvimim/ZFVimIM_pinyin_base/misc'),
                            \   'dbFile' : 'pinyin.txt',
                            \   'dbCountFile' : 'pinyin_count.txt',
                            \ })
            endfunction
            if exists('*ZFVimIME_initFlag') && ZFVimIME_initFlag()
                call s:zfvimim_init()
            else
                autocmd User ZFVimIM_event_OnDbInit call s:zfvimim_init()
            endif

            " add word checker
            function! NopChecker(userWord)
                return 0
            endfunction
            let g:ZFVimIM_autoAddWordChecker=[function('NopChecker')]

            " key map
            let g:ZFVimIM_keymap = 0
            inoremap <expr><silent> <c-a> ZFVimIME_keymap_toggle_i()
            nnoremap <expr><silent> <c-a> ZFVimIME_keymap_toggle_n()

            " status
            let g:ZFVimIME_IMEStatus_tagL = '['
            let g:ZFVimIME_IMEStatus_tagR = ']'

call plug#end()
