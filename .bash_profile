
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

export EDITOR='vim'
export CLICOLOR=1

# Setting PATH for Python 3.12
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:/usr/local/bin:${PATH}"
export PATH