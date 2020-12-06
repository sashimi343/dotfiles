" General settings
set number
set title
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set ignorecase
set smartcase
set wrapscan
set nocompatible
set cursorline
set incsearch
set lazyredraw
set magic
set backspace=indent,eol,start
set foldmethod=marker
colorscheme elflord
hi CursorLine ctermfg=NONE ctermbg=NONE cterm=underline
hi CursorLineNr term=bold ctermfg=8 cterm=NONE
hi Comment ctermfg=2
filetype plugin on

" Move cursor by display line
nnoremap j gj
nnoremap k gk
nnoremap <DOWN> gj
nnoremap <UP> gk
inoremap <C-DOWN> <C-o>gj
inoremap <C-UP> <C-o>gk

" Move cursor in insert mode
inoremap <C-h> <LEFT>
inoremap <C-j> <C-o>gj
inoremap <C-k> <C-o>gk
inoremap <C-l> <RIGHT>

" Multi-window
nnoremap ss :split 
nnoremap sv :vsplit 
nnoremap se :edit
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap s= <C-w>=
nnoremap s; <C-w>+
nnoremap s- <C-w>-
nnoremap s. <C-w>>
nnoremap s, <C-w><

" jj, kk -> Esc (misoperation prevention)
inoremap <silent> jj <ESC>
inoremap <silent> kk <ESC>

" yanktmp.vim
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>

" Bracket completion
"inoremap {} {}
"inoremap [] []
"inoremap () ()
"inoremap "" ""
"inoremap '' ''
"inoremap {<CR> {<CR>}<ESC>O
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

" Keyword completion
"set completeopt=menuone
"for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
"    exec "imap <expr> " . k . " pumvisible() ? '" . k . "' : '" . k . "\<C-x>\<C-p>\<C-n>'"
"endfor

" Settings for editing binary file
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin | *.hex let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

" Clipboard 
nnoremap cp "+p

" Encoding recognition
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif

if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'

    " Check whether iconv supports eucJP-ms
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'

        " Check whether iconv supports JISX0213
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif

    " Set fileencoding
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif

    " Dispose unnecessary variables
    unlet s:enc_euc
    unlet s:enc_jis
endif

" Use &encoding when the file does not contain multibyte chars
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" Recognize linefeed code
set fileformats=unix,dos,mac

" ambiwidth
if exists('&ambiwidth')
  set ambiwidth=double
endif

" Spelling check
"fun! s:SpellConf()
"  redir! => syntax
"  silent syntax
"  redir END
"
"  set spell
"  set spelllang=en,cjk
"  hi clear SpellBad
"  hi SpellBad cterm=underline
"
"
"  if syntax =~? '/<comment\>'
"    syntax spell default
"    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
"  else
"    syntax spell toplevel
"    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
"  endif
"
"  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
"endfunc
"
"augroup spell_check
"  autocmd!
"  autocmd BufReadPost,BufNewFile,Syntax * call s:SpellConf()
"augroup END

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif

    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
"===============================================================================
" NeoBundle
"===============================================================================
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

" Slim syntax coloring =========================================================
NeoBundle 'slim-template/vim-slim'
autocmd BufRead,BufNewFile *.slim setfiletype slim

" Markdown =====================================================================
NeoBundle 'gabrielelana/vim-markdown'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kannokanno/previm'
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

" Indent guides ================================================================
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=gray
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgray


" English dictionaries =========================================================
NeoBundle 'thinca/vim-ref'
NeoBundle 'mfumi/ref-dicts-en'
NeoBundle 'tyru/vim-altercmd'  " Set abbreviation of command which has longer name
NeoBundle 'mattn/webapi-vim'
"NeoBundle 'mattn/excitetranslate-vim'
NeoBundle 'ujihisa/neco-look'

" Close buffer to type q
autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>
autocmd BufEnter ==Translate==\ Excite nnoremap <buffer> <silent> q :<C-u>close<CR>

" Dictionaries
let g:ref_source_webdict_sites = {
            \   'je': {
            \     'url': 'http://ejje.weblio.jp/content/%s',
            \   },
            \   'ej': {
            \     'url': 'http://ejje.weblio.jp/content/%s',
            \   },
            \ }

" Default site
let g:ref_source_webdict_sites.default = 'ej'

" Output filter for pretty display
function! g:ref_source_webdict_sites.je.filter(output)
    return join(split(a:output, "\n")[10 :], "\n")
endfunction

function! g:ref_source_webdict_sites.ej.filter(output)
    return join(split(a:output, "\n")[10 :], "\n")
endfunction

" Abbreviations
"autocmd BufRead *.* AlterCommand ej Ref webdict ej
"autocmd BufRead *.* AlterCommand je Ref webdict je
""autocmd BufRead *.* AlterCommand excite ExciteTranslate

" Git wrapper plugin ===========================================================
NeoBundle 'tpope/vim-fugitive'

" VimShell =====================================================================
NeoBundle 'Shougo/vimshell.vim'
"autocmd BufRead *.* AlterCommand vsh VimShellPop

" Completion ===================================================================
if has('lua')
    NeoBundleLazy 'Shougo/neocomplete.vim', {
                \ 'depends' : 'Shougo/vimproc',
                \ 'autoload' : { 'insert' : 1,}
                \ }
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'Shougo/neosnippet-snippets'
endif
NeoBundle 'kana/vim-smartinput'
NeoBundle 'cohama/vim-smartinput-endwise'

