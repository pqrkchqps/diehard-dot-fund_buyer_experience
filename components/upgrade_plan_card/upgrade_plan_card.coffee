angular.module('loomioApp').directive 'upgradePlanCard', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/upgrade_plan_card/upgrade_plan_card.html'
  replace: true
  controller: ($scope, $window, ChargifyService, Session, ModalService, ChoosePlanModal) ->

    $scope.show = ->
      Session.user().isMemberOf($scope.group) and
      $scope.group.subscriptionKind == 'gift' and
      ChargifyService.chargify() and
      !Session.subscriptionSuccess

    $scope.showOriginal = parseInt((Math.random()*10))%2 == 0

    $scope.openUpgradeModal = ->
      ModalService.open ChoosePlanModal, group: -> $scope.group
