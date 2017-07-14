angular.module('diehard_fundApp').factory 'ChoosePlanModal', ->
  templateUrl: 'generated/components/choose_plan_modal/choose_plan_modal.html'
  size: 'choose-plan-modal'
  controller: ($scope, $window, group, Records, Session, ModalService, SupportDiehardFundModal, ChargifyService, IntercomService) ->
    $scope.group = group

    $scope.chooseGiftPlan = ->
      Records.memberships.saveExperience('chosen_gift_plan', $scope.group.membershipFor(Session.user()))
      ModalService.open SupportDiehardFundModal, group: (-> $scope.group), preventClose: (-> true)

    $scope.choosePaidPlan = (kind) ->
      $window.open ChargifyService.chargifyUrlFor($scope.group, kind)
      true

    $scope.openIntercom = ->
      IntercomService.contactUs()
      true
