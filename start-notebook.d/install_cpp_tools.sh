#!/bin/sh
WANT="1.4.1"
code-server --list-extensions --show-versions | grep "ms-vscode.cpptools@$WANT"
if [ $? -eq 0 ]; then
  file ~/.local/share/code-server/extensions/ms-vscode.cpptools-$WANT/bin/cpptools | grep x86-64
  if [ $? -eq 0 ]; then
    echo "already installed"
    exit 0
  fi
fi
echo "Install cpptools $WANT"
code-server --uninstall-extension ms-vscode.cpptools
curl -LO https://github.com/microsoft/vscode-cpptools/releases/download/$WANT/cpptools-linux.vsix
code-server --install-extension cpptools-linux.vsix

