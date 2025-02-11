" Author: NCSantos
"
" Credit: Matthew Wozniski (mjw@drexel.edu)
"
" Feel free to do whatever you would like with this file as long as you give
" credit where credit is due.
"
" NOTE:
" If you're editing this in Vim and don't know how folding works, type zR to
" unfold everything. And then read ":help folding".

" Stop behaving like vi; vim's enhancements are better.
set nocompatible

" Skip the rest of this file unless we have +eval and Vim 7.0 or greater.
" With an older Vim, I'd rather just plain ol' vi-like features reminding me
" to upgrade.
if version >= 700
""" Settings
"""" Mouse, Keyboard, Terminal
set mouse=nv " Allow mouse use in normal and visual mode.
set ttymouse=xterm2 " Most terminals send modern xterm mouse reporting
" but this isn't always detected in GNU Screen.
set timeoutlen=2000 " Wait 2 seconds before timing out a mapping
set ttimeoutlen=100 " and only 100 ms before timing out on a keypress.
set lazyredraw " Avoid redrawing the screen mid-command.
set ttyscroll=3 " Prefer redraw to scrolling for more than 3 lines

" XXX Fix a vim bug: Only t_te, not t_op, gets sent when leaving an alt screen
exe "set t_te=" . &t_te . &t_op

""""" Titlebar
set title " Turn on titlebar support

" Set the to- and from-status-line sequences to match the xterm titlebar
" manipulation begin/end sequences for any terminal where
" a) We don't know for a fact that these sequences would be wrong, and
" b) the sequences were not already set in terminfo.
" NOTE: This would be nice to fix in terminfo, instead...
if &term !~? '^\v(linux|cons|vt)' && empty(&t_ts) && empty(&t_fs)
  exe "set t_ts=\<ESC>]2;"
  exe "set t_fs=\<C-G>"
endif

" Titlebar string: hostname> ${PWD:s/^$HOME/~} || (view|vim) filename ([+]|)
let &titlestring = hostname() . '> ' . '%{expand("%:p:~:h")}'
                \ . ' || %{&ft=~"^man"?"man":&ro?"view":"vim"} %f %m'

" When vim exits and the original title can't be restored, use this string:
if !empty($TITLE)
" We know the last title set by the shell. (My zsh config exports this.)
  let &titleold = $TITLE
else
" Old title was probably something like: hostname> ${PWD:s/^$HOME/~}
  let &titleold = hostname() . '> ' . fnamemodify($PWD,':p:~:s?/$??')
endif

""""" Encoding/Multibyte
if has('multi_byte') " If multibyte support is available and
  if &enc !~? 'utf-\=8' " the current encoding is not Unicode,
    if empty(&tenc) " default to
      let &tenc = &enc " using the current encoding for terminal output
    endif " unless another terminal encoding was already set
    set enc=utf-8 " but use utf-8 for all data internally
  endif
endif

"""" Moving Around/Editing
set nostartofline " Avoid moving cursor to BOL when jumping around
set whichwrap=b,s,h,l,<,> " <BS> <Space> h l <Left> <Right> can change lines
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3 " Keep 3 context lines above and below the cursor
set backspace=2 " Allow backspacing over autoindent, EOL, and BOL
set showmatch " Briefly jump to a paren once it's balanced
set matchtime=2 " (for only .2 seconds).

"""" Searching and Patterns
set ignorecase " Default to using case insensitive searches,
set smartcase " unless uppercase letters are used in the regex.
set hlsearch " Highlight searches by default.
set incsearch " Incrementally search while typing a /regex

"""" Windows, Buffers
set noequalalways " Don't keep resizing all windows to the same size
set hidden " Hide modified buffers when they are abandoned
set swb=useopen,usetab " Allow changing tabs/windows for quickfix/:sb/etc
set splitright " New windows open to the right of the current one

"""" Insert completion
set completeopt-=preview " Don't show preview menu for tags.
set infercase " Try to adjust insert completions for case.

"""" Folding
set foldmethod=syntax " By default, use syntax to determine folds
set foldlevelstart=99 " All folds open by default

"""" Text Formatting
set formatoptions=q " Format text with gq, but don't format as I type.
set formatoptions+=n " gq recognizes numbered lists, and will try to
set formatoptions+=1 " break before, not after, a 1 letter word

