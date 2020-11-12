module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :name, :avatar, :pro, :admin,
                 :applied_promo_code, :remaining_promo_requests

      has_many :game_kinds

    end
  end
end
