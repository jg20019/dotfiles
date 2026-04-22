if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr --add g git
    abbr --add gco git checkout
    abbr --add d docker
    abbr --add dc docker compose

    set -Ux EDITOR nvim
    fish_add_path /home/jgibson/bin/
    fish_add_path /home/jgibson/bin/perlego/
    fish_add_path /home/jgibson/.qlot/bin
    fish_add_path /home/linuxbrew/.linuxbrew/bin/
    fish_add_path /usr/local/bin/intellij/bin
    fish_add_path /usr/local/go/bin
    # Change JAVA home based on the project
    set -gx JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
    #set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
    set -gx GUILE_LOAD_PATH /home/linuxbrew/.linuxbrew/share/guile/site/3.0
    set -gx GUILE_LOAD_COMPILED_PATH /home/linuxbrew/.linuxbrew/lib/guile/3.0/site-ccache
    set -gx GUILE_SYSTEM_EXTENSIONS_PATH /home/linuxbrew/.linuxbrew/lib/guile/3.0/extensions
    source "$HOME/.cargo/env.fish"
    mise activate fish | source
    starship init fish | source
    zoxide init fish | source
    set -U fish_greeting

    # Set nvim as man pager
    set -gx MANPAGER "nvim +Man!"
end
