#!/bin/fish

set dotfiles ~/dotfiles

set home_paths                    \
    .psqlrc                       \
    .less                         \
    .zshrc                        \
    .tmux.conf                    \
    .gitconfig                    \
    .rndebuggerrc                 \

set config_paths                  \
    nvim                          \
    kitty                         \
    pgcli                         \
    starship.toml                 \
    fish/config.fish              \
    zk                            \
    alacritty                     \
    fontconfig/fonts.conf         \
    wezterm/wezterm.lua           \
    helix                         \
    picom                         \
    bspwm                         \
    sxhkd                         \
    rofi                          \
    polybar                       \
    nushell                       \
    zathura                       \
    i3                            \
    zellij                        \
    dunst                         \
    watson                        \

function copy -a target_dir -a paths
  for path in $$paths
    set fullpath $target_dir/$path
    set item (basename $fullpath)

    if test -e $dotfiles/$item
      rm -rf $fullpath
    end

    if test ! -e $fullpath
      mkdir -p (dirname $fullpath)
      ln -s $dotfiles/$item $fullpath
    end
  end
end

copy ~ home_paths
copy ~/.config config_paths
