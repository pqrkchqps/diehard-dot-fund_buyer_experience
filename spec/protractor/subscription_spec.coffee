page = require '../../../../angular/test/protractor/helpers/page_helper.coffee'

describe 'Subscription flow', ->
  describe 'setup group on free plan', ->
    it 'displays an upgrade plan card', ->
      page.loadPath('setup_group_on_free_plan')
      page.expectElement('.upgrade-plan-card')

    it 'allows members to modify their plan', ->
      page.loadPath('setup_group_on_free_plan')
      page.click '.group-page-actions__button'
      page.click '.group-page-actions__manage-subscription-link'
      page.expectText '.modal-title', 'Please choose a plan for your group'

  describe 'setup group and select plan', ->
    it 'shows the choose plan modal and the support loomio modal', ->
      page.loadPath('setup_group_and_select_plan')
      page.expectElement('.choose-plan-modal')
      page.click('.choose-plan-modal__table .choose-plan-modal__select-button--gift')
      page.expectElement('.support-loomio-modal')
      page.expectElement('.support-loomio-modal__upgrade-button')
      page.expectElement('.support-loomio-modal__donate-button')
      page.click('.support-loomio-modal__no-thanks')
      page.expectElement('.upgrade-plan-card__confirm-button')

  describe 'showing the support loomio modal to group creators', ->
    it 'shows the support loomio modal to group creators after some time', ->
      page.loadPath('setup_old_group_on_free_plan')
      page.expectElement('.support-loomio-modal')

  describe 'group on paid plan', ->

    it 'hides trial card and offers subscription management', ->
      page.loadPath('setup_group_on_paid_plan')

      page.expectNoElement('.trial-card')
      page.click('.group-page-actions__button')
      page.expectElement('.group-page-actions__manage-subscription-link')

  describe 'group after subscription success', ->
    it 'shows the subscription success modal', ->
      page.loadPath('setup_group_after_chargify_success')
      page.expectElement '.subscription-success-modal', 'You\'re all set!'
