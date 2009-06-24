class Plan < ActiveRecord::Base
  has_many :subscriptions
  
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_presence_of :name
  
  def to_s
    "#{self.name} - #{number_to_currency(self.amount)} / month"
  end
  
  def to_param
    self.name
  end
end
