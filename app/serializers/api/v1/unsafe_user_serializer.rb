module Api
  module V1
    class UnsafeUserSerializer < UserSerializer
      attributes :id, :email, :name, :avatar, :pro, :admin, :auth_token,
                 :created_at, :updated_at, :confirmed_at,
                 :ios_iap_id, :android_iap_id,
                 :promo_code, :applied_promo_code, :remaining_promo_requests

      has_many :game_kinds

    end
  end
end
