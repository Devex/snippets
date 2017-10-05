## to be executed after a deploy, will post a comment on the deployed PR...

GH_TOKEN="ABC123"
PR_NO=`git log -n1 --pretty=format:'%s' | grep -Po '(?<=request #)[0-9]+'`
REPO="Devex/grape-api"
ENV="develop"

if [ -n "$PR_NO" ]; then
  curl -H "Authorization: token ${GH_TOKEN}" -XPOST "https://api.github.com/repos/${REPO}/issues/${PR_NO}/comments" --data "{\"body\": \"Changes were deployed on ${ENV}.\"}"
else
  echo "could not figure out to PR number..."
fi
