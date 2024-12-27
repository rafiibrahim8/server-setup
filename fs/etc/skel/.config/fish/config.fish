# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "/bin/sh -c '/usr/bin/col -bx | /usr/bin/batcat -l man -p'"
set -x EDITOR nano

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add ~/go/bin to PATH
if test -d ~/go/bin
    if not contains -- ~/go/bin $PATH
        set -p PATH ~/go/bin
    end
end

# Add ~/.cargo/bin to PATH
if test -d ~/.cargo/bin                                       
    if not contains -- ~/.cargo/bin $PATH
        set -p PATH ~/.cargo/bin                                      
    end
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

## Starship prompt and mcfly
if status --is-interactive
   starship init fish | source
end

function backup --argument filename
    cp $filename $filename.bak
end


# Replace ls with exa
alias ls='exa -al --color --group-directories-first --icons' # preferred listing
alias la='exa -a --color --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color --group-directories-first --icons'  # long format
alias lt='exa -aT --color --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles
alias ip="ip -color"

# Replace some more things with better alternatives
alias cat='batcat --style header --style snip --style changes --style header'
alias df=duf
# Common use
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info
alias tb='nc termbin.com 9999'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Useful alias
alias wget-recursive="wget --recursive  --no-parent --execute 'robots=off' --reject 'index.html*'"
alias toclip="xclip -selection c"
alias cat_=/bin/cat
alias crontab="crontab -i"
