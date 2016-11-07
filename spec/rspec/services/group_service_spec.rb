require 'rails_helper'

describe 'GroupService' do
  let(:user) { create(:user) }
  let(:group) { build(:group) }

  describe 'create' do

    it 'creates a new gift subscription for even experiences' do
      group.experiences['bx_choose_plan'] = false
      GroupService.create(group: group, actor: user)
      subscription = group.reload.subscription
      expect(subscription.kind.to_sym).to eq :gift
    end

    it 'creates no subscription for odd experiences' do
      group.experiences['bx_choose_plan'] = true
      GroupService.create(group: group, actor: user)
      expect(group.reload.subscription).to be nil
    end
  end

  describe 'archive!' do
    it 'cancels the subscription' do
      group.add_admin! user
      instance = OpenStruct.new
      allow(SubscriptionService).to receive(:new).and_return(instance)
      expect(instance).to receive :end_subscription!
      GroupService.archive(group: group, actor: user)
    end
  end
end
