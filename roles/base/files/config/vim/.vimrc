syntax on
set noerrorbells
set nu 
set nocompatible
filetype plugin on 
"set tabstop=4 softtabstop=4
"set shiftwidth=4 
"set expandtab
set incsearch
set noswapfile 
set nobackup 
set undodir=~/.vim/undodir
set undofile
"set statusline=...%{battery#component()}...
set noshowmode
set laststatus=2
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"
set encoding=UTF-8
set guifont=JetBrainsMono\ Nerd\ Font\10

call plug#begin('~/.vim/plugged')
"Plug 'ghifarit53/tokyonight-vim'
Plug 'mbbill/undotree'
Plug 'itchyny/lightline.vim'
Plug 'dracula/vim', {'as': 'dracula'} 
"Plug 'joshdick/onedark.vim'
"Plug 'myusuf3/numbers.vim'
Plug 'ap/vim-css-color'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'arcticicestudio/nord-vim'
Plug 'vimwiki/vimwiki'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'jiangmiao/auto-pairs'
Plug 'JamshedVesuna/vim-markdown-preview'





call plug#end()
" Plug
" a 
" set background=dark
colorscheme nord
"set termguicolors



"let g:tokyonight_style = 'night' " available: night, storm
"let g:tokyonight_enable_italic = 0
let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:lightline = {'colorscheme': 'nord'}
"NERDTree
map <leader>n :NERDTreeToggle<CR>
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"Split Nav
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"NERDTree syntax highlighting 
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

"vimwiki configs 

let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" vim preview
let vim_markdown_preview_hotkey='<leader>m'
let vim_markdown_preview_browser='firefox'
let vim_markdown_preview_use_xdg_open=1
" this is a test 
