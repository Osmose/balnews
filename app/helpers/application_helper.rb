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

    def upvote_path(content, post)
        link_to(content, "vote/#{post.id}/up")
    end
    
    def downvote_path(content, post)
        link_to(content, "vote/#{post.id}/down")
    end
end
