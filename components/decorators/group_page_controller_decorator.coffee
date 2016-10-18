angular.module('loomioApp').config ($provide) ->
  $provide.decorator '$controller', ($delegate, $location, AppConfig, Session, AbilityService, ChoosePlanModal, SubscriptionSuccessModal) ->
    ->
      ctrl = $delegate arguments...
      if _.get(arguments, '[1].$router.name') == 'groupPage'

        ctrl.handleSubscriptionSuccess = ->
          return unless $location.search().chargify_success?
          Session.subscriptionSuccess = true
          @group.subscriptionKind = 'paid' # incase the webhook is slow
          $location.search 'chargify_success', null
          @openModal SubscriptionSuccessModal
          true

        ctrl.handleChoosePlanModal = ->
          return unless AppConfig.pluginConfig('loomio_buyer_experience').config.chargify.appName? and
            !@group.hasSubscription() and
            @group.experiences.bx_choose_plan and
            @group.isParent() and
            Session.user().isAdminOf(@group)
          @openModal ChoosePlanModal, group: (=> @group), preventClose: (-> true)
          true

        oldHandleWelcomeModal = ctrl.handleWelcomeModal
        ctrl.handleWelcomeModal = (group) ->
          ctrl.handleSubscriptionSuccess() or ctrl.handleChoosePlanModal() or oldHandleWelcomeModal()

      ctrl
