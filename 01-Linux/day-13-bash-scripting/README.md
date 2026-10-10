# Linux Day 13 - Bash Scripting

## Goal
Learn Bash conditions, loops and functions.

## Commands

    if [ "$age" -ge 18 ]; then
        echo "Allowed"
    else
        echo "Not allowed"
    fi

    for file in *.log; do
        echo "$file"
    done

    while [ "$count" -le 3 ]; do
        count=$((count + 1))
    done

    check_file() {
        if [ -f "$1" ]; then
            echo "$1 exists"
        fi
    }

## Key Ideas
- `if / elif / else` control script flow.
- `for` processes items in a list.
- `while` runs while a condition is true.
- Functions prevent repeated code.
- `$1` is the first function argument.
- `-f`, `-d` and `-e` test files and paths.

## Practice
Created a system check script that loops through Linux files and checks whether they exist.