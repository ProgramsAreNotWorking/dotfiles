fastfetch
eval "$(oh-my-posh init bash --config ~/.config/oh-my-push/themes/M365Princess.omp.json)"

mkcd() {
  mkdir "$1" && cd "$1"
}

mongo() {
  sudo docker start mongo
}

# open_with() {
#   if [[ "$1" =~ "^/?.+$" ]]; then
#
#   fi
#   if [[ ! -e "$1" ]]; then
#     echo "path does not exist"
#     return 0
#   else
#     find "$1" "$2" "$3"
#   fi
#
# }

. "$HOME/.local/bin/env"
