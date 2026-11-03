".exrc - POSIX 2024 vi/ex initialization
"
" BusyBox vi v1.38.0 reads this file ($HOME/.exrc) at startup.
" See IEEE Std 1003.1-2024, ex Initialization: EXINIT first, then $HOME/.exrc,
" then ./exrc if the exrc option is set.
"
" File permissions are significant per POSIX: .exrc must be owned by the
" invoking user and not writable by anyone else (chmod 600).

set autoindent
set ignorecase
set showmatch
set tabstop=8
set noflash
set wrapscan
set scroll=12
set window=24
set report=5
set warn
set remap

" Modelines are a security risk; POSIX vendors are encouraged to omit them.
" BusyBox vi does not implement modelines, so this is documentation only.
set nomodeline 2>/dev/null || true
