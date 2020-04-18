
let s:aetherline = get(g:, 'aetherline', {})
let s:ends = get(s:aetherline, 'ends', {'start': "▐", 'end': "▌"})
let s:sep = get(s:aetherline, 'separator', '│')
let s:padding = get(s:aetherline, 'padding', 1)
let s:sections = get(s:aetherline, 'sections', [[function('aetherline#mode')], ['%f', '%m']])
let s:modes = get(s:aetherline, 'modes', {
			\ 'n': '⌘',
			\ 'i': '✎',
			\ 'v': '⌶',
			\})

let s:highlight_stack = []
:
function! aetherline#mode()
	let l:mode = mode()
	return get(s:modes, l:mode[0], l:mode) . ' '
endfunction

function! aetherline#map(list, func)
	let copy = deepcopy(a:list)
	call map(copy, a:func)
	return copy
endfunction

function! aetherline#pad(item)
	return repeat(' ', s:padding) . a:item . repeat(' ', s:padding)
endfunction

function! aetherline#separator()
	return aetherline#highlight('AetherlineSeparator') . s:sep . aetherline#highlight('AetherlineSection')
endfunction

function! aetherline#subsection(_, item)
	if type(a:item) == v:t_string
		return a:item
	elseif type(a:item) == v:t_func
		return '%{' . string(a:item) . '()}' " lmao
	end
endfunction

function! aetherline#end(which)
	return aetherline#highlight('AetherlineEnd') . s:ends[a:which]
endfunction

function! aetherline#section(_, subsections)
	return aetherline#end('start') .
				\ aetherline#highlight('AetherlineSection') .
				\ join(
				\   aetherline#map(a:subsections, function('aetherline#subsection')),
				\   aetherline#separator()
				\ ) .
				\ aetherline#end('end') .
				\ aetherline#highlight('AetherlineBackground')
endfunction

function! aetherline#highlight(group)
	return '%#' . a:group . '#'
endfunction

function! aetherline#render()
	return aetherline#highlight('AetherlineBackground') . join(aetherline#map(s:sections, function('aetherline#section')), '')
endfunction

hi AetherlineBackground guibg=bg
hi AetherlineSection guibg=#3a3833
hi AetherlineSeparator guifg=bg guibg=#3a3833
hi AetherlineEnd guifg=#3a3833
