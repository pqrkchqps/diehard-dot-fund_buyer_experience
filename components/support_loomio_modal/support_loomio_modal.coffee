angular.module('loomioApp').factory 'SupportLoomioModal', ->
  templateUrl: 'generated/components/support_loomio_modal/support_loomio_modal.html'
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
      $rootScope.$broadcast 'launchIntroCarousel' if Loomio.pluginConfig('loomio_onboarding')
      $scope.$close()
