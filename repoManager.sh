echo "Running repo manager..."
if [ "$1" = "clone" ]
then
  jq -c '.[]' repo.json | while read repo; do
    repoUrlWithQuotes=$(echo $repo | jq '.url')
    repoUrl=$(echo $repoUrlWithQuotes | tr -d '"')
    echo $repoUrl
    git clone $repoUrl
  done
elif [ "$1" = "pull" ]
then
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
  done
fi