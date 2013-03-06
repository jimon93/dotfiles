#!/bin/bash
cd $(dirname $0)
for dotfile in .?*; do
  case $dotfile in
    ..)
      continue;;
    .git)
      continue;;
    src)
      continue;;
    vim-setup.bat)
      continue;;
    *)
      ln -Fisv "$PWD/$dotfile" $HOME
      ;;
  esac
done
