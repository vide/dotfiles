" Colors {{{
let mapleader = "\ñ"
nnoremap <Leader>p "+p<CR>
syntax enable           " enable syntax processing
colorscheme badwolf " dark
" colorscheme pyte
set term=screen-256color
set ttyfast
" }}}
set tabstop=4           " 4 space tab
set expandtab           " use spaces for tabs
set softtabstop=4       " 4 space tab
set shiftwidth=4
set modelines=1
execute pathogen#infect()
set runtimepath^=~/.vim/bundle/ctrlp.vim
filetype indent on
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set autoindent
set number              " show line numbers
"set relativenumber
set showcmd             " show command in bottom bar
set nocursorline        " highlight current line
set wildmenu
set lazyredraw
set showmatch           " higlight matching parenthesis
set fillchars+=vert:┃
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set hlsearch            " highlight all matches
set swapfile
set dir=~/tmp
" sytastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']
" end syntastic

" keys remap
" windows movement
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-n> :tabnext<CR>
map <C-m> :tabnew<CR>
map <C-b> :tabedit<SPACE>
map <C-d> :tabclose<CR>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind F to grep word under cursor
nnoremap F :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind - (dash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap - :Ag<SPACE>
nnoremap <leader>d dd
" autocmd vimenter * NERDTree
"
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
set laststatus=2
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"

" find & replace under cursor with ctrl+f
" nnoremap <C-f> %s/<C-R><C-W>//gc<left><left><left>

" terraform related settings
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save=1
autocmd FileType terraform setlocal commentstring=#%s
