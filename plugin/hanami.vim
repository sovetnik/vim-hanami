
" The "Vim Hanami" plugin for Hanami framework support.
"
" Author:    Oleg 'Sovetnik' Siniuk
" URL:       https://github.com/sovetnik/vim-hanami
" Version:   0.2
" Copyright: Copyright (c) 2017 Oleg Siniuk
" License:   MIT
" -----------------------------------------------------

if !exists('g:hanami_map_keys')
  let g:hanami_map_keys = 1
endif

if g:hanami_map_keys
  nnoremap <Leader>x :HanamiAlterToggle<CR>
  nnoremap <Leader>s :HanamiSpecToggle<CR>
endif

command! HanamiAlterToggle :call <SID>SplitToggle('alter')
command! HanamiSpecToggle :call <SID>SplitToggle('spec')
command! HanamiProject :call <SID>HanamiGetProject()
command! HanamiTemplate :call <SID>HanamiGetTemplate()

set swb=useopen

if !exists('g:hanami_open_strategy')
  let g:hanami_open_strategy = 'split'
endif

" App patterns
let s:pattern_action = 'apps/.*/controllers/.*\.rb'
let s:pattern_action_spec = 'spec/.*/controllers/.*_spec.rb'
let s:pattern_view = 'apps/.*/views/.*\.rb'
let s:pattern_view_spec = 'spec/.*/views/.*_spec.rb'

" Lib patterns
let s:pattern_entity =  'lib/.*/entities/.*\.rb'
let s:pattern_repo = 'lib/.*/repositories/.*_repository.rb'
let s:pattern_lib = 'lib/.*\.rb'
let s:pattern_entity_spec = 'spec/.*/entities/.*_spec.rb'
let s:pattern_repo_spec = 'spec/.*/repositories/.*_repository_spec.rb'
let s:pattern_spec = 'spec/.*_spec.rb'

" opens a new window or warns that no hanami file
fu! s:SplitToggle(way)
  let path = expand('%:p')
  if s:HanamiEnsure(path) =~ 0
    echom 'There is not a Hanami file'
  else
    if a:way =~ 'alter'
      if filereadable(s:HanamiAlternate(path))
        return s:SmartOpen(s:HanamiAlternate(path))
      else
        echom 'No file for Alter toggle'
      endif
    elseif a:way =~ 'spec'
      if filereadable(s:HanamiSpecify(path))
        return s:SmartOpen( s:HanamiSpecify(path))
      else
        echom 'No file for Spec toggle'
      endif
    endif
  endif
endfunction

fu! s:SmartOpen(target_path)
  let bufnr = bufnr(a:target_path)
  if bufnr == -1
    exec g:hanami_open_strategy . a:target_path
  else
    exec 'sbuffer' . bufnr
  endif
endfu

" ensures if file in hanami lib or spec folder
" and try read .hanamirc in project root
" returnes 1 or 0
fu! s:HanamiEnsure(path)
  if match(a:path, '/lib/') > -1
    return filereadable(substitute(a:path, 'lib/.*', '.hanamirc', 'g'))
  elseif match(a:path, '/apps/') > -1
    return filereadable(substitute(a:path, 'apps/.*', '.hanamirc', 'g'))
  elseif match(a:path, '/spec/') > -1
    return filereadable(substitute(a:path, 'spec/.*', '.hanamirc', 'g'))
  endif
endfunction

" ===============================================
" Togglers
" ===============================================
" Alternate toggler changes given path to path to
" alter ego of given path file.
" Entity <-> Repo, Action <-> View 
" and their specs respectively
" ===============================================
fu! s:HanamiAlternate(path)
 if a:path =~ s:pattern_repo_spec
    return s:PathSpecRepoToEntity(a:path)
  elseif a:path =~ s:pattern_entity_spec
    return s:PathSpecEntityToRepo(a:path)
  elseif a:path =~ s:pattern_repo
    return s:PathLibRepoToEntity(a:path)
  elseif a:path =~ s:pattern_entity
    return s:PathLibEntityToRepo(a:path)
  elseif a:path =~ s:pattern_action || a:path =~ s:pattern_action_spec
    return s:PathActionToView(a:path)
  elseif a:path =~ s:pattern_view || a:path =~ s:pattern_view_spec
    return s:PathViewToAction(a:path)
  endif
