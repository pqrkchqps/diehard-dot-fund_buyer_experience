angular.module('loomioApp').config ($provide) ->
  $provide.decorator '$controller', ($delegate, $location, AppConfig, Session, AbilityService, ChoosePlanModal, SubscriptionSuccessModal, SupportLoomioModal) ->
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
          membership = @group.membershipFor(Session.user()) or { experiences: {} }
          return unless AppConfig.pluginConfig('loomio_buyer_experience').config.chargify.appName? and
            !@group.hasSubscription() and
            @group.experiences.bx_choose_plan and
            (membership and !membership.experiences.chosen_gift_plan) and
            @group.isParent() and
            Session.user().isAdminOf(@group)
          @openModal ChoosePlanModal, group: (=> @group), preventClose: (-> true)
          true

        ctrl.handleSupportLoomioModal = ->
          membership = @group.membershipFor(Session.user()) or { experiences: {} }
          return unless AppConfig.pluginConfig('loomio_buyer_experience').config.chargify.appName? and
            # AND hasn't seen the modal before
            !membership.experiences.seen_support_modal and
            # AND membership is 5 days old and group is on gift
            (@group.subscriptionKind == 'gift' and membership.createdAt < moment().add(-5, 'day')) or
            # OR membership has already selected 'gift' in the choose plan modal
            (@group.subscriptionKind == null and membership.experiences.chosen_gift_plan)
          @openModal SupportLoomioModal, group: (=> @group), preventClose: (-> true)
          true

        oldHandleWelcomeModal = ctrl.handleWelcomeModal
        ctrl.handleWelcomeModal = (group) ->
          ctrl.handleSubscriptionSuccess() or
          ctrl.handleChoosePlanModal() or
          ctrl.handleSupportLoomioModal() or
          oldHandleWelcomeModal()

      ctrl
