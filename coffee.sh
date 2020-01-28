#!/bin/sh -x

# Declare colors
ERROR='\033[0;31m'
NC='\033[0m' # No Color
SUCCESS='\033[032m'
WARNING='\033[033m'

declare -a repos=($(ls -d */))
cwd=$(pwd)
commands=("stash" "pull --rebase")

run_git() {
  printf "[${i}] ${1}\r"
  OUTPUT=$(timeout 10s git ${1})
  is_success=$?
  if [ $is_success -lt 1 ]; then
    printf "${SUCCESS}git ${command} in ${i} - Successful${NC}\n"
  else
    printf "${ERROR}git ${command} in ${i} - FAILED${NC}\n"
  fi;
  printf "${OUTPUT}\n\n"
}

for command in "${commands[@]}"
do
  printf "\n--- Running \"git ${command}\" for all repos ---\n\n"
  for i in "${repos[@]}"
  do
    if [ -d "$cwd/$i" ]; then
      cd $cwd"/"$i
      if [ -d .git ]; then
        run_git $command
      else
        printf "${WARNING}[Ignored] \"git ${command}\". Not a git repo \"${i}\"${NC}\n\n"
      fi;
    else
      printf "${WARNING}[Ignored] ${i} is not a directory${NC}\n\n"
    fi
  done
done
