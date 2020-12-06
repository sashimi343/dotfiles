" insert comment strings and indent automatically
setlocal comments=sr:/*,mb:*,ex:*/

" synonymous with :setlocal formatoptions=croql
" don't use = operator with formatoptions" see :help 'formatoptions'
setlocal formatoptions-=t
setlocal formatoptions+=rol
