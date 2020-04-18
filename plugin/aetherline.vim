let s:save_cpo = &cpo
set cpo&vim

set statusline=%!aetherline#render()

let &cpo = s:save_cpo
unlet s:save_cpo
