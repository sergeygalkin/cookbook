#!/bin/bash - 

VSCODE_DIR=~/opt/vscode/
VSCODE_TMP_TAR=$(mktemp -u /tmp/vscode-XXXXXXXXX.tar.gz)

set -ueo nounset -o pipefail
wget --show-progress -O $VSCODE_TMP_TAR https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-x64
VSCODE_VERSION=$(${VSCODE_DIR}/VSCode-linux-x64/bin/code --version | head -n1)
echo "Current version is ${VSCODE_VERSION}"
cd $VSCODE_DIR
if [ ! -d VSCode-linux-x64-${VSCODE_VERSION} ]; then
  echo "Create archive for ${VSCODE_VERSION}"
  mv ${VSCODE_DIR}/VSCode-linux-x64 $VSCODE_DIR/VSCode-linux-x64-${VSCODE_VERSION}
  tar cJf VSCode-linux-x64-${VSCODE_VERSION}.tar.xz VSCode-linux-x64-${VSCODE_VERSION}
fi 
rm -rf VSCode-linux-x64
rm -rf VSCode-linux-x64-${VSCODE_VERSION}
echo "Untar $VSCODE_TMP_TAR"
tar xzf $VSCODE_TMP_TAR -C $VSCODE_DIR/
rm -f $VSCODE_TMP_TAR
echo "The archives list is:"
find $VSCODE_DIR -iname '*.tar.xz'
