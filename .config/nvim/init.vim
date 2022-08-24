" Plugins
call plug#begin('~/.config/nvim')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'AckslD/nvim-neoclip.lua'
Plug 'neoclide/coc.nvim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'github/copilot.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'honza/vim-snippets'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'maxmellon/vim-jsx-pretty'
Plug 'windwp/nvim-autopairs'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'tpope/vim-dotenv'
" Plug 'sheerun/vim-polyglot'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'yuezk/vim-js'
" Plug 'vim-airline/vim-airline-themes'
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

" Autocommands / Folds
set foldlevel=99
autocmd BufRead,BufNewFile *.py setlocal foldmethod=indent
autocmd BufRead,BufNewFile Jenkinsfile setlocal filetype=groovy


" Exit terminal
tnoremap <C-[> <C-\><C-n>

" Splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Telescope
nnoremap <space>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <space>fa <cmd>Telescope find_files hidden=true no_ignore=true<cr>
nnoremap <space>fb <cmd>Telescope buffers<cr>
nnoremap <space>fg <cmd>Telescope live_grep<cr>
nnoremap <space>fh <cmd>Telescope help_tags<cr>
nnoremap <space>fs <cmd>Telescope git_status<cr>
nnoremap <space>fp <cmd>Telescope neoclip<cr>
" autocmd User TelescopePreviewerLoaded setlocal wrap
lua << EOF
local previewers = require('telescope.previewers')

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 200000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require'telescope'.setup {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            preview_width = 0.55,
        },
        vimgrep_arguments = {
                'rg',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
 --               '--no-ignore',
        },
        file_ignore_patterns = {
                '*.pyc',
                'node_modules/',
                '.git/',
        },
        buffer_previewer_maker = new_maker,
        mappings = {
            i = {
                    ["<leader>qf"] = "send_selected_to_qflist",
                    ['<leader>bd'] = "delete_buffer"
            },
            n = {
                    ["<leader>qf"] = "send_selected_to_qflist",
                    ['<leader>bd'] = "delete_buffer"
            }
        }
    }
}
require 'telescope'.load_extension('neoclip')
require 'telescope'.load_extension('coc')
require 'neoclip'.setup({})
EOF

" NERDTree
let NERDTreeShowHidden=1
nnoremap <space>n :NERDTreeToggle<CR>
nnoremap <A-1> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<cr>

" Coc
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-eslint', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-pyright', 'coc-htmldjango', 'coc-snippets']
let g:python3_host_prog = '~/.virtualenvs/nvim/bin/python'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <space>fd <cmd>Telescope coc diagnostics<cr>
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
map <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>rf <Plug>(coc-refactor)
nmap <leader>a <cmd>CocFix<cr>
nmap <leader>fc  <Plug>(coc-fix-current)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
" Apply AutoFix to problem on the current line.
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

" Fugitive
nnoremap <space>fh <cmd>Gclog %<cr>

" Nvim Autopairs
lua << EOF
require('nvim-autopairs').setup(
    {
        disable_filetype = { "TelescopePrompt" , "vim" },
    }
)
EOF

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
autocmd BufEnter *.htm,*.html,*.tsx,*.ts,*.js,*.jsx,*.json setlocal tabstop=2 shiftwidth=2 softtabstop=2

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
" let g:airline#extensions#tabline#enabled = 1
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
set splitright
noremap <CR> :noh<CR><CR>

" Color Theme (xterm 256 colors)
let g:nord_uniform_diff_background = 1
colorscheme nord
highlight Comment ctermfg=DarkGreen
highlight LineNr ctermfg=222 cterm=italic
highlight Visual ctermbg=222 ctermfg=Black
set cursorline
highlight CocFadeOut  ctermfg=243 cterm=underline

" Cursors
set guicursor=i:hor20
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20
augroup END
