module Api
  module V1
    class ProUserSerializer < ActiveModel::Serializer
      attributes :id, :name, :avatar, :pro, :admin, :promo_code, :ios_iap_id, :android_iap_id
    end
  end
end
