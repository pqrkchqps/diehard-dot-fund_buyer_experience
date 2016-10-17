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
end
