class User < ActiveRecord::Base
  acts_as_authentic
  
  def ranked_list_ids
    ranked_ids_query = %Q{select id from lists where id in (select items.list_id from rankings inner join items on rankings.item_id = items.id where rankings.user_id = #{self.id} group by items.list_id)}
    select_column(:id, List.connection.select_all(prioritized_ids_query))
  end
  
  def all_lists(options = {})
    # options[:page] ||= 1
    # options[:per_page] ||= 10
    # 
    # sort = options.delete(:sort) || 'newest'
    # case sort
    # when 'newest'
    #   options[:order] = 'created_at DESC'
    # when 'oldest'
    #   options[:order] = 'created_at ASC'
    # else
    #   options[:order] = 'created_at DESC'
    # end
    # 
    # filter = options.delete(:filter) || 'all'
    # conditions = {}
    # case filter
    # when 'all'
    #   conditions[:id] = all_touched_list_ids
    # when 'prioritized'
    #   conditions[:id] = prioritized_list_ids
    # when 'unprioritized'
    #   conditions[:id] = all_untouched_list_ids
    # else
    #   conditions[:id] = all_touched_list_ids
    # end
    # 
    # account.lists.paginate(:all, :page       => options[:page],
    #                        :per_page   => options[:per_page],
    #                        :conditions => conditions,
    #                        :order      => options[:order],
    #                        :include    => :user)
  end
  
  protected
    def select_column(column, rows)
      rows.collect{|h| h[column.to_s]}
    end
end
