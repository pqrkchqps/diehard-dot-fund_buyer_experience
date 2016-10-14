angular.module('loomioApp').factory 'SubscriptionSuccessModal', ->
  templateUrl: 'generated/components/subscription_success_modal/subscription_success_modal.html'
  size: 'subscription-success-modal'
  controller: ($scope, IntercomService) ->
    $scope.openIntercom = ->
      IntercomService.contactUs()
      $scope.$close()
