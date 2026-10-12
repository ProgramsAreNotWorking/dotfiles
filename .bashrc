fastfetch
eval "$(oh-my-posh init bash --config ~/.config/oh-my-push/themes/M365Princess.omp.json)"

mkcd() {
  mkdir "$1" && cd "$1"
}

mongo() {
  sudo docker start mongo
}

. "$HOME/.local/bin/env"
