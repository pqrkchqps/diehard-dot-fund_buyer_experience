angular.module('diehard_fundApp').config ($provide) ->
  $provide.decorator '$controller', ($delegate, $location, AppConfig, Session, AbilityService, ChoosePlanModal, SubscriptionSuccessModal, SupportDiehardFundModal) ->
    ->
      ctrl = $delegate arguments...
      if _.get(arguments, '[1].$router.name') == 'groupPage'

        ctrl.addLauncher(=>
          ctrl.group.subscriptionKind = 'paid'
          $location.search 'chargify_success', null
          ctrl.openModal SubscriptionSuccessModal
          true
        , ->
          AbilityService.isLoggedIn() and
          $location.search().chargify_success?
        , priority: 1)

        # ctrl.addLauncher(=>
        #   ctrl.openModal ChoosePlanModal, group: (=> ctrl.group), preventClose: (-> true)
        #   true
        # , =>
        #   membership = ctrl.group.membershipFor(Session.user()) or { experiences: {} }
        #   AbilityService.isLoggedIn() and
        #   AppConfig.pluginConfig('diehard_fund_buyer_experience').config.chargify.appName? and
        #   !ctrl.group.hasSubscription() and
        #   ctrl.group.experiences.bx_choose_plan and
        #   (membership and !membership.experiences.chosen_gift_plan) and
        #   ctrl.group.isParent() and
        #   Session.user().isAdminOf(ctrl.group)
        # , priority: 5)
        #
        # ctrl.addLauncher(=>
        #   ctrl.openModal SupportDiehardFundModal, group: (=> ctrl.group), preventClose: (-> true)
        #   true
        # , =>
        #   membership = ctrl.group.membershipFor(Session.user()) or { experiences: {} }
        #   # user is logged in
        #   AbilityService.isLoggedIn() and
        #   # chargify is present
        #   AppConfig.pluginConfig('diehard_fund_buyer_experience').config.chargify.appName? and
        #   # member is coordinator
        #   membership.admin and
        #   # AND hasn't seen the modal before
        #   !membership.experiences.seen_support_modal and
        #   # AND membership is 5 days old and group is on gift
        #   (ctrl.group.subscriptionKind == 'gift' and membership.createdAt < moment().add(-5, 'day')) or
        #   # OR membership has already selected 'gift' in the choose plan modal
        #   (ctrl.group.subscriptionKind == null and membership.experiences.chosen_gift_plan)
        # , priority: 10)

      ctrl
