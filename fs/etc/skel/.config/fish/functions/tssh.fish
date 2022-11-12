# Defined via `source`
function tssh --wraps='ssh -o UserKnownHostsFile=/tmp/tssh.known' --description 'alias tssh=ssh -o UserKnownHostsFile=/tmp/tssh.known'
  ssh -o UserKnownHostsFile=/tmp/tssh.known $argv; 
end
