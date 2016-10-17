module Plugins
  module LoomioBuyerExperience
    class Plugin < Plugins::Base

      setup! :loomio_buyer_experience do |plugin|
        plugin.enabled = true

        plugin.use_asset 'components/services/chargify_service.coffee'
        plugin.use_component :choose_plan_modal
        plugin.use_component :confirm_gift_plan_modal
        plugin.use_component :subscription_success_modal
        plugin.use_component :upgrade_plan_card, outlet: :before_group_page_column_right

        plugin.use_class_directory 'app/models'
        plugin.use_class_directory 'app/admin'
        plugin.use_class_directory 'app/controllers'
        plugin.use_class_directory 'app/helpers'
        plugin.use_class_directory 'app/services'

        plugin.use_route :post, 'groups/:id/use_gift_subscription', 'groups#use_gift_subscription'
        plugin.extend_class API::GroupsController do
          def use_gift_subscription
            if SubscriptionService.available?
              SubscriptionService.new(resource, current_user).start_gift!
              respond_with_resource
            else
              respond_with_standard_error ActionController::BadRequest, 400
            end
          end
        end

        plugin.use_events do |event_bus|
          event_bus.listen('group_create')  { |group| SubscriptionService.new(group).initial_subscription! }
          event_bus.listen('group_archive') { |group| SubscriptionService.new(group).end_subscription! }
        end

        plugin.use_database_table :subscriptions do |t|
          t.string  :kind
          t.date    :expires_at
          t.date    :trial_ended_at
          t.date    :activated_at
          t.integer :chargify_subscription_id
          t.string  :plan
          t.string  :payment_method, default: :chargify, null: false
        end
      end

    end
  end
end
