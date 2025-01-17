" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-indentguides

let g:indentguides_firstlevel = get(g:, 'indentguides_firstlevel', 0)
let g:indentguides_ignorelist = get(g:, 'indentguides_ignorelist', ['asciidoc', 'gitcommit', 'markdown', 'tex', 'text', ''])
let g:indentguides_spacechar = get(g:, 'indentguides_spacechar', '┆')
let g:indentguides_tabchar = get(g:, 'indentguides_tabchar', '|')
let g:indentguides_toggleListMode = get(g:, 'indentguides_toggleListMode', 1)
let g:indentguides_guidewidth = get(g:, 'indentguides_guidewidth', &l:shiftwidth)
let g:indentguides_conceal_color = get(g:, 'indentguides_conceal_color', 'ctermfg=238 ctermbg=NONE guifg=Grey27 guibg=NONE')
let g:indentguides_specialkey_color = get(g:, 'indentguides_specialkey_color',  'ctermfg=238 ctermbg=NONE guifg=Grey27 guibg=NONE')
let g:indentguides_enabled = get(g:, 'indentguides_enabled', 1)

function! s:SetIndentGuideHighlights()
  if hlexists('IndentGuideSpaces')
    syntax clear IndentGuideSpaces
  endif
  if hlexists('IndentGuideDraw')
    syntax clear IndentGuideDraw
  endif

  if g:indentguides_firstlevel
    execute printf('syntax match IndentGuideDraw /^\zs\ \ze\ \{%i}/ containedin=ALL conceal cchar=', g:indentguides_guidewidth - 1) . g:indentguides_spacechar
  endif
  execute 'syntax match IndentGuideSpaces /^\ \+/ containedin=ALL contains=IndentGuideDraw keepend'
  execute printf('syntax match IndentGuideDraw /\ \{%i}\zs \ze/ contained conceal cchar=', g:indentguides_guidewidth - 1) . g:indentguides_spacechar

  execute "highlight Conceal " . g:indentguides_conceal_color
  execute "highlight SpecialKey " . g:indentguides_specialkey_color
endfunction

function! s:ToggleIndentGuides(user_initiated)
  let b:indentguides_on = get(b:, 'indentguides_on', -1)
  let g:indentguides_guidewidth = &l:shiftwidth

  " TODO-TK: local and global listchars are the same, and s: variables are failing (??)
  let g:original_listchars = get(g:, 'original_listchars', &g:listchars)
  let w:original_concealcursor = get(w:, 'original_concealcursor', &l:concealcursor)
  let w:original_conceallevel = get(w:, 'original_conceallevel', &l:conceallevel)

  if !a:user_initiated
    " not toggled on or off yet
    if b:indentguides_on == -1
      if index(g:indentguides_ignorelist, &filetype) == -1 && g:indentguides_enabled
        let toggle_indentguides = 1
      else
        return
      endif
    " already toggled on
    elseif b:indentguides_on == 1
      let toggle_indentguides = 1
    " already toggle off
    else
      return
    endif
  else  " user initiated toggle
    if b:indentguides_on == 1
      let toggle_indentguides = 0
    else
      let toggle_indentguides = 1
    endif
  endif

  if toggle_indentguides
    call s:SetIndentGuideHighlights()

    " TODO: figure out why checking each addition individually breaks things for tab (unicode?)
    let listchar_guides = ',tab:' . g:indentguides_tabchar . ' ,trail:·'
    if &g:listchars !~ listchar_guides
      let &g:listchars = &g:listchars . listchar_guides
    endif
    if &conceallevel == 0 || &conceallevel == 3
      setlocal conceallevel=2
    endif
    if &concealcursor ==# '' && !exists('g:indentguides_concealcursor_unaltered')
      setlocal concealcursor=inc
    endif
    if g:indentguides_toggleListMode
      setlocal list
    endif
    let b:indentguides_on = 1
  else
    syntax clear IndentGuideSpaces
    syntax clear IndentGuideDraw

    let &l:conceallevel = w:original_conceallevel
    let &l:concealcursor = w:original_concealcursor
    let &g:listchars = g:original_listchars
    if g:indentguides_toggleListMode
      setlocal nolist
    endif
    let b:indentguides_on = 0
  endif
endfunction

augroup IndentGuides
  au!
  au ColorScheme * call s:SetIndentGuideHighlights()
  au BufEnter * call s:ToggleIndentGuides(0)
augroup END

command! IndentGuidesToggle call s:ToggleIndentGuides(1)

" vim: ts=2 sw=2 et
