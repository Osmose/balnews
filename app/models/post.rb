require "uri"

class Post < ActiveRecord::Base
    validates :title, :presence => true,
                      :length => {:minimum => 7, :maximum => 100},
                      :unless => :is_comment?

    belongs_to :user
    belongs_to :parent, :class_name => "Post"
    
    def is_comment?
        not parent.nil?
    end
    
    def domain
        URI.parse(self.link).host
    end
end
