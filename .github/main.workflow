workflow "deploy" {
  on = "push"
  resolves = "deploy"
}

action "install" {
  uses = "docker://node:11.6.0"
  args = "yarn"
}

action "build-app-1" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-1 build"
  needs = ["install"]
}

action "build-app-2" {
  uses = "docker://node:11.6.0"
  args = "yarn workspace app-2 build"
  needs = ["install"]
}

action "branch-filter" {
  needs = ["build-app-1","build-app-2"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "deploy" {
  needs = ["branch-filter"]
  uses = "actions/bin/sh@master"
  args = ["env"]
  secrets = ["PHONY_SECRET"]
  env = {
    PHONY_ENV = "foo"
  }
}