class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  has_many :payments
  
  attr_accessor :creditcard, :address
  attr_reader :response
  
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_numericality_of :amount, :greater_than_or_equal_to => 0

end
