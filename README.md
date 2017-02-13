Simple indent guides for your code. Space indents are visually identified by the "┆" character, while tabs are distinguished by "|".
Manually calling the command `ToggleIndentGuides` will toggle indent guides scoped to a specific buffer.

If there are any files you would like to not add indent guides for, add the filetype to the ignore list:
```
let g:workspace_indentguides_ignore = ['text']
```

# Installation
### Using Plug
Paste the following in your `~/.vimrc` file:
```
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'thaerkh/vim-indentguides'
call plug#end()
```
If you don't already have Plug, this will auto-download Plug for you and install the workspace plugin.

If you already have Plug, simply paste `Plug 'thaerkh/vim-workspace'` and call `:PlugInstall` to install the plugin.

Remember to `:PlugUpdate` often to get all the latest features and bug fixes!
### Using Vundle
Paste this in your `~./vimrc`:
```
Plugin 'thaerkh/vim-indentguides'
```
### Using Pathogen
cd into your bundle path and clone the repo:
```
cd ~/.vim/bundle
git clone https://github.com/thaerkh/vim-indentguides
```

# License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)