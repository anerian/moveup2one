class Item < ActiveRecord::Base
  belongs_to :list, :counter_cache => true
  has_many :rankings
  has_many :users, :through => :rankings

  before_save :cleanup
  
  validates_presence_of :title
  
  def average_rank
    if cached_average_rank.nil?
      compute_average_rank
    else
      cached_average_rank
    end
  end

  def compute_average_rank
    self.update_attribute('cached_average_rank', rankings.average(:rank).to_f)
    self.update_attribute('cached_average_allocation', rankings.average(:allocation).to_f)
  end
  
  def std_rank    
    values = self.rankings.map{|p| p.rank}
    count = values.size
    mean = self.cached_average_rank
    stddev = Math.sqrt(values.inject(0) { |sum, e| sum + (e - mean) ** 2 } / count.to_f )
  end
  
  def standard_deviation
    if cached_standard_deviation.nil?
      compute_standard_deviation
    else
      cached_standard_deviation
    end
  end

  def compute_standard_deviation
    cached_standard_deviation = Ranking.calculate(:std, :rank, :conditions => {:item_id => self.id}).to_f
    save!
    cached_standard_deviation 
  end

  def ranking_for_user(user)
    r = rankings.detect{|p| p.user_id == user.id }
    if r.blank?
      r = Ranking.new(:user_id => user.id, :item_id => id, :ordinal => 0)
    end
    r
  end
  
  private

    def cleanup
      self.title.strip! unless self.title.blank?
      self.description.strip! unless self.description.blank?
    end
end
