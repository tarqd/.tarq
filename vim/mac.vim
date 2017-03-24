" OSX Movement Hotkeys (With Smart Home/End)
let macvim_skip_cmd_opt_movement = 1

map  <D-Left>       <Home>
map! <D-Left>       <Home>
no   <M-Left>       <C-Left>
no!  <M-Left>       <C-Left>

map  <D-Right>      <End>
map! <D-Right>      <End>
no   <M-Right>      <C-Right>
no!  <M-Right>      <C-Right>

map  <D-Up>         <C-Home>
imap <D-Up>         <C-Home>
no   <M-Up>         {
ino  <M-Up>         <C-o>{

no  <D-Down>       <C-End>
ino <D-Down>       <C-End>
no  <M-Down>       }
ino <M-Down>       <C-o>}

ino   <M-BS>         <C-w>
ino   <D-BS>         <C-u>

" Terminal doesn't support Command :(
map <C-Left> <D-Left>
map! <C-Left> <D-Left>

map <C-Right> <D-Right>
map! <C-Right> <D-Right>

map <C-Up> <D-Up>
map! <C-Up> <D-Up>

map <C-Down> <D-Down>
map! <C-Down> <D-Down>

" Selection Hotkeys (Smart Home/End)
nmap <S-D-Left>     v<Home>
vmap <S-D-Left>     <Home>
imap <S-D-Left>     <C-\><C-n>gh<Home>

nn   <S-M-Left>     v<C-Left>
vn   <S-M-Left>     <C-Left>
ino  <S-M-Left>     <C-\><C-n>gh<C-Left>

nmap  <S-D-Right>    v<End>
vmap  <S-D-Right>    <End>
imap  <S-D-Right>    <C-\><C-n>gh<End>

nn   <S-M-Right>    v<C-Right>
vn   <S-M-Right>    <C-Right>
ino  <S-M-Right>    <C-\><C-n>gh<C-Right>

nn   <S-D-Up>       v<C-Home>
vn   <S-D-Up>       <C-Home>
ino  <S-D-Up>       <C-\><C-n>gh<C-Home>

nn   <S-M-Up>       v{
vn   <S-M-Up>       {
ino  <S-M-Up>       <C-\><C-n>gh{

nn   <S-D-Down>     v<S-C-End>
vn   <S-D-Down>     <S-C-End>
ino  <S-D-Down>     <C-\><C-n>gh<S-C-End>

nn   <S-M-Down>       v}
vn   <S-M-Down>       }
ino  <S-M-Down>       <C-\><C-n>gh}

" Terminal Hackery
nmap <S-C-Left>        <S-D-Left>
vmap <S-C-Left>        <S-D-Left>
imap <S-C-Left>        <S-D-Left>

nmap <S-C-Right>        <S-D-Right>
vmap <S-C-Right>        <S-D-Right>
imap <S-C-Right>        <S-D-Right>

nmap <S-C-Up>        <S-D-Up>
vmap <S-C-Up>        <S-D-Up>
imap <S-C-Up>        <S-D-Up>

nmap <S-C-Down>        <S-D-Down>
vmap <S-C-Down>        <S-D-Down>
imap <S-C-Down>        <S-D-Down>

