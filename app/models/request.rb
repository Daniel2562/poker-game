class Request < ApplicationRecord
  belongs_to :hand
  belongs_to :user
  belongs_to :pro, :class_name => 'User', :foreign_key => 'pro_id'

  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments
end
