#!/bin/sh

##########################################################################
#
# This script deletes all local AND remote branches that 1) are neither
# `develop` nor `master`, 2) are not the currently active branch, and
# 3) do not contain the word `backup`.
#
# TODO: Add support for only deleting already merged remote branches
#
##########################################################################

EXCLUDED_BRANCHES="master|develop|backup|$(git rev-parse --abbrev-ref HEAD)"
echo "DELETING LOCAL BRANCHES..."
git branch | egrep -v $EXCLUDED_BRANCHES | xargs git branch -D 
echo "DELETING REMOTE BRANCHES..."
git branch -r | grep origin | sed 's/origin\///g' | egrep -v $EXCLUDED_BRANCHES | xargs -I {} sh -c 'git push origin :{}'
