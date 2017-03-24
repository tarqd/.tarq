"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

 " initialize default settings
let s:settings = {}
let s:settings.default_indent = 2
let s:settings.max_column = 120
let s:settings.enable_cursorcolumn = 0
if has('gui_running')
  let s:settings.colorscheme = 'luna'
else 
  let s:settings.colorscheme = 'luna-term'
endif


" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
"}}}

source ~/.tarq/vim/mac.vim

" functions {{{
  function! Preserve(command) "{{{
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction "}}}
  function! StripTrailingWhitespace() "{{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}
  function! EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}
  function! CloseWindowOrKillBuffer() "{{{
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') == 'NERD'
      wincmd c
      return
    endif

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction "}}}
"}}}

" base configuration {{{
  set timeoutlen=300                                  "mapping timeout
  set ttimeoutlen=50                                  "keycode timeout

  set mouse=a                                         "enable mouse
  set mousehide                                       "hide when characters are typed
  set history=1000                                    "number of command lines to remember
  set ttyfast                                         "assume fast terminal connection
  set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
  set encoding=utf-8                                  "set encoding for text
  if exists('$TMUX')
    set ttymouse=xterm2                               " dragging support
    set clipboard=
  else
    "set clipboard=unnamed                             "sync with OS clipboard
  endif
  set hidden                                          "allow buffer switching without saving
  set autoread                                        "auto reload if file saved externally
  set fileformats+=mac                                "add mac to auto-detection of file format line endings
  set showcmd
  set tags=tags;/
  set showfulltag
  set modeline
  set modelines=5

 " whitespace
  set backspace=indent,eol,start                      "allow backspacing everything in insert mode
  set autoindent                                      "automatically indent to match adjacent lines
  set expandtab                                       "spaces instead of tabs
  set smarttab                                        "use shiftwidth to enter tabs
  let &tabstop=s:settings.default_indent              "number of spaces per tab for display
  let &softtabstop=s:settings.default_indent          "number of spaces per tab in insert mode
  let &shiftwidth=s:settings.default_indent           "number of spaces when indenting
  set list                                            "highlight whitespace
  set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
  set shiftround
  set linebreak
  let &showbreak='↪ '

  set scrolloff=1                                     "always show content after scroll
  set scrolljump=5                                    "minimum number of lines to scroll
  set display+=lastline
  set wildmenu                                        "show list for autocomplete
  set wildmode=list:full
  set wildignorecase
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

  set splitbelow
  set splitright
  " searching
  set hlsearch                                        "highlight searches
  set incsearch                                       "incremental searching
  set ignorecase                                      "ignore case for searching
  set smartcase                                       "do case-sensitive if there's a capital letter
  if executable('ack')
    set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
    set grepformat=%f:%l:%c:%m
  endif
  if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
  endif

  " vim file/folder management {{{
    " persistent undo
    if exists('+undofile')
      set undofile
      set undodir=~/.vim/.cache/undo
    endif

    " backups
    set backup
    set backupdir=~/.vim/.cache/backup

    " swap files
    set directory=~/.vim/.cache/swap
    set noswapfile

    call EnsureExists('~/.vim/.cache')
    call EnsureExists(&undodir)
    call EnsureExists(&backupdir)
    call EnsureExists(&directory)
    let mapleader = ","
    let g:mapleader = ","
" }}}
" ui configuration {{{
  set showmatch                                       "automatically highlight matching braces/brackets/etc.
  set matchtime=2                                     "tens of a second to show matching parentheses
  set number
  set lazyredraw
  set laststatus=2
  set noshowmode
  set foldenable                                      "enable folds by default
  set foldmethod=syntax                               "fold via syntax of files
  set foldlevelstart=99                               "open all folds by default
  let g:xml_syntax_folding=1                          "enable xml folding

  set cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
  if has('conceal')
    set conceallevel=1
    set listchars+=conceal:Δ
  endif

  if has('gui_running')
    " open maximized
    "set lines=999 columns=9999
    if s:is_windows
      autocmd GUIEnter * simalt ~x
    endif

    set guioptions+=t                                 "tear off menu items
    set guioptions-=T                                 "toolbar icons

    if s:is_macvim
      set gfn=monoOne:h12
      set transparency=2
    endif

    if s:is_windows
      set gfn=Ubuntu_Mono:h10
    endif

    if has('gui_gtk')
      set gfn=Ubuntu\ Mono\ 11
    endif
  else
    if $COLORTERM == 'gnome-terminal'
      set t_Co=256 "why you no tell me correct colors?!?!
    endif
    if $TERM_PROGRAM == 'iTerm.app'
      " different cursors for insert vs normal mode
      if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      endif
    endif
  endif
" }}}
" window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe 'normal! g`"zvzz' |
  \ endif
autocmd FileType vim setlocal fdm=indent keywordprg=:help
autocmd FileType python setlocal foldmethod=indent
autocmd FileType markdown setlocal nolist
autocmd BufRead,BufNewFile *.md set filetype=markdown

" screen line scroll
nnoremap <silent> j gj
nnoremap <silent> k gk

" auto center {{{
  nnoremap <silent> n nzz
  nnoremap <silent> N Nzz
  nnoremap <silent> * *zz
  nnoremap <silent> # #zz
  nnoremap <silent> g* g*zz
  nnoremap <silent> g# g#zz
  nnoremap <silent> <C-o> <C-o>zz
  nnoremap <silent> <C-i> <C-i>zz
