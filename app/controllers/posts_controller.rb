class PostsController < ApplicationController
    before_filter :authenticate_user!, :except => [:index, :show]
    
    def index
        @posts = Post.paginate(
            :page => params[:page],
            :conditions => {
                :parent_id => nil
            },
            :order => "created_at DESC"
        )
        
        respond_to do |format|
            format.html
            format.xml {render :xml => @posts}
        end
    end
    
    def vote
        post = Post.find(params[:id])
        vote = Vote.where(:user_id => current_user.id, :post_id => post.id).first
        
        if (post.user == current_user)
            redirect_to(:back)
        end
        
        if (vote.nil?)
            vote = Vote.new
            vote.user = current_user
            vote.post = post
        end
        
        vote.up = params[:type] == "up"
        
        if vote.save
            redirect_to(:back)
        else
            redirect_to(:back, :error => "Vote failed")
        end
    end
    
    def show
        @post = Post.find(params[:id])
        
        @comment = Post.new
        @comment.parent = @post
        
        if @post
            respond_to do |format|
              format.html # show.html.erb
              format.xml  { render :xml => @post }
            end
        else
            redirect_to(root_url, :error => "Post not found")
        end
    end
    
    def new
        @post = Post.new
    end
    
    def edit
        @post = Post.find(params[:id])
    end
    
    def create
        @post = Post.new(params[:post])
        @post.user = current_user

        if @post.save
            if !@post.parent.nil?
                redirect_to(@post.parent)
            else
                redirect_to(@post, :notice => 'Post was successfully created.')
            end
        else
            redirect_to :back, :error => "Error saving post."
        end
    end
    
    def update
        @post = Post.find(params[:id])

        if ((Time.now - @post.created_at) / 1.hour).round > 1
            redirect_to(posts_url)
        elsif @post.update_attributes(params[:post])
            redirect_to(@post, :notice => 'Post was successfully updated.')
        else
            render :action => "edit", :error => "Error editing post"
        end
    end
    
    def destroy
        @post = Post.find(params[:id])
        
        if ((Time.now - @post.created_at) / 1.hour).round < 1
            @post.destroy
            redirect_to(posts_url, :notice => "Post was deleted successfully")
        else
            redirect_to(posts_url, :error => "Cannot delete posts older than 1 hour")
        end
    end
end