" Ruby coding support ==========================================================
NeoBundle 'vim-ruby/vim-ruby'
"NeoBundle 'todesking/ruby_hl_lvar.vim'
"NeoBundle 'marcus/rsense'
"NeoBundle 'supermomonga/neocomplete-rsense.vim'
NeoBundle 'osyo-manga/vim-monster'

" Refer to Rdoc documentation
NeoBundle 'thinca/vim-ref'    " Already installed
NeoBundle 'yuku-t/vim-ref-ri'
autocmd BufRead *.* AlterCommand ri Ref ri 

" Arrange sentences ============================================================
NeoBundleLazy 'junegunn/vim-easy-align', {
            \ 'autoload': {
            \   'commands' : ['EasyAlign'],
            \   'mappings' : ['<Plug>(EasyAlign)'],
            \ }}

" vim-easy-align {{{/*{{{*/
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
" }}}/*}}}*/

" HTML5 and CSS3 ===============================================================
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'othree/html5.vim'

" JavaScript
NeoBundle 'kchmck/vim-coffee-script'
"NeoBundle 'moll/vim-node'
"NeoBundle 'pangloss/vim-javascript'

" Easymotion ===================================================================
NeoBundle 'Lokaltog/vim-easymotion'

" vim-easymotion {{{
let g:EasyMotion_keys             = 'hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
let g:EasyMotion_leader_key       = 'm'
let g:EasyMotion_grouping         = 1
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_startofline      = 0
let g:EasyMotion_use_upper        = 1
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue
" }}}

" vim-licenses =================================================================
NeoBundle 'antoyo/vim-licenses'
let g:licenses_authors_name = 'Kohei Kakimoto'
let g:licenses_copyright_holders_name = 'Kohei Kakimoto'

" vim-json =====================================================================
" to show double-quote in .json file
NeoBundle 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

" PlantUML support =============================================================
NeoBundle "aklt/plantuml-syntax"

" Correct indentation of HTML and PHP
NeoBundle 'captbaritone/better-indent-support-for-php-with-html'

" Rails support
NeoBundle 'tpope/vim-rails'

nnoremap gf <C-w>vgf

call neobundle#end()

" ==============================================================================
" Autoloaded function call
" These functions should be called after NeoBundle plugin initialization
" ==============================================================================

" Command abbreviations definition
call altercmd#load()
CAlterCommand ej Ref webdict ej
CAlterCommand je Ref webdict je
"CAlterCommand excite ExciteTranslate
CAlterCommand vsh VimShellPop
CAlterCommand ri Ref ri 
CAlterCommand php Ref phpmanual

" Alternative definition of smartinput {{{
call smartinput_endwise#define_default_rules()
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
            \   'at'       : '\".*\%#.*\"',
            \   'char'     : '#',
            \   'input'    : '#{}<Left>',
            \   'filetype' : ['ruby'],
            \   'syntax'   : ['Constant', 'Special'],
            \   })

" "(1..3).each do e" -> type '|' -> "(1..3).each do |e|"
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
            \   'at'       : '\({\|\<do\>\)\s*\%#',
            \   'char'     : '<Bar>',
            \   'input'    : '<Bar><Bar><Left>',
            \   'filetype' : ['ruby'],
            \    })
" }}}

"" Rsense
""let g:rsenseHome = '/usr/local/lib/rsense-0.3'
""let g:rsenseUseOmniFunc = 1
"
" neocomplete {{{
let g:acp_enableAtStartup                         = 0
let g:neocomplete#enable_at_startup               = 1
let g:neocomplete#auto_completion_start_length    = 2
let g:neocomplete#enable_ignore_case              = 1
let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_camel_case               = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#sources#buffer#cache_limit_size = 1000000
let g:neocomplete#sources#tags#cache_limit_size   = 30000000
let g:neocomplete#enable_fuzzy_completion         = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'
let g:neocomplete#sources#dictionary#dictionaries = {
            \   'ruby': $HOME . '/dotfiles/dicts/ruby.dict',
            \ }
if !exists('g:neocomplete#text_mode_filetypes')
    let g:neocomplete#text_mode_filetypes = {}
endif
let g:neocomplete#text_mode_filetypes = {
            \ 'rst':        1,
            \ 'markdown':   1,
            \ 'gitrebase':  1,
            \ 'gitcommit':  1,
            \ 'vcs-commit': 1,
            \ 'hybrid':     1,
            \ 'text':       1,
            \ 'help':       1,
            \ 'tex':        1,
            \ }
" }}}

" neosnippet {{{
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <C-s>     <Plug>(neosnippet_expand_or_jump)
xmap <C-s>     <Plug>(neosnippet_expand_target)
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" }}}

" vim-monster {{{
" Set async completion.
let g:monster#completion#rcodetools#backend = "async_rct_complete"

" With neocomplete.vim
let g:neocomplete#sources#omni#input_patterns = {
            \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
            \}
" }}}

" vim-ref-ri
let g:ref_open = 'split'

" vim-ref PHP manual
let g:ref_phpmanual_path = $HOME . '/dotfiles/refs/php-chunked-xhtml'

" Google Translation
" this feature depends on translate-shell command on your machine
let s:trans_cmd = 'trans'
let s:trans_opt = '-b --no-ansi -e google'
exec 'command! -nargs=0 -range Trans <line1>,<line2>!' . s:trans_cmd . ' ' . s:trans_opt
nnoremap <silent> <F3> :Trans<CR>

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
