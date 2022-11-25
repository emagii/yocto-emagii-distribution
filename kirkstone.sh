#!/bin/bash

repo init -u  git@github.com:emagii/yocto-emagii-distribution.git -m kirkstone.xml
repo sync --no-clone-bundle
repo forall -pc 'git checkout --track $REPO_REMOTE/$REPO_RREV'

chmod 775 oe-init-emagii-sdk
source ./oe-init-emagii-sdk
# ln -sf ../build/tmp/work-shared/<machine>/kernel-source components/kernel-source
# rsync -av ../scripts/build-scripts/ poky/build