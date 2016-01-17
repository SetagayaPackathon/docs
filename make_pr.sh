#! /usr/bin/env bash

ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_RESET="\033[0m"
ANSI_CLEAR="\033[0K"

EXIT_SUCCSS=0
EXIT_SOURCE_NOT_FOUND=1
EXIT_SOURCE_HAS_SETUID=2
EXIT_NOTHING_TO_COMMIT=3

BRANCH=travis

create_pr=0
has_setuid=0

TARGET_FILE=quiz.js

function notice() {
	msg=$1
	echo -e "\n${ANSI_GREEN}${msg}${ANSI_RESET}\n"
}

function warn() {
	msg=$1
	echo -e "\n${ANSI_RED}${msg}${ANSI_RESET}\n"
}

notice "Setting up Git"

if [ -z "`git config --get --global credential.helper`" ]; then
	notice "set up credential.helper"
	git config credential.helper "store --file=.git/credentials"
	echo "https://${GITHUB_OAUTH_TOKEN}:@github.com" > .git/credentials 2>/dev/null
fi
if [ -z "`git config --get --global user.email`" ]; then
	notice "set up user.email"
	git config --global user.email "yandod@gmail.com"
fi
if [ -z "`git config --get --global user.name`" ]; then
	notice "set up user.name"
	git config --global user.name "Packathon build bot"
fi

notice "Creating commit"
#git checkout $DEFAULT_BRANCH
git checkout -b $BRANCH

git add ${TARGET_FILE}
git commit -m "convert to csv by bots. [ci skip]"

COMMIT_EXIT_STATUS=$?
if [ $COMMIT_EXIT_STATUS -gt 0 ]; then
	notice "Nothing to commit"
	exit $EXIT_NOTHING_TO_COMMIT
fi

notice "Pushing commit"

if [ -z $GITHUB_OAUTH_TOKEN ]; then
	warn '$GITHUB_OAUTH_TOKEN not set'
	exit 1
fi
git push origin $BRANCH
