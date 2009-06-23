class Ranking < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  after_save :update_cached_average
  
  def update_cached_average
    item.compute_average_rank
  end
  
  def after_create
    item.list.update_all_counter_caches!
  end
end
