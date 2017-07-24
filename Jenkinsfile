#!/usr/bin/env groovy

// See https://github.com/capralifecycle/jenkins-pipeline-library
@Library('cals') _

properties([
  pipelineTriggers([
    // Build a new version every night so we keep up to date with upstream changes
    cron('H H(2-6) * * *'),

    // Build when pushing to repo
    githubPush(),
  ]),

  // "GitHub project"
  [
    $class: 'GithubProjectProperty',
    displayName: '',
    projectUrlStr: 'https://github.com/capralifecycle/capra-tv/'
  ],
])

dockerNode {
  stage('Checkout source') {
    checkout scm
  }

  def img

  stage('Build Docker image') {
    img = docker.build('capra-tv', '--pull .')
  }

  if (env.BRANCH_NAME == 'master') {
    def tagName = sh([
      returnStdout: true,
      script: 'date +%Y%m%d-%H%M'
    ]).trim() + '-' + env.BUILD_NUMBER

    stage('Push Docker image') {
      img.push(tagName)
      img.push('latest')
    }

    stage('Deploy to ECS') {
      def image = "923402097046.dkr.ecr.eu-central-1.amazonaws.com/capra-tv:$tagName"
      ecsDeploy("--aws-instance-profile -r eu-central-1 -c buildtools-stable -n capra-tv -i $image")
    }
  }
}
