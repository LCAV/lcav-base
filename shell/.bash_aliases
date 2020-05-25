# PATH ADDITIONS ===============================================================
# Scripts


# BASH AUTOCOMPLETE ENHANCEMENTS ===============================================
bind "set completion-display-width 0"

# COLORFUL MAN PAGES ===========================================================
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking-mode
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold-mode
export LESS_TERMCAP_me=$'\E[0m'           # end (blinking/bold)-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export LESS_TERMCAP_ue=$'\E[0m'           # end underline

# COLORED PS1 PROMPT ===========================================================
Color_Off="\[\033[0m\]"       # Text Reset
BBlack="\[\033[1;30m\]"       # Bold Black
BRed="\[\033[1;31m\]"         # Bold Red
BGreen="\[\033[1;32m\]"       # Bold Green
BYellow="\[\033[1;33m\]"      # Bold Yellow
BBlue="\[\033[1;34m\]"        # Bold Blue
BPurple="\[\033[1;35m\]"      # Bold Purple
BCyan="\[\033[1;36m\]"        # Bold Cyan
BWhite="\[\033[1;37m\]"       # Bold White
shortened_cwd () {
echo "${PWD}" | python3 -c "
import sys;

cwd = sys.stdin.readline()[:-1];     # Remove newline
directory_tree = cwd.split('/')[1:]; # Remove leading '/'

def minimize_directory(directory):
    word_length = 3; # characters to keep per word
    max_words = 2;   # maximum words to keep per directory if name is long
    short_words = [word[:word_length] for word in directory.split()];
    short_words = short_words[:max_words];
    return ''.join(short_words);

minimized_directories = map(minimize_directory, directory_tree);
minimized_cwd = '/' + '/'.join(minimized_directories);

print(minimized_cwd);
"
}
PS1="[\t] ${BPurple}\u${Color_Off}@${BGreen}\h${Color_Off}:${BRed}"'$(eval shortened_cwd)'"${Color_Off}${BBlue}"'\$'"${Color_Off} "

# Unlimited Bash History =======================================================
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=                         # no maximum number of lines in history
export HISTFILESIZE=                     # no file size limit
shopt -s histappend                      # append to history, don't overwrite it
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

# ADD-ON COMMANDS ==============================================================
# Terminal Tools
alias cat='bat --theme=ansi-light'
alias copy='rsync -ahvP'
alias dd='dd bs=32M status=progress'
alias detox='detox -s utf_8 -r'
alias grep='grep --color=auto'
alias l='clear; ls -lhFp --time-style=long-iso --color=auto'
alias nano='nano -c --smarthome --tabstospaces --morespace --smooth --tabsize=4 --wordbounds --autoindent --fill=80'
alias p3='ipython3 --matplotlib'
alias sudo='sudo env "PATH=${PATH}"'

# Default Tools ================================================================
export EDITOR=/usr/bin/nano
