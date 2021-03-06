# git-shell

A nice git interface compatible with POSIX using POSIX-compatible `sh` and a batch file for Windows users.

## Installing

From the [website](https://xernphoton.github.io/download.html).

### Linux

This will soon be available through your package manager of choice. For now, download it from the website and add it to your path.

### MacOS

This will soon be available through Homebrew. For now, download it from the website and add it to your path.

### Windows

~~This will soon be available through its website. For now, download it from the website and add the `.bat` to your path.~~ Not available yet!

## Features

* Run `git` commands through an interactive prompt
* Can clone and push directly to GitHub
* More to come in the future...

## Known Bugs & Fixes

* Running `git.sh` says you don't have git installed when you do
  * Remove lines 3-7 in `git.sh`

## License

[MIT License](https://github.com/xernphoton/git-shell/blob/main/LICENSE)

## To-do

- [ ] Register `git.sh` at PorkBun with DigitalOcean hosting
- [ ] Add `.bat` support
- [ ] Refactor code with functions
- [ ] Add flags
- [ ] Deploy to package managers
- [ ] Add lesser-used git commands
- [ ] Add custom commands
- [ ] Add setup script
- [ ] Add support for a config script
