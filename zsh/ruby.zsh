if [ -d $HOME/gems ]; then
    export GEM_HOME=$HOME/gems
    export PATH=$HOME/gems/bin:$PATH
fi

if [ -d $HOME/.rbenv/bin ]; then
    export PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
fi
