# Copied from https://fishshell.com/docs/current/cmds/function.html#cmd-function

function cdc -d "Create a directory and set CWD"
    command mkdir $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