"}}}

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Required:
set runtimepath+=~/.tarq/vim/dein.vim/bin/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.tarq/vim/dein.vim/bin')
  call dein#begin('~/.tarq/vim/dein.vim/bin')

  " Let dein manage dein
  " Required:
  call dein#add('~/.tarq/vim/dein.vim/bin/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
  " call dein#add('Shougo/vimshell')

  " unity is dead, long live denite
  call dein#add('Shougo/denite.nvim')

  " autocompletion
  call dein#add('Shougo/deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#omni#functions = {}
  let g:deoplete#omni#functions.php = [ 'phpcomplete#CompletePHP' ]
  let g:deoplete#omni#functions.javascript = [
    \ 'tern#Complete',
    \ 'jspc#omni'
    \] 


  " javascript
  " call dein#add('ternjs/tern_for_vim')
  call dein#add('carlitux/deoplete-ternjs')
  " Use deoplete.
  let g:tern_request_timeout = 1
  let g:tern_show_signature_in_pum = '0'  " This do disable full signature type on autocomplete
  
  "Add extra filetypes
  let g:tern#filetypes = [
                  \ 'jsx',
                  \ 'javascript.jsx',
                  \ 'vue',
                  \ ]
  call dein#add('othree/jspc.vim')


  " rust
  call dein#add('racer-rust/vim-racer')
  let g:racer_cmd = "~/.cargo/bin/racer"
  set hidden
  au FileType rust nmap gd <Plug>(rust-def)
  au FileType rust nmap gs <Plug>(rust-def-split)
  au FileType rust nmap gx <Plug>(rust-def-vertical)
  au FileType rust nmap <leader>gd <Plug>(rust-doc)


  " go
  call dein#add('zchee/deoplete-go')
  " python
  call dein#add('zchee/deoplete-jedi')

  " coldufsion
  call dein#add('ernstvanderlinden/vim-coldfusion')
  let g:sql_type_default = 'mysql'
  autocmd FileType eoz
    \ setlocal
      \ expandtab
      \ foldmethod=syntax
      \ shiftwidth=4
      \ smarttab
      \ softtabstop=0
      \ tabstop=4

   autocmd Bufread,BufNewFile *.cfm,*.cfc set filetype=eoz noexpandtab

  " other syntaxes
  call dein#add('Shougo/neco-vim')
  call dein#add('Shougo/neco-syntax')
  call dein#add('zchee/deoplete-zsh')
  call dein#add('ponko2/deoplete-fish')
  call dein#add('shawncplus/phpcomplete.vim.git')

  " helpful autocomplete plugins')
  call dein#add('Shougo/context_filetype.vim')
  call dein#add('Shougo/neopairs.vim')
  call dein#add('Shougo/neoinclude.vim')
  call dein#add('Konfekt/FastFold')

  " autocomplete from open tmux panes (dope)
  call dein#add('wellle/tmux-complete.vim')
  let g:tmuxcomplete#trigger = ''


  " denite
  call denite#custom#var('file_rec', 'command',
  \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  nmap <space> [denite]
  nnoremap [denite] <nop>

  " search files and buffers
  nnoremap <silent> [denite]<space> :<C-u>Denite -toggle -auto-resize -buffer-name=mixed file_rec buffer <cr><c-u>
  nnoremap <silent> [denite]p<space> :<C-u>DeniteProjectDir -toggle -auto-resize -buffer-name=project file_rec <cr><c-u>

  " grep
  nnoremap <silent> [denite]g :<C-u>Denite -auto-resize -buffer-name=grep grep:.:! <cr><c-u>
  nnoremap <silent> [denite]pg :<C-u>DeniteProjectDir -auto-resize -buffer-name=grep grep:.:! <cr><c-u>
  nnoremap <silent> [denite]bg :<C-u>DeniteBufferDir -auto-resize -buffer-name=grep grep:.:! <cr><c-u>

  " search directories
  nnoremap <silent> [denite]d :<C-u>Denite -toggle -auto-resize -buffer-name=directories directory_rec <cr><c-u>
  nnoremap <silent> [denite]pd :<C-u>DeniteProjectDir -toggle -auto-resize -buffer-name=project directory_rec <cr><c-u>

  " change colorscheme 
  nnoremap <silent> [denite]c :<C-u>Denite -toggle -auto-resize -buffer-name=colorscheme colorscheme <cr><c-u>
  " find in file
  nnoremap <silent> [denite]f :<C-u>Denite -toggle -auto-resize -buffer-name=lines line <cr><c-u>
  nnoremap <silent> [denite]wf :<C-u>DeniteCursorWord -toggle -auto-resize -buffer-name=lines line <cr><c-u>
  nnoremap <silent> [denite]o :<C-u>Denite -toggle -auto-resize -buffer-name=outline outline <cr><c-u>

  " help
  nnoremap <silent> [denite]h :<C-u>Denite -toggle -auto-resize -buffer-name=help help <cr><c-u>

  " denite key bindings
  call denite#custom#map(
        \ 'insert',
        \ '<UP>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<DOWN>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)

  "color 
  call dein#add("nanotech/jellybeans.vim")
  call dein#add("flazz/vim-colorschemes")
  exec 'colorscheme '.s:settings.colorscheme
  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
