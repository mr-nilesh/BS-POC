echo "Running repo manager..."
# If cloning
if [ "$1" = "clone" ]
then
  # Loop through all the repos and clone it in root folder
  jq -c '.[]' repo.json | while read repo; do
    nameWithQuotes=$(echo $repo | jq '.name')
    name=$(echo $nameWithQuotes | tr -d '"')
    if [ -d "$PWD/$name" ]
    then
      continue
    fi
    repoUrlWithQuotes=$(echo $repo | jq '.url')
    repoUrl=$(echo $repoUrlWithQuotes | tr -d '"')
    echo $repoUrl
    git clone $repoUrl
  done
# Else if cone only shared repo
elif [ "$1" = "pullSharedOnly" ]
then
  # Loop through all the repos and only clone shared one
  jq -c '.[]' repo.json | while read repo; do
    isShared=$(echo $repo | jq '.isShared')
    nameWithQuotes=$(echo $repo | jq '.name')
    name=$(echo $nameWithQuotes | tr -d '"')
    if [ "$isShared" = true ]
    then
      repoUrlWithQuotes=$(echo $repo | jq '.url')
      repoUrl=$(echo $repoUrlWithQuotes | tr -d '"')
      echo $repoUrl
      git clone $repoUrl
    fi
  done
# Else if pulling latest from specific branch
elif [ "$1" = "pull" ]
then
  # Loop through all the repos and pull lastest from specific branch
  jq -c '.[]' repo.json | while read repo; do
    nameWithQuotes=$(echo $repo | jq '.name')
    name=$(echo $nameWithQuotes | tr -d '"')
    echo "Moving to directory $name to pull latest"
    cd "$PWD/$name"
    defaultBranchWithQuotes=$(echo $repo | jq '.defaultBranch')
    defaultBranch=$(echo $defaultBranchWithQuotes | tr -d '"')
    echo "Default branch to pull from $defaultBranch"
    git checkout $defaultBranch
    git pull origin $defaultBranch
    cd ..
  done
fi