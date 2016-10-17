page = require '../../../../angular/test/protractor/helpers/page_helper.coffee'

describe 'Subscription flow', ->
  describe 'setup group on free plan', ->
    it 'displays an upgrade plan card', ->
      page.loadPath('setup_group_on_free_plan')
      page.expectElement('.upgrade-plan-card')

  describe 'setup group and select plan', ->
    it 'displays the choose plan modal', ->
      page.loadPath('setup_group_and_select_plan')
      page.expectElement('.choose-plan-modal')

  describe 'group on paid plan', ->

    it 'hides trial card and offers subscription management', ->
      page.loadPath('setup_group_on_paid_plan')

      page.expectNoElement('.trial-card')
      page.click('.group-page-actions__button')
      page.expectElement('.group-page-actions__manage-subscription-link')
