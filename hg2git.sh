#!/bin/bash
set -e

if [ ! -d "fast-export" ]; then
  echo "Installing fast-export..."
  git clone https://github.com/frej/fast-export.git
fi

read -p 'Mercurial repo: ' HG_SOURCE
BASENAME=$(basename $HG_SOURCE)

# Clone old repo
hg clone $HG_SOURCE ${BASENAME}_hg

# Create new git repo
git init ${BASENAME}_git
cd ${BASENAME}_git
git config core.ignoreCase false
../fast-export/hg-fast-export.sh -r ../${BASENAME}_hg
git checkout HEAD

read -p 'Git export url: ' GIT_URL

# Set remote
git remote add origin $GIT_URL
git push -u origin master

cd ..
rm -R ${BASENAME}_git ${BASENAME}_hg
