#!/usr/bin/env bash
# Add or remove extensions from the list below to customise your team's VS Code setup.
set -euo pipefail

extensions=(
  aaron-bond.better-comments
  adpyke.codesnap
  alefragnani.bookmarks
  alefragnani.project-manager
  amodio.restore-editors
  anthropic.claude-code
  beardedbear.beardedtheme
  bierner.color-info
  chouzz.vscode-better-align
  christian-kohler.path-intellisense
  chrmarti.regex
  compilenix.vscode-zonefile
  cweijan.vscode-office
  dbaeumer.vscode-eslint
  deerawan.vscode-faker
  devsense.composer-php-vscode
  devsense.intelli-php-vscode
  devsense.phptools-vscode
  devsense.profiler-php-vscode
  donjayamanne.githistory
  dotjoshjohnson.xml
  ecmel.vscode-html-css
  editorconfig.editorconfig
  emilast.logfilehighlighter
  esbenp.prettier-vscode
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  github.copilot-chat
  gruntfuggly.todo-tree
  hookyqr.minify
  ibm.output-colorizer
  in4margaret.compareit
  ionutvmi.path-autocomplete
  irongeek.vscode-env
  j-clavoie.html-code-cleaner-tools
  jeff-hykin.polacode-2019
  kevinkyang.auto-comment-blocks
  kirozen.wordcounter
  mechatroner.rainbow-csv
  mgmcdermott.vscode-language-babel
  mohd-akram.vscode-html-format
  ms-python.debugpy
  ms-python.python
  ms-python.vscode-pylance
  ms-python.vscode-python-envs
  ms-vscode.vscode-speech
  naumovs.color-highlight
  oderwat.indent-rainbow
  otovo-oss.htmx-tags
  pkief.material-icon-theme
  pnp.polacode
  pomdtr.excalidraw-editor
  pranaygp.vscode-css-peek
  ritwickdey.liveserver
  searking.preview-vscode
  shardulm94.trailing-spaces
  shd101wyy.markdown-preview-enhanced
  sidthesloth.html5-boilerplate
  sirtori.indenticator
  sleistner.vscode-fileutils
  spywhere.guides
  streetsidesoftware.code-spell-checker
  stylelint.vscode-stylelint
  techer.open-in-browser
  tomoki1207.pdf
  tyriar.sort-lines
  vincaslt.highlight-matching-tag
  wayou.vscode-todo-highlight
  wesbos.theme-cobalt2
  wmaurer.change-case
  xabikos.javascriptsnippets
  xdebug.php-pack
  yzhang.markdown-all-in-one
  zignd.html-css-class-completion
  zobo.php-intellisense
)

for ext in "${extensions[@]}"; do
  echo "Installing $ext..."
  code --install-extension "$ext" --force
done

echo "Done. ${#extensions[@]} extensions installed."
