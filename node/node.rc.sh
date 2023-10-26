export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# Will call "nvm use" in a directory with a .nvmrc file automatically on chdir action
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc


# Install npm package
npmi(){
  local out packages key

  IFS=$'\n'
  out=("$(all-the-package-names | fzf -m --expect=ctrl-h --preview "npm view --json {} name description repository.url homepage dist-tags version engines | bat -pp --color always -l JSON --theme TwoDark" --preview-window="right:wrap")")
  key=$(head -1 <<< "$out")
  packages=($(tail -n +2 <<< "$out"))

  if [[ -n "$packages" ]]; then
    # Open package repo on GH when Ctrl-H is pressed
    if [ "$key" = ctrl-h ]; then
      for i in "${packages[@]}"
      do
        npm repo "$i"
      done
    # Otherwise install packages
  else
      echo "Installing packages: ${packages[@]}"
      npm i $@ "${packages[@]}";
    fi
  fi
}

# List npm packages (global and local) and open the selected one on Github
# $ npmls
# $ npmls -g
npmls() {
  local packages;

  # Do not print tree-view, strip current directory at first line, strip dirname, pipe to tmux
  IFS=$'\n' packages=($(npm ls $* --depth 0 --parseable --long | sed -n '2,$p' | sed 's@.*/@@' | sed 's@.*:@@' | fzf-tmux -m --preview "npm view --json {} name description repository.url homepage dist-tags version engines | bat -pp --color always -l JSON --theme TwoDark" --preview-window="right:wrap"))

  if [[ -n "$packages" ]]; then
    echo "Opening package's repository: ${packages[@]}";
    for i in "${packages[@]}"
    do
      # Strip version component
      # npm rm mocha@0.6.9 => npm rm mocha
      npm repo "${i%%@*}"
    done
  fi
}

# Remove npm packages (global and local)
# $ npmrm
# $ npmrm -g
npmrm(){
  local packages;
  IFS=$'\n' packages=($(npm ls $* --depth 0 --parseable --long | sed -n '2,$p' | sed 's@.*/@@' | sed 's@.*:@@' | fzf-tmux -m --preview "npm view --json {} name description repository.url homepage dist-tags version engines | bat -pp --color always -l JSON --theme TwoDark" --preview-window="right:wrap"))
  if [[ -n "$packages" ]]; then
    echo "Removing: ${packages[@]}";
    for i in "${packages[@]}"
    do
      # Strip version component
      # npm rm mocha@0.6.9 => npm rm mocha
      npm rm $* "${i%%@*}"
    done
  fi
}
