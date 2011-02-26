require "uri"
include ActionController::UrlWriter

class Post < ActiveRecord::Base
    validates :title, :presence => true,
                      :length => {:minimum => 7, :maximum => 100},
                      :unless => :is_comment?

    belongs_to :user
    belongs_to :parent, :class_name => "Post"
    has_many :children, :class_name => "Post", :foreign_key => "parent_id"
    
    def is_comment?
        not parent.nil?
    end
    
    def comment_count
        count = children.length
        if count > 0
            children.each do |c|
                count = count + c.comment_count
            end
        end
        
        count
    end
    
    def domain
        URI.parse(self.link).host
    end
end
