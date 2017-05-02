# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# add things to ignore from history
export HISTIGNORE=w:ls:fg:bg:id:jobs:

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Turn on extended pattern matching
shopt -s extglob

# Append to the history file instead of destroying it every time.
shopt -s histappend

# Attempt to perform hostname completion when a word containing an @ is being
# completed.
shopt -s hostcomplete

# Do not attempt to search the PATH for possible completions when completion is
# attempted on an empty line.
shopt -s no_empty_cmd_completion

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#Make sure my emacs backup directory exists.
EMACS_BACKUP_DIR=~/.emacs.d/backups/
if [ ! -d $EMACS_BACKUP_DIR ] ; then
    echo "Emacs Backup Directory doesn't exist."
    echo "Creating $EMACS_BACKUP_DIR"
    mkdir -p $EMACS_BACKUP_DIR
fi


#Set up information for virtualenvwrapper
# On a mac, use pip, not brew to install virtualenvwrapper!
export WORKON_HOME=~/Envs
export PROJECT_HOME=$HOME/dev
if [ -f /usr/local/bin/virtualenvwrapper.sh ] ; then
    source /usr/local/bin/virtualenvwrapper.sh;
elif [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ] ; then
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh;
else
    echo "VirtualenvWrapper not installed."
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function parse_git_dirty {
    if [[ $(git status 2> /dev/null | tail -n1) =~ "nothing to commit" ]]
    then
        echo "";
    else
        echo "*"
    fi
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

function white_background ()
{
    TXTRED="\e[0;31m"
    TXTGRN="\e[0;32m"
    VENV='$(if [ ${VIRTUAL_ENV} ];then echo -ne "(`basename $VIRTUAL_ENV`)"; fi)'

    if [ `uname -s` = 'Darwin' ]; then
	    export PROMPT_COMMAND='if [ $? != 0 ] ; then RET="$TXTRED:(" ; else RET="$TXTGRN:)" ; fi ; PGB=$(parse_git_branch); PS1="$RET\[\e[30m\]${VENV}${PGB} \w\[\e[0m\]\n\[\e[30m\]\u@\[\e[30;1m\]\h\[\e[0m\]\[\e[30m\][\t]\$\[\e[0m\] "'
    else
	    P_CMD="echo -ne \033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
	    PROMPT_COMMAND='RET=$?; PS1="${VENV}$(parse_git_branch) $RET_SMILEY \[\e[30m\]\w\[\e[0m\]\n\[\e[30m\]\u@\[\e[30;1m\]\h\[\e[0m\]\[\e[30m\][\t]\$\[\e[0m\] "; $P_CMD'
	    RET_SMILEY='$(if [[ $RET = 0 ]]; then echo -ne "\[$TXTGRN\]:)"; else echo -ne "\[$TXTRED\]:("; fi;)'
    fi
}

function black_background ()
{
    TXTPINK="\e[0;35m"
    TXTGRN="\e[0;32m"
    VENV='$(if [ ${VIRTUAL_ENV} ];then echo -ne "(`basename $VIRTUAL_ENV`)"; fi)'

    if [ `uname -s` = 'Darwin' ]; then
        export PROMPT_COMMAND='if [ $? != 0 ] ; then RET="$TXTPINK:(" ; else RET="$TXTGRN:)" ; fi ; PGB=$(parse_git_branch); PS1="$RET \[\e[37m\]${VENV}${PGB} \w\[\e[0m\]\n\[\e[37m\]\u@\[\e[37;1m\]\h\[\e[0m\]\[\e[37m\][\t]\$\[\e[0m\] "'
    else
	    P_CMD="echo -ne \033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
	    PROMPT_COMMAND='RET=$?; PS1="${VENV}$(parse_git_branch) $RET_SMILEY \[\e[37m\]\w\[\e[0m\]\n\[\e[37m\]\u@\[\e[37;1m\]\h\[\e[0m\]\[\e[37m\][\t]\$\[\e[0m\] "; $P_CMD'
	    RET_SMILEY='$(if [[ $RET = 0 ]]; then echo -ne "\[$TXTGRN\]:)"; else echo -ne "\[$TXTPINK\]:("; fi;)'
    fi
}

if [ "$color_prompt" = yes ]; then
    black_background #Default to the assumption we're on a black background
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PROMPT_COMMAND="echo -ne \"\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007\";"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#Settle on a name, people!
REAL_ACK=$(command -v ack)
function ack()
{
    if command -v ack-grep >/dev/null 2>&1 ; then
        ack-grep $*
    elif [ -n $REAL_ACK ] >/dev/null 2>&1 ; then
        $REAL_ACK $*
    else
        echo "ack not found or not on the path."
    fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# THE OMG AWESOMENESS of ssh host completion
# Alas known_hosts no longer contains clear-text hostnames :(
#SSH_COMPLETE=( $(cut -f1 -d' ' ~/.ssh/known_hosts |\
#                tr ',' '\n' |\
#                sort -u |\
#                grep -e '[:alpha:]') )
#complete -o default -W "${SSH_COMPLETE[*]}" ssh

###
## Green's greatness for dealing with ssh agents and screen:

validagent=/tmp/$USER-ssh-agent/valid-agent
validagentdir=`dirname ${validagent}`
# if it's not a directory or it doesn't exist, make it.
if [ ! -d ${validagentdir} ]
then
    # just in case it's a file
    rm -f ${validagentdir}
    mkdir -p ${validagentdir}
    chmod 700 ${validagentdir}
fi
# only proceed if it's owned by me
if [ -O ${validagentdir} ]
then
    # and the ssh socket isn't already the symlink
    if [ "x$validagent" != "x$SSH_AUTH_SOCK" ]
        then
            # and the socket actually exists and is a socket
        if [ -S $SSH_AUTH_SOCK ]
            then
                # and it's not empty (i.e. no forwarded agent)
            if [ ! -z $SSH_AUTH_SOCK ]
                then
                    # if the current symlink works, don't touch it.
                orig_sock=$SSH_AUTH_SOCK
                SSH_AUTH_SOCK=${validagent}
                    # can ssh-add get a listing of keys from the agent?
                ssh-add -l >/dev/null 2>&1
                result=$?
                if [ $result -ne 0 ]
                    then
                        # ${validagent} is not valid.  make it so!

                        # make sure tmpreaper doesn't remove my dir
                    touch $validagentdir
                        # make the symlink
                    ln -sf $orig_sock $validagent
                fi
            fi
        fi
    fi
fi

function forget {
    ssh-keygen -R $1
}

# Don't want VI when I submit changes :)
if command -v emacs >/dev/null 2>&1 ; then
    export EDITOR="emacs -nw"
fi
