" samy kamkar's vimrc

"mkdir -p ~/.vim/autoload ~/.vim/bundle
"git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

" <VUNDLE>
set nocompatible
filetype off
"set term=xterm
"let &t_AB="\e[48;5;%dm"
"let &t_AF="\e[38;5;%dm"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Plugin 'LucHermitte/lh-vim-lib'
"Plugin 'LucHermitte/VimFold4C'

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" Color / syntax highlighting
Plugin 'mtdl9/vim-log-highlighting'
Plugin 'jvirtanen/vim-octave'

" Utility
"Plugin 'scrooloose/nerdtree'
"Plugin 'majutsushi/tagbar'
""Plugin 'ervandew/supertab'
"Plugin 'BufOnly.vim'
"Plugin 'wesQ3/vim-windowswap'
"Plugin 'SirVer/ultisnips'
"Plugin 'junegunn/fzf.vim'
"Plugin 'junegunn/fzf'
"Plugin 'godlygeek/tabular'
"Plugin 'kien/ctrlp.vim'
"Plugin 'benmills/vimux'
"Plugin 'jeetsukumaran/vim-buffergator'
"Plugin 'gilsondev/searchtasks.vim'
"Plugin 'Shougo/neocomplete.vim'
"Plugin 'tpope/vim-dispatch'

" Generic Programming Support
" vim-polyglot supports many langs, replaces vim-javascript + vim-jsx-pretty
Plugin 'sheerun/vim-polyglot'
"Plugin 'pangloss/vim-javascript'
" vim-jsx-pretty replaces mxw/vim-jsx
"Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'isRuslan/vim-es6'
Plugin 'yuezk/vim-js'
" format js/css/html
Plugin 'maksimr/vim-jsbeautify'
" js parameter complete
Plugin 'othree/jspc.vim'
" javascript syntax
Plugin 'othree/yajs.vim'
" alt: https://github.com/jelera/vim-javascript-syntax
" Spin code syntax highlighting
"Plugin 'dimatura/spin.vim' (added manually to ~/.vim/syntax/)

" Code (github copilot)
Plugin 'github/copilot.vim'

" Code (linting)
"Plugin 'dense-analysis/ale'


""Plugin 'jakedouglas/exuberant-ctags'
"Plugin 'honza/vim-snippets'
"Plugin 'Townk/vim-autoclose'
"Plugin 'tomtom/tcomment_vim'
"Plugin 'tobyS/vmustache'
"Plugin 'janko-m/vim-test'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'neomake/neomake'

" Markdown / Writing
"Plugin 'lervag/vimtex'
"Plugin 'reedes/vim-pencil'
""Plugin 'tpope/vim-markdown' " causes ee/readme.samy to look weird
"Plugin 'jtratner/vim-flavored-markdown'
Plugin 'samyk/vim-markdown'
"""Plugin 'plasticboy/vim-markdown'
"Plugin 'LanguageTool'

" Theme / Interface
"Plugin 'AnsiEsc.vim'
"Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'sjl/badwolf'
"Plugin 'tomasr/molokai'
"Plugin 'morhetz/gruvbox'
"Plugin 'zenorocha/dracula-theme', {'rtp': 'vim/'}
"Plugin 'junegunn/limelight.vim'
"Plugin 'mkarmona/colorsbox'
"Plugin 'romainl/Apprentice'
"Plugin 'Lokaltog/vim-distinguished'
"Plugin 'chriskempson/base16-vim'
"Plugin 'w0ng/vim-hybrid'
"Plugin 'AlessandroYorba/Sierra'
"Plugin 'daylerees/colour-schemes'
"Plugin 'effkay/argonaut.vim'
"Plugin 'ajh17/Spacegray.vim'
"Plugin 'atelierbram/Base2Tone-vim'
"Plugin 'colepeters/spacemacs-theme.vim'

" Random Plugins
"Plugin 'vim-latex/vim-latex'
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'vim-scripts/ifdef-highlighting'
"Plugin 'trobrock/evernote.vim'
" PCRE perl regexpes
Plugin 'othree/eregex.vim'
"Plugin 'Shougo/denite.nvim'
"Plugin 'apechinsky/vim-platform-io'
"Plugin 'vhda/verilog_systemverilog.vim'
"Plugin 'justinmk/vim-syntax-extra'
"Plugin 'coddingtonbear/neomake-platformio'
"""Plugin 'godlygeek/tabular'
"""Plugin 'vim-airline/vim-airline'
"""Plugin 'vim-airline/vim-airline-themes'
"Plugin 'Valloric/YouCompleteMe'
"-Plugin 'tpope/vim-fugitive'
"-Plugin 'airblade/vim-gitgutter'
"""Plugin 'vim-syntastic/syntastic'
"Plugin 'aars/syntastic-platformio'
"Plugin 'sudar/vim-arduino-syntax'
"Plugin 'SirVer/ultisnips'
"Plugin 'sudar/vim-arduino-snippets'
"Plugin 'mileszs/ack.vim'
"""Plugin 'kien/ctrlp.vim'
"Plugin 'rking/ag.vim'
"Plugin 'othree/jspc.vim'
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'tomtom/tlib_vim'
"Plugin 'garbas/vim-snipmate'
"""Plugin 'honza/vim-snippets'
"Plugin 'Raimondi/delimitMate'

" themes
"""Plugin 'sjl/badwolf'
"Plugin 'jacoborus/tender'
"Plugin 'whatyouhide/vim-gotham'

"Plugin 'groenewege/vim-less'
"Plugin 'editorconfig-vim'
"Plugin 'scrooloose/NERDTree'
"Plugin 'scrooloose/NERDCommenter'
"Plugin 'leafgarland/typescript-vim'
"Plugin 'ternjs/tern_for_vim'

" Plugin 'nathanaelkane/vim-indent-guides' " not that useful?

" Automatically underline matching words (requires matchit)
Plugin 'vimtaku/hl_matchit.vim'

call vundle#end()            " required

" Enable matchit (use % to jump between matching keywords)
runtime macros/matchit.vim

" hide CRLFs
function! Fix_dos()
  " This would be the correct syntax, but no need for :normal:
  "execute "normal :e ++ff=dos\<cr>"
  " Also, no need for execute:
  "execute "e ++ff=dos"
  edit ++ff=dos
endfunction
"command! FixDos edit ++ff=dos


"e ++ff=dos %

" Verilog stuff
"set foldmethod=syntax
nnoremap <leader>u :VerilogGotoInstanceStart<CR>
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>

" enable filetype detection, run filetype specific plugins,
" load filetype specific indentation settings
filetype plugin indent on    " required

" </VUNDLE>

" ctrl-p plugin (Find files quickly)
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-pf>'
let g:ctrlp_cmd = 'CtrlPF'
let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_root_markers = ['']
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

"set tags=~/F/tags
syntax enable " on ?
filetype plugin on
let b:perl_synwrite_au = 0
filetype on

" airline controls statusline
"set statusline=[%l]\.%v/%L\ \ %p%%\ 0x\%02.2B\ a\%b\ %F%m%r%h%w
hi hdrinfo ctermfg=2
" XXX testing if this speeds things up by removing the MD header - doesn't
" seem to be related
let g:airline_section_gutter = '%= %#hdrinfo#%{exists(''*MarkdownGetHeader'')?MarkdownGetHeader()[0:20]:""}'

" treat .osa files as applescript
au BufNewFile,BufRead *.osa setf applescript

" go to beginning of line via ctrl+a
" nevermind, need this to increment/decrement
"nnoremap <C-a> ^

" use pcre (perl regexpes) by default for matching / an sub
nnoremap / :M/
"cnoremap %s/ %s/\v
cnoremap %s/ :S/
"cnoremap s/ :S/
" use magic mode?
"nnoremap / /\v

"nnoremap / /\v
"vnoremap / /\v
"cnoremap %s/ %smagic/
"cnoremap \>s/ \>smagic/
"nnoremap :g/ :g/\v
"nnoremap :g// :g//

" use pcre (perl regexpes) like so :%S// for replacements
nnoremap ,/ /

"nnoremap / /\v
"vnoremap / /\v

" turn off pcre by default (because normal match is live)
let g:eregex_default_enable = 0


" highlight current line (the screen line of the cursor)
set cursorline

" was here XXX

set smartcase
vmap <C-c> y<esc>i
vmap <C-x> d<esc>i
imap <C-v> <esc>pi
imap <C-y> <esc>ddi
"imap ii <esc>

nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

vnoremap  d "3d
vnoremap  D "3D
vnoremap  x "3x
vnoremap  X "3X
nnoremap  d "3d
nnoremap  D "3D
nnoremap  x "3x
nnoremap  X "3X

vnoremap  r "3p
vnoremap  R "3P
nnoremap  r "3p
nnoremap  R "3P

"let g:solarized_termcolors=16
"set background=dark
"colorscheme solarized
"set guifont       = "Menlo:12"
"let g:colors_name = "badwolf"
"set background    = "dark"


" Make vim more useful
set nocompatible

" Enhance command-line completion
set wildmenu
set wildmode=list:longest,full

" Allow cursor keys in insert mode
set esckeys

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Change mapleader
let mapleader=","

" Don’t add empty newlines at the end of files
set binary

set noeol

" Enable line numbers
"set number

" Enable syntax highlighting
syntax on


" Show "invisible" characters
set lcs=tab:\ \ ,trail:·,nbsp:_

set list

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=v

" Disable error bells
set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Show the cursor position
set ruler

" Don’t show the intro message when starting vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Use relative line numbers
"set relativenumber

"au BufReadPost * set relativenumber

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace ()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace ()<CR>

" set color to processing/arduino files (actually .pde should be java?)
autocmd! BufNewFile,BufRead *.pde setlocal ft=c
autocmd! BufRead,BufNewFile *.ino setlocal ft=c
autocmd! BufRead,BufNewFile *.ulp setlocal ft=c

" set .samy/.txt (eg README.samy) to markdown
au BufNewFile,BufRead *.samy set filetype=markdown

" set .bt (010 editor) as C
au BufNewFile,BufRead *.bt set filetype=C

let  g:C_UseTool_cmake    = 'yes'
let  g:C_UseTool_doxygen = 'yes'

" pathogen
execute pathogen#infect()
syntax on
filetype indent plugin on

" better indenting - should autoload from ~/.vim/indent already
"set g:js_indent = /Users/samy/.vim/indent/javascript.vim
let g:js_indent_log = 0 " don't log indent stuff

" more coffeescript stuff
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
autocmd BufNewFile,BufRead *.iced set filetype=coffee

" forces vim to source .vimrc file if it present in working directory, thus
" providing a place to store project-specific configuration.
set exrc
" restrict usage of some commands in non-default .vimrc files; commands that
" wrote to file or execute shell commands are not allowed and map commands are
" displayed
set secure

" Commenting blocks of code.
augroup project
	autocmd!
	autocmd BufRead,BufNewFile *.cpp,*.hpp,*.ino,*.h,*.c set filetype=c.doxygen
augroup END

"autocmd FileType c,cpp,java,scala   let b:comment_leader = '// '
"autocmd FileType pl,sh,ruby,python  let b:comment_leader = '# '
"autocmd FileType conf,fstab         let b:comment_leader = '# '
"autocmd FileType tex                let b:comment_leader = '% '
"autocmd FileType mail               let b:comment_leader = '> '
"autocmd FileType vim                let b:comment_leader = '" '
"noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
"noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" use macos clipboard (dd no longer yanks)
"set clipboard=unnamed


" don't auto-comment stuff (paste mode)
"set paste
set pastetoggle=<F3>
" actually paste auto-indents so turn off
set nopaste


" break bad habits of arrow key use
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" expand tabs, indenting, use 2 spaces
set expandtab
set autoindent
set smartindent  " does the right thing (mostly) in programs

" 80char columns
"highlight ColorColumn ctermbg=magenta
"call matchadd('ColorColumn', '\%80v', 100)



"=====[ Highlight matches when jumping to next ]=============

" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>


" EITHER blink the line containing the match...
function! HLNext0 (blinktime)
    set invcursorline
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    set invcursorline
    redraw
endfunction

" OR ELSE ring the match in red...
function! HLNext1 (blinktime)
    highlight RedOnRed ctermfg=red ctermbg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    echo matchlen
    let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
            \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
            \ . '\|'
            \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
            \ . '\|'
            \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
    let ring = matchadd('RedOnRed', ring_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" OR ELSE briefly hide everything except the match...
function! HLNext2 (blinktime)
    highlight BlackOnBlack ctermfg=black ctermbg=black
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let hide_pat = '\%<'.lnum.'l.'
            \ . '\|'
            \ . '\%'.lnum.'l\%<'.col.'v.'
            \ . '\|'
            \ . '\%'.lnum.'l\%>'.(col+matchlen-1).'v.'
            \ . '\|'
            \ . '\%>'.lnum.'l.'
    let ring = matchadd('BlackOnBlack', hide_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" OR ELSE just highlight the match in red...
highlight WhiteOnRed ctermbg=red ctermfg=white
function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 500) . 'm'
    call matchdelete(ring)
    redraw
endfunction


"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======

"exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
"exec "set listchars=trail:\uB7,nbsp:~"
"set list


"====[ Swap : and ; to make colon commands easier to type ]======

noremap ; :
"nnoremap ; :
"nnoremap : ;
"vnoremap ; :
"vnoremap : ;
"noremap ;; ;


"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======
" XXX
nnoremap v <C-V>
"nnoremap <C-V>     v
"    vnoremap    v   <C-V>
"    vnoremap <C-V>     v

"====[ Always turn on syntax highlighting for diffs ]=========================

" EITHER select by the file-suffix directly...
augroup PatchDiffHighlight
    autocmd!
    autocmd BufEnter  *.patch,*.rej,*.diff   syntax enable
augroup END

" OR ELSE use the filetype mechanism to select automatically...
filetype on
augroup PatchDiffHighlight
    autocmd!
    autocmd FileType  diff   syntax enable
augroup END


"====[ Open any file with a pre-existing swapfile in readonly mode "]=========

" augroup NoSimultaneousEdits
"     autocmd!
"     autocmd SwapExists * let v:swapchoice = 'o'
"     autocmd SwapExists * echomsg ErrorMsg
"     autocmd SwapExists * echo 'Duplicate edit session (readonly)'
"     autocmd SwapExists * echohl None
"     autocmd SwapExists * sleep 2
" augroup END

" Also consider the autoswap_mac.vim plugin (but beware its limitations)

"====[ Mappings to activate spell-checking alternatives ]================
set spelllang=en
"autocmd BufRead,BufNewFile *.md setlocal spell
nmap  \s     :set invspell spelllang=en<CR>
"nmap  \ss    :set    spell spelllang=en-basic<CR>

" To create the en-basic (or any other new) spelling list:
"
"     :mkspell  ~/.vim/spell/en-basic  basic_english_words.txt
"
" See :help mkspell


"====[ Make CTRL-K list diagraphs before each digraph entry ]===============
inoremap <expr> <C-K> ShowDigraphs()

function! ShowDigraphs ()
    digraphs
    call getchar()
    return "\<C-K>"
endfunction

" But also consider the hudigraphs.vim and betterdigraphs.vim plugins,
" which offer smarter and less intrusive alternatives

" Support JSX in .js files (not just .jsx)
let g:jsx_ext_required = 0

" Autocompletion in js (vim's default)
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

augroup filetype javascript syntax=javascript

" ycm python path
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'
"let g:ycm_path_to_python_interpreter = '/usr/bin/python'
"let g:ycm_path_to_python_interpreter = '/opt/local/bin/python'

" see https://github.com/Valloric/YouCompleteMe/issues/914
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" samy hex converter
let g:hexconv = 0
function! HexConv()
  let g:hexconv = !g:hexconv
  if g:hexconv == 1
    %!xxd
  else
    %!xxd -r
  endif
endfunction
nnoremap <C-h> :call HexConv()<CR>

" test
"function! SuperTab()
"  let l:part = strpart(getline('.'),col('.')-2,1)
"  if (l:part=~'^\W\?$')
"    return "\<Tab>"
"  else
"    return "\<C-n>"
"  endif
"endfunction

"imap <Tab> <C-R>=SuperTab()<CR>

" ycm (youcompleteme) extra conf for platformio
"let g:ycm_global_ycm_extra_conf = '/Users/samy/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" platformio/pio compile/upload/samybuild
"nnoremap <C-b> :make<CR>
nnoremap <C-k> :w \| !flash -c<CR>
nnoremap <C-l> :w \| !flash %:p<CR>
" git push
nnoremap <C-g> :w \| !gpush %<CR>
"nnoremap <C-k> :w \| !platformio run -v<CR>
"nnoremap <C-l> :w \| !platformio run -v --target upload<CR>

" navigate between split panes
nmap <silent> <C-j> :wincmd j<CR>

" ycm don't load local .ycm_extra_conf.py
let g:ycm_confirm_extra_conf = 0


" autoformat code via = using astyle
"set formatprg=astyle
autocmd BufNewFile,BufRead *.cpp,*.hpp,*.c,*.h,*.ino set formatprg=astyle

"--

"Toggle whitespace (vim-better-whitespace)
nmap <Leader>ts :ToggleWhitespace<CR>

"Strip whitespaces(vim-better-whitespace)
"nmap <Leader>ds :StripWhitespace<CR>

"strip all trailing whitespace everytime
"autocmd BufWritePre * StripWhitespace

set showcmd         " show (partial) command in status line
set autoread        " Reload files changed outside vim

" add color to .strace files
autocmd BufRead,BufNewFile *.strace set filetype=strace

" Fix OS X issue when editing crontab via `crontab -e`
au BufEnter /private/tmp/crontab.* setl backupcopy=yes

" allow for 256 colors (iTerm2)
set t_Co=256

" Make X an operator that removes text without placing text in the default register
"nmap XX "_dd
vmap X "_d
vmap x "_d
" have x (removes single character) not go into the default register
nnoremap x "_x

" prevent $a/^i from working, use A/I instead!
" XXX unfortunately it makes $ and ^ 'appear' slow...is there a way to fix this?
"map $a :echo "Slow! Use 'A'"<CR>
"map ^i :echo "Slow! Use 'I'"<CR>

" how long to wait before timing out for a multi-char mapping (eg $a)
set timeoutlen=300

" Press <space> after search (or search/replace) to prevent highlighting
noremap <silent> <Space> :silent noh<Bar>echo<CR>

" do i want this? copy the previous indentation on autoindenting
set copyindent
" do i want this? insert tabs on the start of a line according to shiftwidth not tabstop
set smarttab

" show matching parens
set showmatch

" Allow saving of files as sudo when I forgot to start vim using sudo.
" XXX doesn't work...what's up?
"cnoremap w!! w !sudo tee %
cmap w!! %!sudo tee > /dev/null %


" Syntastic plugin settings
" Toggle warnings
nmap Q :SyntasticToggleMode<CR>
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Don't use audible bell
"set visualbell

"Some tips from http://stevelosh.com/blog/2010/09/coming-home-to-vim/"
set hidden

" macOS backspace fix
set backspace=indent,eol,start

set laststatus=2

" https://github.com/AntJanus/my-dotfiles/blob/master/.vimrc
set modelines=0
" https://wiki.python.org/moin/Vim
"set modeline

" Command T settings
let g:CommandTInputDebounce = 200
let g:CommandTFileScanner = "watchman"
let g:CommandTWildIgnore = &wildignore . ",**/bower_components/*" . ",**/node_modules/*" . ",**/vendor/*"
let g:CommandTMaxHeight = 30
let g:CommandTMaxFiles = 500000

" show extra whitespace as red
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/

"n  Normal mode map. Defined using ':nmap' or ':nnoremap'.
"i  Insert mode map. Defined using ':imap' or ':inoremap'.
"v  Visual and select mode map. Defined using ':vmap' or ':vnoremap'.
"x  Visual mode map. Defined using ':xmap' or ':xnoremap'.
"s  Select mode map. Defined using ':smap' or ':snoremap'.
"c  Command-line mode map. Defined using ':cmap' or ':cnoremap'.
"o  Operator pending mode map. Defined using ':omap' or ':onoremap'.
"<Space>  Normal, Visual and operator pending mode map. Defined using ':map' or ':noremap'.
"!  Insert and command-line mode map. Defined using 'map!' or 'noremap!'.

" Ctrl+v splits window (there are multiple c-v's!)
nnoremap <C-v> :vsplit<CR>

" Ctrl+h hides split window (there are multiple c-h's!)
nnoremap <C-h> :hide<CR>

" Ctrl+w immediately goes to next window
"nnoremap <C-g> <C-w><C-w>

" Disable folding
let g:vimtex_fold_enabled=0
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
"let perl_fold=1

" I believe Foldexpr_markdown is slowing things down in big MD files
let g:vim_markdown_folding_disabled = 1


" Type 'f' to see function name (in C)
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map F :call ShowFuncName() <CR>

" no spell
set nospell

" evernote
"let g:evernote_vim_username = "your_evernote_username"
"let g:evernote_vim_password = "your_evernote_password"
"let g:evernote_vim_ruby_dir = "/Users/samy/.vim/bundle/evernote.vim/ruby"

" set Tab to next file, shift-tab to prev file
"nnoremap n :n<CR>
"nnoremap N :N<CR>
nnoremap <Tab>   :n<CR>
nnoremap <S-Tab> :N<CR>


" Linting / code fixing
" Fix files with prettier, and then ESLint
"let b:ale_fixers = ['prettier', 'eslint'] Equivalent to the above
"let b:ale_fixers = {'*': ['prettier', 'eslint']}

" format CSV/TSV/SSV to table
xnoremap <C-t> :%!column -ts $'\t'<CR>
xnoremap <C-c> :%!column -ts ','<CR>
xnoremap <C-s> :%!column -t<CR>

" copy into macos buffer via cmd+c
xnoremap <D-c> "+y
xnoremap <C-c> "+y

" don't show ^M (carriage return) in files
"set fileformat=unix,dos

" ctrl+m to convert selected area or line to evaluated math
vnoremap <C-m> s<C-r>=eval(@")<CR><Esc><Esc>
"nnoremap <C-m> ^vg_s<C-r>=eval(@")<CR><Esc>
"nnoremap <CR> j

" (normal) F to remove everything after one char after the cursor
nnoremap F lD

" remove search highlighting with escape
nnoremap <esc> :noh<return>

" spin syntax highlighting
au BufRead,BufNewFile *.spin set filetype=spin
au! Syntax spin source $HOME/.vim/syntax/spin.vim/spin.vim

" samy c/c++ ifdef folding
"source ~/Code/vim/samyfold.vim

" now here XXX
set bg=dark
set sw=2
set shiftwidth=2
set softtabstop=2
set noai
set nocompatible

" Make tabs as wide as two spaces
set tabstop=2

" don't let markdown override indent
let g:markdown_recommended_style=0

" Gitgutter (colors)
let g:gitgutter_override_sign_column_highlight = 0
"highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" perl?
augroup perl
    autocmd!
    " Add shiftwidth and/or softtabstop if you want to override those too.
    autocmd FileType python setlocal noexpandtab tabstop=2 sw=2 shiftwidth=2 softtabstop=2
augroup end

" Python
augroup python
    autocmd!
    " Add shiftwidth and/or softtabstop if you want to override those too.
    autocmd FileType python setlocal noexpandtab tabstop=2 sw=2 shiftwidth=2 softtabstop=2
augroup end


" qasm color coding https://github.com/gusaiani/vim-qasm
au BufRead,BufNewFile *.qasm set filetype=qasm

