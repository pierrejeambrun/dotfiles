" Plugins
call plug#begin('~/.config/nvim')
Plug 'honza/vim-snippets'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neoclide/coc.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Coc Extensions
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-eslint', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-pyright', 'coc-htmldjango', 'coc-snippets']
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'github/copilot.vim'
Plug 'sheerun/vim-polyglot'
Plug 'arcticicestudio/nord-vim'
call plug#end()

" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*

" Highlight Yanked text
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 120, higroup = 'Visual'})
augroup END

" Move text around
vnoremap J :m '>+1<CR>gv
vnoremap K :m '<-2<CR>gv

" Keep it centered
nnoremap Y yg$
nnoremap n nzzzv
nnoremap N Nzzzv

" Save
nnoremap <c-s> :w<CR>
vnoremap <c-s> <Esc><c-s>
inoremap <c-s> <Esc><c-s>

" Undo breakpoints
inoremap ! !<c-g>u
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u

" Visual mode, delete to black hole register first
xnoremap p "_dP

" Folds
set foldlevel=99
autocmd BufRead,BufNewFile *.py setlocal foldmethod=indent

" Exit terminal
tnoremap <C-[> <C-\><C-n>

" Splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Telescope
nnoremap <space>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <space>fb <cmd>Telescope buffers<cr>
nnoremap <space>fg <cmd>Telescope live_grep hidden=true<cr>
nnoremap <space>fh <cmd>Telescope help_tags<cr>
nnoremap <space>fs <cmd>Telescope git_status<cr>
lua require'telescope'.setup { defaults = { mappings = { i = { ["<leader>qf"] = "send_selected_to_qflist", ['<leader>bd'] = "delete_buffer"}, n = { ["<leader>qf"] = "send_selected_to_qflist", ['<leader>bd'] = "delete_buffer"}}}}
autocmd User TelescopePreviewerLoaded setlocal wrap

" NERDTree
let NERDTreeShowHidden=1
nnoremap <space>n :NERDTreeToggle<CR>
nnoremap <A-1> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<cr>

" Coc
let g:python3_host_prog = '~/.virtualenvs/nvim/bin/python'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <leader>rf <Plug>(coc-refactor)
nmap <leader>a <cmd>CocFix<cr>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
" Apply AutoFix to problem on the current line.
nmap <leader>fc  <Plug>(coc-fix-current)
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
" Do default action for next item.
nnoremap <silent><nowait> <space>k  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>j  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
autocmd BufWritePost *.py :CocCommand python.sortImports
au BufWrite *.py silent call CocAction('format') " Only if black timeout with 500ms


" Quickfix List
nnoremap <space>co <cmd>copen<cr>
nnoremap <space>cc <cmd>cclose<cr>

" Indent
vnoremap > >gv
vnoremap < <gv
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab
autocmd BufRead,BufNewFile *.htm,*.html,*.tsx,*.ts,*.js,*.jsx setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Buffers
nnoremap <space>q <cmd>bd<cr>

" Gitgutter
let g:gitgutter_preview_win_floating = 0
nnoremap <space>hu <cmd>GitGutterUndoHunk <cr>
nnoremap <space>hp <cmd>GitGutterPreviewHunk <cr>
highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red

" Vim airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'nord'
set noshowmode

" Misc
set history=500
set relativenumber
set number
set updatetime=250
set list
set listchars=tab:>-,trail:~,extends:>,precedes:< "eol:$,
set clipboard=unnamedplus
set ignorecase
set smartcase

" Color Theme (xterm 256 colors)
colorscheme nord
highlight Comment ctermfg=DarkGreen
highlight LineNr ctermfg=222 cterm=italic
highlight Visual ctermbg=222 ctermfg=Black
set cursorline
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver25
augroup END
highlight CocFadeOut  ctermfg=243 cterm=underline
