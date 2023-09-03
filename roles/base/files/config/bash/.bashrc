#
# ~/.bashrc
#
export EDITOR='nvim'
export TERM=xterm-256color
export QT_QPA_PLATFORMTHEME=kvantum
export GTK_USE_PORTAL=1
#export XDG_SESSION_TYPE=wayland
#export GDK_BACKEND=wayland
#export MOZ_ENABLE_WAYLAND=1
export QT_STYLE_OVERRIDE=kvantum
export SWWW_TRANSITION=center
export INTERVAL=60
export SWWW_TRANSITION_STEP=2
export XDG_CACHE_HOME=$HOME/.cache
export SWWW_TRANSITION_FPS=60
#export WOBSOCK=$XDG_RUNTIME_DIR/wob.sock
#export XDG_CURRENT_DESKTOP=Hyprland
#export XDG_SESSION_TYPE=wayland
#export XDG_SESSION_DESKTOP=Hyprland
#export QT_QPA_PLATFORM="wayland;xcb"


alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias rm='trash'


lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_my_PS1() {
    PS1='[\u@\h \W]\$ '
    if [ "$(whoami)" = "liveuser" ] ; then
        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
        if [ -n "$iso_version" ] ; then
            local prefix="eos-"
            local iso_info="$prefix$iso_version"
            PS1="[\u@$iso_info \W]\$ "
        fi
    fi
}
_set_my_PS1
unset -f _set_my_PS1

ShowInstallerIsoInfo() {
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        cat $file
    else
        echo "Sorry, installer ISO info is not available." >&2
    fi
}


alias ls='exa --all --long --icons --color=always --group-directories-first'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.


_GeneralCmdCheck() {
    # A helper for functions UpdateArchPackages and UpdateAURPackages.

    echo "$@" >&2
    "$@" || {
        echo "Error: '$*' failed." >&2
        exit 1
    }
}

_CheckInternetConnection() {
    # curl --silent --connect-timeout 8 https://8.8.8.8 >/dev/null
    eos-connection-checker
    local result=$?
    test $result -eq 0 || echo "No internet connection!" >&2
    return $result
}

_CheckArchNews() {
    local conf=/etc/eos-update-notifier.conf

    if [ -z "$CheckArchNewsForYou" ] && [ -r $conf ] ; then
        source $conf
    fi

    if [ "$CheckArchNewsForYou" = "yes" ] ; then
        local news="$(yay -Pw)"
        if [ -n "$news" ] ; then
            echo "Arch news:" >&2
            echo "$news" >&2
            echo "" >&2
            # read -p "Press ENTER to continue (or Ctrl-C to stop): "
        else
            echo "No Arch news." >&2
        fi
    fi
}

UpdateArchPackages() {
    # Updates Arch packages.

    _CheckInternetConnection || return 1

    _CheckArchNews

    #local updates="$(yay -Qu --repo)"
    local updates="$(checkupdates)"
    if [ -n "$updates" ] ; then
        echo "Updates from upstream:" >&2
        echo "$updates" | sed 's|^|    |' >&2
        _GeneralCmdCheck sudo pacman -Syu "$@"
        return 0
    else
        echo "No upstream updates." >&2
        return 1
    fi
}

UpdateAURPackages() {
    # Updates AUR packages.

    _CheckInternetConnection || return 1

    local updates
    if [ -x /usr/bin/yay ] ; then
        updates="$(yay -Qua)"
        if [ -n "$updates" ] ; then
            echo "Updates from AUR:" >&2
            echo "$updates" | sed 's|^|    |' >&2
            _GeneralCmdCheck yay -Syua "$@"
        else
            echo "No AUR updates." >&2
        fi
    else
        echo "Warning: /usr/bin/yay does not exist." >&2
    fi
}

UpdateAllPackages() {
    # Updates all packages in the system.
    # Upstream (i.e. Arch) packages are updated first.
    # If there are Arch updates, you should run
    # this function a second time to update
    # the AUR packages too.

    UpdateArchPackages || UpdateAURPackages
}


_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1: Do not use for executable files!
    # Note2: uses mime bindings, so you may need to use
    #        e.g. a file manager to make some file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $*" >&2
        /usr/bin/exo-open "$@" >& /dev/null &
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            /usr/bin/xdg-open "$file" >& /dev/null &
        done
        return
    fi

    echo "Sorry, none of programs [$progs] is found." >&2
    echo "Tip: install one of packages" >&2
    for prog in $progs ; do
        echo "    $(pacman -Qqo "$prog")" >&2
    done
}

_Pacdiff() {
    local differ pacdiff=/usr/bin/pacdiff

    if [ -n "$(echo q | DIFFPROG=diff $pacdiff)" ] ; then
        for differ in kdiff3 meld diffuse ; do
            if [ -x /usr/bin/$differ ] ; then
                DIFFPROG=$differ su-c_wrapper $pacdiff
                break
            fi
        done
    fi
}
#vifm 
vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
alias nnn='nnn -Hade'
alias cat='bat'
# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=_Pacdiff
################################################################################
eval "$(starship init bash)"
#fm6000 -r -c blue
HISTCONTROL=ingnoreboth
HISTTIMEFORMAT="%Y-%m-%d %T "
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:~/.config/rofi
alias vw='vim -c VimwikiIndex'
alias v='nvim '
alias se='sudoedit '
alias spt='spotifyd && spt '
alias pc='protonvpn-cli connect'
alias pr='protonvpn-cli reconnect'
alias zj='zellij'
alias lob='lobster'
#source /home/jaziel/.config/broot/launcher/bash/br
#eval $(keychain --eval --quiet)

pfetch
