angular.module('diehard_fundApp').factory 'SubscriptionSuccessModal', ->
  templateUrl: 'generated/components/subscription_success_modal/subscription_success_modal.html'
  size: 'subscription-success-modal'
  controller: ($scope, IntercomService, $rootScope) ->
    $scope.openIntercom = ->
      IntercomService.contactUs()
      $scope.$close()

    $scope.dismiss = ->
      $rootScope.$broadcast 'launchIntroCarousel' if DiehardFund.pluginConfig('diehard_fund_onboarding')
      $scope.$close()
