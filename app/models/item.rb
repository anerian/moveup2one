class Item < ActiveRecord::Base
  belongs_to :list
  belongs_to :user
  
  validates_presence_of :list_id
  validates_presence_of :user_id
end
