function sha256sumf -d "Generates and displays a file's SHA256 hash, saving it with a .sha256 extension."
    set -l help_string "Usage: $(status function) <file>"
    if test (count $argv) -ne 1
        echo $help_string
        return 1
    end

    if string match -q -- $argv[1] "-h" "--help"
        echo $help_string
        return 0
    end

    if not test -f $argv[1]
        echo "File not found: $argv[1]"
        return 1
    end
    
    sha256sum "$argv[1]" | tee "$argv[1].sha256"
end
