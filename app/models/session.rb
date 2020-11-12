class Session < ApplicationRecord
  belongs_to :user
  has_many :hands, dependent: :destroy
end
