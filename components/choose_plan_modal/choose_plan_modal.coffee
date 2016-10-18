angular.module('loomioApp').factory 'ChoosePlanModal', ->
  templateUrl: 'generated/components/choose_plan_modal/choose_plan_modal.html'
  size: 'choose-plan-modal'
  controller: ($scope, group, ModalService, ConfirmGiftPlanModal, ChargifyService, $window, IntercomService) ->
    $scope.group = group

    $scope.chooseGiftPlan = ->
      ModalService.open ConfirmGiftPlanModal, group: -> $scope.group

    $scope.choosePaidPlan = (kind) ->
      $window.open ChargifyService.chargifyUrlFor($scope.group, kind)
      true

    $scope.openIntercom = ->
      IntercomService.contactUs()
      true
