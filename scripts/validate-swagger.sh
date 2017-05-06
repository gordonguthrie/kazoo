#!/bin/bash

# Validate Swagger file using online validator

branch=${1:-$CIRCLE_BRANCH}
[[ "$branch" == '' ]] && branch=master
echo "Checking Swagger file in branch $branch"

URL='http://online.swagger.io/validator/debug?url=https://raw.githubusercontent.com/2600hz/kazoo/'$branch'/applications/crossbar/priv/api/swagger.json'

tmp=$RANDOM.json
curl -o $tmp "$URL" || exit 2
"$(dirname "$0")"/format-json.sh $tmp || (rm $tmp && exit 3)
errors=$(cat $tmp | python2 -c 'import sys, json; print len(json.load(sys.stdin)["schemaValidationMessages"])')
[[ $errors -ne 0 ]] && echo Swagger file validation errors: $errors && cat $tmp
rm $tmp

exit $errors
