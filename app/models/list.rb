class List < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :user
  has_many :items, :dependent => :destroy
  has_many :rankings
  has_many :users, :through => :rankings
  
  validates_presence_of :title

  before_save :cleanup_attributes
  
  def items_ordered_by_user(list_user)
    ranking = list_user.rankings.find_or_initialize_by_list_id(id)
    return items if ranking.blank?
    
    ranking.item_ids.map{|item_id| items.detect{|item| item.id == item_id}}
  end

  def add_item!(item)
    items << item
    save
  end
  
  def rank!(list_user, item_ids = [])
    List.transaction do
      ranking = list_user.rankings.find_or_initialize_by_list_id(id)
      
      # store rankings in json format
      # { :item_1 => :position, :item_2 => :position }
      ranking.ordinals = item_ids.inject({}){|hash, item_id| hash[item_id.to_s] = (item_ids.length - item_ids.index(item_id)).to_s; hash}.to_json
      ranking.save!
      update_averages!
    end
  end
  
  def update_averages!
    sql = <<-EOF
      UPDATE items SET items.mean = (SELECT AVG(JSON_FAST(rankings.ordinals, items.id)) FROM rankings WHERE rankings.list_id = items.list_id), 
                       items.std  = (SELECT STDDEV_SAMP(JSON_FAST(rankings.ordinals, items.id)) FROM rankings WHERE rankings.list_id = items.list_id) 
                 WHERE items.list_id = #{id};
    EOF
    List.connection.update(sql)
  end
  
  def update_all_counter_caches!
    counts = {}
    counts[:rankings_count] = users.count
    updates = counts.collect {|k,v| "#{k} = #{v}"}.join(", ")
    List.update_all(updates, "id = #{self.id}")
  end
  
  protected
  
    def cleanup_attributes
      self.title.strip! unless self.title.blank?
      self.description.strip! unless self.description.blank?
    end
    
end
