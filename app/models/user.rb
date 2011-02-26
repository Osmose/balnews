class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  has_many :posts
  has_many :votes
  
  def votedFor(post)
    vote = Vote.where(:user => self, :post => post).first
    
    if vote.nil?
        nil
    elsif vote.up
        :up
    else
        :down
    end
  end
end
