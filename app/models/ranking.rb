class Ranking < ActiveRecord::Base
  belongs_to :user
  belongs_to :ranked_list, :class_name => "List", :foreign_key => "list_id"
  
  after_save :update_averages
  
  def item_ids
    return [] if ordinals.blank?
    json = JSON.parse(ordinals)
    json.sort_by(&:second).reverse.map{|a|a.first.to_i}
  end
end
