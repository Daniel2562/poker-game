module Api
  module V1
    class SessionSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :title, :game, :kind, :level_time,
                 :small_blind, :big_blind, :ante, :created_at, :updated_at
    end
  end
end
