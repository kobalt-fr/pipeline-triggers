#! /bin/bash

if [ "$1" != "-f" ]; then
  confirm=n
  read -p "This script overwrites all branches with master. Do you want to continue? [y/N]" -n 1 confirm
  # Print a newline after input
  echo
  if [ "$confirm,*" != "y" ]; then
    echo Aborting.
    exit 1
  fi
fi

for i in $( git for-each-ref --format '%(refname:lstrip=-1)' refs/remotes/origin ); do
  [ "$i" == "master" ] && continue;
  { git checkout "$i" && git reset --hard master; } &> /dev/null \
    || { echo "Failure overwriting $i. Aborting." && exit 1; }
  echo "Branch $i overwritten"
done

git checkout master

echo '***************'
git branch -a -vv
echo '***************'

echo Please check branch status and perform '`'git push --all'`'