endfunction

" ===============================================
" Specify toggler changes given path to path to
" specification and vice versa.
" ===============================================
fu! s:HanamiSpecify(path)
  if a:path =~ s:pattern_action || a:path =~ s:pattern_view
    return s:PathAppToSpec(a:path)
  elseif a:path =~ s:pattern_action_spec || a:path =~ s:pattern_view_spec
    return s:PathSpecToApp(a:path)
  elseif a:path =~ s:pattern_repo_spec || a:path =~ s:pattern_spec
    return s:PathSpecToLib(a:path)
  elseif a:path =~ s:pattern_repo || a:path =~ s:pattern_lib
    return s:PathLibToSpec(a:path)
  endif
endfunction

" ===============================================
" Path transformation methods
" accepts path, return path
" ===============================================
" App Part
" ===============================================
fu! s:PathAppToSpec(path)
  let path = substitute(a:path, '/apps/', '/spec/', 'g')
  let path = substitute(path, '.rb', '_spec.rb', 'g')
  return path
endfunction

fu! s:PathSpecToApp(path)
  let path = substitute(a:path, '/spec/', '/apps/', 'g')
  let path = substitute(path, '_spec.rb', '.rb', 'g')
  return path
endfunction

fu! s:PathActionToView(path)
  let path = substitute(a:path, '/controllers/', '/views/', 'g')
  return path
endfunction

fu! s:PathViewToAction(path)
  let path = substitute(a:path, '/views/', '/controllers/', 'g')
  return path
endfunction

" ===============================================
" Lib Part
" ===============================================
fu! s:PathLibEntityToRepo(path)
  let path = substitute(a:path , '/entities/', '/repositories/', 'g')
  let path = substitute(path , '.rb', '_repository.rb', 'g')
  return path
endfunction

fu! s:PathLibRepoToEntity(path)
  let path = substitute(a:path, '/repositories/', '/entities/', 'g')
  let path = substitute(path, '_repository.rb', '.rb', 'g') 
  return path
endfunction

fu! s:PathSpecEntityToRepo(path)
  let path = substitute(a:path , '/entities/', '/repositories/', 'g')
  let path = substitute(path , '_spec.rb', '_repository_spec.rb', 'g')
  return path
endfunction

fu! s:PathSpecRepoToEntity(path)
  let path = substitute(a:path, '/repositories/', '/entities/', 'g')
  let path = substitute(path, '_repository_spec.rb', '_spec.rb', 'g') 
  return path
endfunction

fu! s:PathLibToSpec(path)
  let path = substitute(a:path, '/lib/', '/spec/', 'g')
  let path = substitute(path, '.rb', '_spec.rb', 'g')
  return path
endfunction

fu! s:PathSpecToLib(path)
  let path = substitute(a:path, '/spec/', '/lib/', 'g')
  let path = substitute(path, '_spec.rb', '.rb', 'g')
  return path
endfunction

" ===============================================
" Readers from .hanamirc
" ===============================================
fu! s:HanamiGetProject()
  echom s:HanamiReadRc(s:HanamiRcPath(expand('%:p')), 'project=')
endfunction

fu! s:HanamiGetTemplate()
  echom s:HanamiReadRc(s:HanamiRcPath(expand('%:p')), 'template=')
endfunction

" read template engine from .hanamirc
fu! s:HanamiReadRc(path_to_rc, target)
  return a:path_to_rc =~ 0 ? 0 : substitute(matchstr(readfile(a:path_to_rc), a:target), a:target, '', 'g')
endfunction

" check if file in hanami apps, lib or spec folder
" and try read .hanamirc in project root
" returnes path_to_rc 0
fu! s:HanamiRcPath(path)
  if match(a:path, '/apps/') > -1
    if filereadable(substitute(a:path, 'apps/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'apps/.*', '.hanamirc', 'g')
    endif
  elseif match(a:path, '/lib/') > -1
    if filereadable(substitute(a:path, 'lib/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'lib/.*', '.hanamirc', 'g')
    endif
  elseif match(a:path, '/spec/') > -1
    if filereadable(substitute(a:path, 'spec/.*', '.hanamirc', 'g'))
      return substitute(a:path, 'spec/.*', '.hanamirc', 'g')
    endif
  endif
endfunction
