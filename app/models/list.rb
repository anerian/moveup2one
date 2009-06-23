class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, :dependent => :destroy
  
  validates_presence_of :title
  validates_presence_of :user_id

  before_save :cleanup
  
  def self.per_page; 10; end
  
  def items_in_average_order
    items.sort_by{|item| -(item.cached_average_rank || 0) }
  end
  
  def items_in_user_order(user)
    items.all(:include => :rankings).sort_by do |item|
      rank = item.rankings.detect{|r| r.user_id == user.id}
      
      rank.blank?? 0 : -rank.ordinal
    end
  end
  
  def ranked_users(options = {})
    options[:page] ||= 1
    options[:per_page] ||= 10
    
    User.paginate(
      :page       => options[:page], 
      :per_page   => options[:per_page],
      :joins      => "INNER JOIN rankings ON rankings.user_id = users.id INNER JOIN items ON rankings.item_id = items.id",
      :group      => "rankings.user_id",
      :conditions => {'items.list_id' => self.id})
  end
  
  def rank!(list_user, item_ids = [])
    List.transaction do
      rankings = list_user.rankings.all(:conditions => {:item_id => item_ids}, :include => [:item])
      
      item_ids.each_with_index do |item_id, i|
        item_id = item_id.to_i
        ranking = rankings.detect{|r| r.item_id == item_id}
        ranking ||= Ranking.new(:user_id => list_user.id, :item_id => item_id)
        ranking.ordinal = (item_ids.length - i);
        ranking.save!
        
        ranking.item.compute_average_rank
        ranking.item.save!
      end
    end
  end
  
  def update_all_counter_caches!
    # counts = {}
    # counts[:prioritized_users_count] = prioritized_users.total_entries
    # updates = counts.collect {|k,v| "#{k} = #{v}"}.join(", ")
    # List.update_all(updates, "id = #{self.id}")
  end
  
  private

    def cleanup
      self.title.strip! unless self.title.blank?
      self.description.strip! unless self.description.blank?
    end
    
end
