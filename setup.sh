#!/bin/bash
cd $(dirname $0)
for dotfile in .?*; do
  case $dotfile in
    ..)
      continue;;
    .git)
      continue;;
    vim-setup.bat)
      continue;;
    *)
      ln -Fis "$PWD/$dotfile" $HOME
      ;;
  esac
done
