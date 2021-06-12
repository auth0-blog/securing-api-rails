#!/bin/bash

set -e
set -o nounset
set -o pipefail

goal_run() {
  rails s
}

goal_test() {
  rails spec
}

_dependencies() {
  terraform init
}

goal_plan() {
  (cd terraform &&
     _dependencies &&
     terraform plan
  )
}

goal_apply() {
  (cd terraform &&
     _dependencies &&
     terraform apply
  )
}

goal_destroy() {
  (cd terraform &&
     _dependencies &&
     terraform destroy
  )
}

validate-args() {
  acceptable_args="$(declare -F | sed -n "s/declare -f goal_//p" | tr '\n' ' ')"

  if [[ -z $1 ]]; then
    echo "usage: $0 <goal>"
    # shellcheck disable=SC2059
    printf "\n$(declare -F | sed -n "s/declare -f goal_/ - /p")"
    exit 1
  fi

  if [[ ! " $acceptable_args " =~ .*\ $1\ .* ]]; then
    echo "Invalid argument: $1"
    # shellcheck disable=SC2059
    printf "\n$(declare -F | sed -n "s/declare -f goal_/ - /p")"
    exit 1
  fi
}

CMD=${1:-}
shift || true
if validate-args "${CMD}"; then
  "goal_${CMD}"
  exit 0
fi
