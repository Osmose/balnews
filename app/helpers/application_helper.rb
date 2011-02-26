module ApplicationHelper

    def discuss_link(post)
        count = post.comment_count
        
        if count == 0
            link_to("discuss", post)
        elsif count == 1
            link_to("1 comment", post)
        else
            link_to("#{count} comments", post)
        end
    end

end
