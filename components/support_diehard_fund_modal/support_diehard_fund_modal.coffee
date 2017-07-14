angular.module('diehard_fundApp').factory 'SupportDiehard_FundModal', ->
  templateUrl: 'generated/components/support_diehard_fund_modal/support_diehard_fund_modal.html'
  controller: ($scope, $window, $rootScope, group, Session, Records, ModalService, IntercomService, ChoosePlanModal) ->
    $scope.group = group

    $scope.donate = ->
      $window.open '/donate'
      $scope.dismiss()

    $scope.upgrade = ->
      ModalService.open ChoosePlanModal, group: -> $scope.group
      $scope.dismiss(false)

    $scope.openIntercom = ->
      IntercomService.contactUs()
      true

    $scope.dismiss = (useGift = true) ->
      if useGift && !$scope.group.subscriptionKind
        $scope.group.remote.postMember(group.key, 'use_gift_subscription')
      Records.memberships.saveExperience('seen_support_modal', $scope.group.membershipFor(Session.user()))
      $rootScope.$broadcast 'launchIntroCarousel' if Diehard_Fund.pluginConfig('diehard_fund_onboarding')
      $scope.$close()