"""" Display
set number " Display line numbers
set relativenumber
set numberwidth=1 " using only 1 column (and 1 space) while possible
set cursorline

if &enc =~ '^u\(tf\|cs\)' " When running in a Unicode environment,
  set list " visually represent certain invisible characters:
  let s:arr = nr2char(9655) " using U+25B7 (▷) for an arrow, and
  let s:dot = nr2char(8901) " using U+22C5 (⋅) for a very light dot,
" display tabs as an arrow followed by some dots (▷⋅⋅⋅⋅⋅⋅⋅),
  exe "set listchars=tab:" . s:arr . s:dot
" and display trailing and non-breaking spaces as U+22C5 (⋅).
  exe "set listchars+=trail:" . s:dot
  exe "set listchars+=nbsp:" . s:dot
" Also show an arrow+space (↪ ) at the beginning of any wrapped long lines?
" I don't like this, but I probably would if I didn't use line numbers.
" let &sbr=nr2char(8618).' '
endif

"""" Messages, Info, Status
set vb t_vb= " Disable all bells. I hate ringing/flashing.
set confirm " Y-N-C prompt if closing with unsaved changes.
set showcmd " Show incomplete normal mode commands as I type.
set report=0 " : commands always print changed line count.
set shortmess+=a " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler " Show some info, even without statuslines.
set laststatus=2 " Always show statusline, even if only 1 window.

" set statusline=%<%F%h%m%r%h%w\ %y\ [BUF=%n]\ %{&ff}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\%#warningmsg#%{go#statusline#Show()}%*\ %P
set statusline=%<%F%h%m%r%h%w\ %y\ [BUF=%n]\ %{&ff}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\%#warningmsg#%*\ %P

"""" Tabs/Indent Levels
set autoindent " Do dumb autoindentation when no filetype is set
set tabstop=8 " Real tab characters are 8 spaces wide,
set shiftwidth=4 " but an indent level is 2 spaces wide.
set softtabstop=4 " <BS> over an autoindent deletes both spaces.
set expandtab " Use spaces, not tabs, for autoindent/tab key.

"""" Tags
" set tags=./tags;/home " Tags can be in ./tags, ../tags, ..., /home/tags.
set tags=./tags;~/.vim/tags/filename
set showfulltag " Show more information while completing tags.
set cscopetag " When using :tag, <C-]>, or "vim -t", try cscope:
set cscopetagorder=0 " try ":cscope find g foo" and then ":tselect foo"

"""" Reading/Writing
set noautowrite " Never write a file unless I request it.
set noautowriteall " NEVER.
set noautoread " Don't automatically re-read changed files.
set modeline " Allow vim options to be embedded in files;
set modelines=5 " they must be within the first or last 5 lines.
set ffs=unix,dos,mac " Try recognizing dos, unix, and mac line endings.
set path+=**

"""" Backups/Swap Files
" Make sure that the directory where we want to put swap/backup files exists.
if ! len(glob("~/.backup/"))
  echomsg "Backup directory ~/.backup doesn't exist!"
endif

set writebackup " Make a backup of the original file when writing
set backup " and don't delete it after a succesful write.
set backupskip= " There are no files that shouldn't be backed up.
set updatetime=2000 " Write swap files after 2 seconds of inactivity.
set backupext=~ " Backup for "file" is "file~"
set backupdir^=~/.backup " Backups are written to ~/.backup/ if possible.
set directory^=~/.backup// " Swap files are also written to ~/.backup, too.
" ^ Here be magic! Quoth the help:
" For Unix and Win32, if a directory ends in two path separators "//" or "\\",
" the swap file name will be built from the complete path to the file with all
" path separators substituted to percent '%' signs. This will ensure file
" name uniqueness in the preserve directory.

"""" Command Line
set history=1000 " Keep a very long command-line history.
set wildmenu " Menu completion in command mode on <Tab>
set wildmode=full " <Tab> cycles between all matching choices.
set wcm=<C-Z> " Ctrl-Z in a mapping acts like <Tab> on cmdline
source $VIMRUNTIME/menu.vim " Load menus (this would be done anyway in gvim)
" <F4> triggers the menus, even in terminal vim.
map <F4> :emenu <C-Z>

"""" Per-Filetype Scripts
" NOTE: These define autocmds, so they should come before any other autocmds.
" That way, a later autocmd can override the result of one defined here.
filetype on " Enable filetype detection,
filetype indent on " use filetype-specific indenting where available,
filetype plugin on " also allow for filetype-specific plugins,
syntax on " and turn on per-filetype syntax highlighting.

