function cdc -d "Create a directory and set CWD"
    if test (count $argv) -ne 1
        echo "Usage: cdc DIR"
        return 1
    end

    if test -d $argv
        echo "Directory already exists. Entering..."
        cd $argv
        return
    end

    command mkdir $argv

    if test $status -ne 0
        return 1
    end

    cd $argv
end
