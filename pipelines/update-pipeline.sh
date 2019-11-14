#!/usr/bin/env bash

me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pipeline=${1:-}
pipelines_dir="${me}/."

if [[ -z "${pipeline}" ]]; then
    echo "Usage:"
    echo "  ./pipelines/update-pipeline <pipeline-name>"
    echo
    echo "  where pipeline-name is in:"
    (cd ${pipelines_dir}; find . -iname '*.yml' | xargs -L 1 echo "    $1")
    exit 1
fi

fly -t wallhouse \
  set-pipeline \
  --load-vars-from ${pipelines_dir}/../../secrets/pipeline-creds.yml \
  --pipeline $(basename ${pipeline%.yml}) \
  --config "${pipelines_dir}/${pipeline}"

if [[ $? -ne 0 ]]; then
    echo
    echo "Fly failed, are you logged in? Try:"
    echo
    echo "  fly -t wallhouse login -k"
fi