module Api
  module V1
    class RequestSerializer < ActiveModel::Serializer
      attributes :id, :viewed, :resolved, :accepted, :summary, :payment, :created_at, :updated_at
      has_one :hand
      has_one :pro, serializer: ProUserSerializer
      has_one :user, serializer: UserSerializer
      has_many :comments
    end
  end
end