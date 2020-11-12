class Hand < ApplicationRecord

  belongs_to :session

  has_many :requests, dependent: :destroy

  has_many :villains, dependent: :destroy
  accepts_nested_attributes_for :villains

  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps

end
