workflow "build-deploy" {
  on = "push"
  resolves = "deploy"
}

action "install" {
  uses = "docker://node:11.6.0"
  args = "yarn"
}

action "prepare" {
  uses = "docker://node:11.6.0"
  args = "yarn add-lock-file"
  needs = ["install"]
}

action "test-app-1" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-1 test"
  needs = ["prepare"]
}

action "test-app-2" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-2 test"
  needs = ["prepare"]
}

action "build-app-1" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-1 build"
  needs = ["test-app-1"]
}

action "build-app-2" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-2 build"
  needs = ["test-app-2"]
}

action "build-base-image" {
  needs = ["build-app-1","build-app-2"]
  uses = "actions/docker/cli@master"
  args = ["build", "-t mono-actions-test-node:11", "./base-images/node11/"]
}

action "docker-build-app-1" {
  needs = ["build-base-image"]
  uses = "actions/docker/cli@master"
  args = ["build", "-t mono-actions-test-app-1:$GITHUB_SHA", "app-1"]
}

action "docker-build-app-2" {
  needs = ["build-base-image"]
  uses = "actions/docker/cli@master"
  args = ["build", "-t mono-actions-test-app-2:$GITHUB_SHA", "app-2"]
}

action "branch-filter" {
  needs = ["docker-build-app-1", "docker-build-app-2"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "deploy" {
  needs = ["branch-filter"]
  uses = "actions/bin/sh@master"
  args = ["env"]
  secrets = ["PHONY_SECRET"]
  env = {
    PHONY_ENV = "foobar"
  }
}
