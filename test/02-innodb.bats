#!/usr/bin/env bats

load test_helper

# InnoDB is slow to initialize; penalize this with a 5 second wait
@test "start a default server with InnoDB and no password" {
  local name="default-startup"
  create ${name} ""
  sleep 5
  run client_query "${name}" "-e 'SHOW ENGINE INNODB STATUS;'"
  [[ "$status" -eq 0 ]]
  decommission "${name}"
}

@test "start a server without a dedicated volume (issue #1)" {
  local name="innodb-issue-1"
  docker run -d --rm --name "${TEST_PREFIX}-${name}" "${IMAGE}":"${VERSION}"
  sleep 5
  run client_query "${name}" "-e 'select 1;'"
  [[ "$status" -eq 0 ]]
  decommission "${name}"
}
