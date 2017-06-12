angular.module('loomioApp').directive 'installSlackNowCard', ($window, AppConfig) ->
  scope: {group: '='}
  templateUrl: 'generated/components/install_slack_now_card/install_slack_now_card.html'
  controller: ($scope) ->
    $scope.installSlack = ->
      $scope.isDisabled = true
      $window.location = AppConfig.baseUrl + 'slack/install'
