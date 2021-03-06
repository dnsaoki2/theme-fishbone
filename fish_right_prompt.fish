

function fish_right_prompt -d "Right side prompt message"

    # A dark grey
    set --local dark_grey 555

    set_color $dark_grey

    show_pyenv_name
    show_node_version
    
    show_git_info
    echo -en (date +%H:%M:%S)

    set_color normal
end

function show_pyenv_name -d "pyenv virtualenv"
    set --local GLOBAL_NAME (pyenv global)
    set --local VERSION_NAME (pyenv version-name)
    if [ ! -z $VERSION_NAME ]
        if [ $GLOBAL_NAME != $VERSION_NAME ]
            echo -n "["$VERSION_NAME"] "
        end
    end
end

function show_node_version -d "Show node version"
    set --local GLOBAL_NAME (nodenv global)
    set --local VERSION_NAME (nodenv version-name)
    if [ ! -z $VERSION_NAME ]
        if [ $GLOBAL_NAME != $VERSION_NAME ]
            echo -n "[Node: "$VERSION_NAME"] "
        end
    end
end

function show_git_info -d "Show git repository information"

    set --local LIMBO /dev/null
    set --local git_status (git status --porcelain 2> $LIMBO)
    set --local dirty ""

    [ $status -eq 128 ]; and return  # Not a repository? Nothing to do

    # If there is modifications, set repository dirty to '*'
    if not [ -z (echo "$git_status" | grep -e '^ M') ]
        set dirty "*"
    end

    # If there is new or deleted files, add  '+' to dirty
    if not [ -z (echo "$git_status" | grep -e '^[MDA]') ]
        set dirty "$dirty+"
    end

    # If there is stashed modifications on repository, add '^' to dirty
    if not [ -z (git stash list) ]
        set dirty "$dirty^"
    end

    # Prints git repository status
    echo -en "("
    echo -en (git_branch_name)$dirty
    echo -en ") "
end
