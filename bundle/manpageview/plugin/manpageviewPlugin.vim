" manpageviewPlugin.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Aug 06, 2012
"   Version:	25b
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_manpageviewPlugin")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Public Interface: {{{1
if !hasmapto('<Plug>ManPageView') && &kp =~ '^man\>'
 nmap <unique> K <Plug>ManPageView
endif
"nno <silent> <script> <Plug>ManPageView	:call manpageview#ManPageView(1,v:count,expand("<cword>"))<CR>
nno <silent> <script> <Plug>ManPageView		:call manpageview#KMap(expand("<cword>"))<cr>

com! -nargs=* -count=0	Man		call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	HMan	let g:manpageview_winopen="hsplit" |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	HEMan	let g:manpageview_winopen="hsplit="|call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	OMan	let g:manpageview_winopen="only"   |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	RMan	let g:manpageview_winopen="reuse"  |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	VEMan	let g:manpageview_winopen="vsplit="|call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	VMan	let g:manpageview_winopen="vsplit" |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	TMan	let g:manpageview_winopen="tab"    |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=? -count=0	KMan	call manpageview#KMan(<q-args>)
com! -nargs=* -count=1	Manprv	call manpageview#History(-<count>)
com! -nargs=* -count=1	Mannxt	call manpageview#History(<count>)

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