""" Plugin Settings
let lisp_rainbow=1 " Color parentheses by depth in LISP files.
let is_posix=1 " I don't use systems where /bin/sh isn't POSIX.
let vim_indent_cont=4 " Spaces to add for vimscript continuation lines
let no_buffers_menu=1 " Disable gvim 'Buffers' menu
let surround_indent=1 " Automatically reindent text surround.vim actions

set runtimepath+=~/.vim/snippets/xptemplate
let g:xptemplate_key = '<leader>s'
" let g:xptemplate_brace_complete = '{(['

""" Autocommands
if has("autocmd")
  augroup vimrcEx
    au!
  " In plain-text files and svn commit buffers, wrap automatically at 78 chars
    au FileType text,svn setlocal tw=78 fo+=t

  " Try to jump to the last spot the cursor was at in a file when reading it.
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" |
        \ endif

  " Insert Vim-version as X-Editor in mail headers
    au FileType mail sil 1 | call search("^$")
                 \ | sil put! ='X-Editor: Vim-' . Version()

    au Filetype * let &l:ofu = (len(&ofu) ? &ofu : 'syntaxcomplete#Complete')

    au BufWritePost ~/.Xdefaults redraw|echo system('xrdb '.expand('<amatch>'))

    au BufRead,BufNewFile * nested if &l:filetype =~# '^\(c\|cpp\)$'
                 \ | let &l:ft .= ".doxygen.glib.gobject.gdk.gdkpixbuf.gtk.gimp"
                 \ | endif

    au CmdwinEnter * nnoremap <buffer> <CR> <CR>
  augroup END

  augroup go
    " au BufWritePost *.go :silent GoBuild

    au Filetype go set sw=4
    au Filetype go set ts=4
    au Filetype go set sts=4

    au Filetype go set listchars=tab:\ \ 
    au Filetype go exec "set listchars+=trail:" . nr2char(8901)
    au Filetype go exec "set listchars+=nbsp:" . nr2char(8901)

    " au Filetype go nmap <silent> <leader>gi <Plug>(go-imports)
    " au Filetype go nmap <silent> <leader>gb :wa<CR><bar><Plug>(go-build)
    " au Filetype go nmap <silent> <leader>gd :GoDecls<CR>
    " au Filetype go nmap <silent> <leader>gf <Plug>(go-def-vertical)
    " au Filetype go nmap <silent> <leader>gtf <Plug>(go-test-func)

    au Filetype go nmap <silent> <Leader>h : <C-u>call GOVIMHover()<CR>

  augroup END

  augroup php
    au Filetype twig set ft=html
    au Filetype php nmap <silent> <leader>lf :g/function .*(<CR>
  augroup END
endif

""" Colorscheme
let g:inkpot_black_background=1
colorscheme apprentice

""" Key Mappings

let mapleader = ","

" Completition
inoremap <leader><leader> <C-X><C-O>

" Make [[ and ]] work even if the { is not in the first column
nnoremap <silent> [[ :call search('^\S\@=.*{$', 'besW')<CR>
nnoremap <silent> ]] :call search('^\S\@=.*{$', 'esW')<CR>
onoremap <expr> [[ (search('^\S\@=.*{$', 'ebsW') && (setpos("''", getpos('.'))
                  \ <bar><bar> 1) ? "''" : "\<ESC>")
onoremap <expr> ]] (search('^\S\@=.*{$', 'esW') && (setpos("''", getpos('.'))
                  \ <bar><bar> 1) ? "''" : "\<ESC>")

" Use \sq to squeeze blank lines with :Squeeze, defined below
"nnoremap <leader>sq :Squeeze<CR>

" In visual mode, \box draws a box around the highlighted text.
" vnoremap <leader>box <ESC>:call <SID>BoxIn()<CR>gvlolo

" Extra functionality for some existing commands:
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" In normal/insert mode, ar inserts spaces to right align to &tw or 80 chars
nnoremap <leader>ar :AlignRight<CR>

" In normal/insert mode, ac center aligns the text after it to &tw or 80 chars
nnoremap <leader>ac :center<CR>

" Zoom in on the current window with <leader>z
nmap <leader>z <Plug>ZoomWin

" F10 toggles highlighting lines that are too long
nnoremap <F10> :call <SID>ToggleTooLongHL()<CR>

" F11 toggles line numbering
nnoremap <silent> <F11> :set number! <bar> set number?<CR>

" F12 toggles search term highlighting
nnoremap <silent> <F12> :set hlsearch! <bar> set hlsearch?<CR>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

nnoremap <silent> gqJ :call Exe#ExeWithOpts('norm! gqj', { 'tw' : 2147483647 })<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" Pressing an 'enter visual mode' key while in visual mode changes mode.
vmap <C-V> <ESC>`<<C-v>`>
vmap V <ESC>`<V`>
vmap v <ESC>`<v`>

" Make { and } in visual mode stay in the current column unless 'sol' is set.
vnoremap <expr> { line("'{") . 'G'
vnoremap <expr> } line("'}") . 'G'

" Tapping C-W twice brings me to previous window, not next.
nnoremap <C-w><C-w> :winc p<CR>

" Get old behavior with <C-w><C-e>
nnoremap <C-w><C-e> :winc w<CR>

" Y behaves like D rather than like dd
nnoremap Y y$

nnoremap <leader>t :NERDTree<CR>

imap jj <ESC>

" nnoremap <leader><leader> q:

inoremap <C-b> <C-x><C-l>

nnoremap <CR> o<ESC>

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>

" Search files
nnoremap <leader>f :find<space>
nnoremap <leader>F :sfind<space>
nnoremap <leader>vf :vert sfind<space>
" Search buffers
nnoremap <leader>b :ls<CR>:b<space><C-z><S-Tab>
nnoremap <leader>B :ls<CR>:sb<space><C-z><S-Tab>
nnoremap <leader>vb :ls<CR>:vert sb<space><C-z><S-Tab>

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Display next/prev error
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>cc :cc<CR>

""" Abbreviations
function! EatChar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

iabbr _me Nelson Correia Santos<C-R>=EatChar('\s')<CR>
iabbr _t <C-R>=strftime("%H:%M:%S")<CR><C-R>=EatChar('\s')<CR>
iabbr _d <C-R>=strftime("%a, %d %b %Y")<CR><C-R>=EatChar('\s')<CR>
iabbr _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR><C-R>=EatChar('\s')<CR>

""" Cute functions
" Squeeze blank lines with :Squeeze
command! -nargs=0 Squeeze g/^\s*$/,/\S/-j

function! s:ToggleTooLongHL()
  if exists('*matchadd')
    if ! exists("w:TooLongMatchNr")
      let last = (&tw <= 0 ? 80 : &tw)
      let w:TooLongMatchNr = matchadd('ErrorMsg', '.\%>' . (last+1) . 'v', 0)
      echo " Long Line Highlight"
    else
      call matchdelete(w:TooLongMatchNr)
      unlet w:TooLongMatchNr
      echo "No Long Line Highlight"
    endif
  endif
endfunction

function! s:BoxIn()
  let mode = visualmode()
  if mode == ""
    return
  endif
  let vesave = &ve
  let &ve = "all"
  exe "norm! ix\<BS>\<ESC>"
  if line("'<") > line("'>")
    undoj | exe "norm! gvo\<ESC>"
  endif
  if mode != "\<C-v>"
    let len = max(map(range(line("'<"), line("'>")), "virtcol([v:val, '$'])"))
    undoj | exe "norm! gv\<C-v>o0o0" . (len-2?string(len-2):'') . "l\<esc>"
  endif
  let diff = virtcol("'>") - virtcol("'<")
  if diff < 0
    let diff = -diff
  endif
  let horizm = "+" . repeat('-', diff+1) . "+"
  if mode == "\<C-v>"
    undoj | exe "norm! `<O".horizm."\<ESC>"
  else
    undoj | exe line("'<")."put! ='".horizm."'" | norm! `<k
  endif
  undoj | exe "norm! yygvA|\<ESC>gvI|\<ESC>`>p"
  let &ve = vesave
endfunction

" Replace tabs with spaces in a string, preserving alignment.
function! Retab(string)
  let rv = ''
  let i = 0

  for char in split(a:string, '\zs')
    if char == "\t"
      let rv .= repeat(' ', &ts - i)
      let i = 0
    else
      let rv .= char
      let i = (i + 1) % &ts
    endif
  endfor

  return rv
endfunction

" Right align the portion of the current line to the right of the cursor.
" If an optional argument is given, it is used as the width to align to,
" otherwise textwidth is used if set, otherwise 80 is used.
function! AlignRight(...)
  if getline('.') =~ '^\s*$'
    call setline('.', '')
  else
    let line = Retab(getline('.'))

    let prefix = matchstr(line, '.*\%' . virtcol('.') . 'v')
    let suffix = matchstr(line, '\%' . virtcol('.') . 'v.*')

    let prefix = substitute(prefix, '\s*$', '', '')
    let suffix = substitute(suffix, '^\s*', '', '')

    let len = len(substitute(prefix, '.', 'x', 'g'))
    let len += len(substitute(suffix, '.', 'x', 'g'))

    let width = (a:0 == 1 ? a:1 : (&tw <= 0 ? 80 : &tw))

    let spaces = width - len

    call setline('.', prefix . repeat(' ', spaces) . suffix)
  endif
endfunction
com! -nargs=? AlignRight :call AlignRight(<f-args>)

function! Version()
  let i=1
  while has("patch" . i)
    let i+=1
  endwhile
  return v:version / 100 . "." . v:version % 100 . "." . (i-1)
endfunction
command! Version :echo Version()

command! -nargs=1 -complete=dir Rename saveas <args> | call delete(expand("#"))

""" Source files

"" Stop skipping here
endif

"" vim:fdm=expr:fdl=0
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='

