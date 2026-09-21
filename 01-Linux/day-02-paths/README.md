# Linux Day 2 - Paths

## Goal

Understand Linux path navigation using absolute paths, relative paths, `.`, `..` and `~`.

## Concepts

- Absolute path
- Relative path
- `.`
- `..`
- `~`

## Notes

- `/home/fatih/...` → absolute path
- `./` → current directory
- `../` → parent directory
- `../../` → two directories up
- `~` → home directory

## Practice

From:

`/home/fatih/path-lab/a/b/c`

copy a file to:

`/home/fatih/path-lab`

using a relative path:

```bash
cp orada.txt ../../../kopya.txt