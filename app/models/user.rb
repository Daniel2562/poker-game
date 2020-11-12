class User < ApplicationRecord

  include Concerns::Authenticatable
  include Concerns::Confirmable
  include Concerns::Recoverable

  has_many :sessions, dependent: :destroy
  has_many :created_requests, :class_name => 'Request', :foreign_key => 'user_id'
  has_many :incoming_requests, :class_name => 'Request', :foreign_key => 'pro_id'

end
