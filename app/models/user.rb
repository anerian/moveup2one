class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :lists
  has_many :rankings
  has_many :ranked_lists, :through => :rankings
end
