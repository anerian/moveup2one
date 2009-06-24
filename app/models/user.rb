class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :lists
  has_many :rankings
  has_many :ranked_lists, :through => :rankings
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :payments
  
  has_one :subscription, :dependent => :destroy
end
