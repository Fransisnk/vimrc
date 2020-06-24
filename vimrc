set nocompatible              " be iMproved, required

filetype off  " required

set splitbelow
set splitright

set guioptions=c

set rtp+=~/.vim/bundle/Vundle.vim
set laststatus=2
set updatetime=100 
set relativenumber
set cursorline
set t_ut=        " disable the Background Color Erase that messes with some color schemes

profile start gitgutter.log
profile! file */vim-gitgutter/*

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive' "Git tools
"Plugin 'itchyny/lightline.vim' "Linje på bunnen
Plugin 'preservim/nerdtree' "File-explorer
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim' "File search
Plugin 'mileszs/ack.vim' "Søk på fil som inneholder 
Plugin 'petobens/poet-v'
Plugin 'davidhalter/jedi-vim'
Plugin 'airblade/vim-gitgutter' "Merke linjer med git endringer
Plugin 'morhetz/gruvbox'
Plugin 'vim-python/python-syntax'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()            " required

map <F2> :NERDTreeToggle<CR>

nnoremap <C-f> :FZF<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

imap jj <Esc>
" jj exits insert

filetype plugin indent on    " required


autocmd vimenter * colorscheme gruvbox 

"let g:python3_host_prog = '~/.vim/nvim_interpreter/bin/python'

let mapleader =" "

set bg=dark
let g:gruvbox_number_column='bg2'

let g:python_highlight_all = 1

set noshowmode "Skru av gammel mode -- SETT INN --
let g:airline_theme='distinguished'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
  \ }

map <F12> <Esc>:tabedit ~/.vimrc<CR>

let g:poetv_auto_activate = 1

let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

imap <silent> <F5> <Esc> :call SaveAndExecutePython()<CR>
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)
    silent execute "resize 15"
    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction


imap <silent> <F5> <Esc> :call SaveAndExecutePythonTest()<CR>
nnoremap <silent> <F5> :call SaveAndExecutePythonTest()<CR>
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePythonTest()<CR>

function! SaveAndExecutePythonTest()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!pytest " . shellescape(s:current_buffer_file_path, 1)
    silent execute "resize 30"
    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction

py3 << EOF
import os.path
import sys
import vim
import jedi
if 'VIRTUAL_ENV' in os.environ:
	base = os.environ['VIRTUAL_ENV']
	site_packages = os.path.join(base, 'lib', 'python%s' %  sys.version[:3], 'site-packages')
	prev_sys_path = list(sys.path)
	import site
	site.addsitedir(site_packages)
	sys.real_prefix = sys.prefix
	sys.prefix = base
	# Move the added items to the front of the path:
	new_sys_path = []
	for item in list(sys.path):
		if item not in prev_sys_path:
			new_sys_path.append(item)
			sys.path.remove(item)
	sys.path[:0] = new_sys_path
EOF

set omnifunc=jedi#completions
let g:jedi#force_py_version = '3'
