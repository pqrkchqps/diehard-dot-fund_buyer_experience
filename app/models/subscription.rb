class Subscription < ActiveRecord::Base
  has_one :group
  validates :kind, presence: true
  validates :group, presence: true


  # trial is what groups start off with. It gives them 30 days to evaluate loomio
  # gift means that groups will see "gift mode" stuff asking for donations
  # paid means they have paid us for a subscription.. either online or manually
  validates_inclusion_of :kind, in: ['trial', 'gift', 'paid']

  validates_inclusion_of :payment_method, in: ['chargify', 'manual', 'paypal']

  # plan is a text field to detail the subscription type further
  # plan could be manual
  #
  # current it indicates standard or plus plan

  delegate :id, to: :group, prefix: true, allow_nil: true

  def group_id=(id)
    self.group = Group.find(id)
  end

  def is_paid?
    self.kind.to_s == 'paid'
  end
end
