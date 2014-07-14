" I often want to close a buffer without closing the window.  Using
" :BW also drops the associated metadata.
nnoremap <leader><leader>d :BW<CR>
nnoremap <leader><leader>D :BW!<CR>

" =============================================================
" Options
" =============================================================

" Turn on list, and setup the listchars.
set listchars=tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:·
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u254e,fold:\u00b7"
endif
set list

" I dislike wrapping being on by default.
set nowrap

" Ignore some Clojure/Java-related files.
set wildignore+=target/**,asset-cache

" I regularly create tmp folders that I don't want searched.
set wildignore+=tmp,.lein-*,*.egg-info,.*.swo

" Set colorcolumn, if available.
if exists('+colorcolumn')
    " This sets it to textwidth+1
    set colorcolumn=+1
endif

" Make splits appear on the right.
set splitright

" Adjust the scrolling.
set scrolloff=4
set sidescrolloff=5

" For some reason, gnome-terminal says xterm-color even though it supports
" xterm-256color.
if !has("gui_running") && $COLORTERM == "gnome-terminal" && &t_Co <= 16
    set t_Co=256
endif

" -------------------------------------------------------------
" GUI options
" -------------------------------------------------------------

" Turn off the scrollbars... I don't need them.
if has("gui_running")
    set guioptions-=R
    set guioptions-=r
    set guioptions-=L
    set guioptions-=l
endif

if has("gui_macvim")
    set macmeta
endif

" =============================================================
" Plugin settings
" =============================================================

" -------------------------------------------------------------
" Grep
" -------------------------------------------------------------

" Be compatible with both grep on Linux and Mac
let Grep_Xargs_Options = '-0'

" -------------------------------------------------------------
" Indengt Guides
" -------------------------------------------------------------

let g:IndentGuides = 1

" -------------------------------------------------------------
" localvimrc
" -------------------------------------------------------------

" let s:project_whitelist = [
"             \ 'jszakmeister',
"             \ 'intelesys',
"             \ 'git',
"             \ 'llvm',
"             \ ]
" let g:localvimrc_whitelist = resolve(expand('$HOME/projects/')) . '\(' .
"             \ join(s:project_whitelist, '\|') . '\)/.*'

" -------------------------------------------------------------
" Powerline
" -------------------------------------------------------------

if g:EnablePowerline
    " Add back in a few segments...
    call Pl#Theme#InsertSegment('mode_indicator', 'after', 'paste_indicator')
    call Pl#Theme#InsertSegment('filetype', 'before', 'scrollpercent')

    call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')

    if !has("gui_running")
        if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
            let g:Powerline_symbols_override = {
                \ 'BRANCH': [0x2442],
                \ }
        endif
    endif

    let g:Powerline_mode_n = 'N'
    let g:Powerline_mode_i = 'I'
    let g:Powerline_mode_R = 'R'
    let g:Powerline_mode_v = 'V'
    let g:Powerline_mode_V = 'V⋅LINE'
    let g:Powerline_mode_cv = 'V⋅BLOCK'
    let g:Powerline_mode_s = 'SELECT'
    let g:Powerline_mode_S = 'S⋅LINE'
    let g:Powerline_mode_cs = 'S⋅BLOCK'

    let g:Powerline_colorscheme = 'szakdark'
endif

" -------------------------------------------------------------
" Syntastic
" -------------------------------------------------------------

let g:syntastic_mode_map['active_filetypes'] =
            \ g:syntastic_mode_map['active_filetypes'] +
            \ ['html', 'less', 'sh', 'zsh']
let g:syntastic_python_checkers = ['python']

" =============================================================
" Autocommands
" =============================================================

function! ChangeRebaseAction(action)
    let ptn = '^\(pick\|reword\|edit\|squash\|fixup\|exec\|p\|r\|e\|s\|f\|x\)\s'
    let line = getline(".")
    let result = matchstr(line, ptn)
    if result != ""
        execute "normal! ^cw" . a:action
        execute "normal! ^"
    endif
endfunction

function! SetupRebaseMappings()
    nnoremap <buffer> <Leader><Leader>f :call ChangeRebaseAction('fixup')<CR>
    nnoremap <buffer> <Leader><Leader>p :call ChangeRebaseAction('pick')<CR>
    nnoremap <buffer> <Leader><Leader>r :call ChangeRebaseAction('reword')<CR>
    nnoremap <buffer> <Leader><Leader>s :call ChangeRebaseAction('squash')<CR>
endfunction

augroup dbernard_vimrc
    autocmd!

    " The toggle help feature seems to reset list.  I really want it off for
    " the help buffer though.
    autocmd BufEnter * if &bt == "help" | setlocal nolist | endif

    " Add my rebase mappings when doing a `git rebase`.
    autocmd FileType gitrebase call SetupRebaseMappings()
augroup END

