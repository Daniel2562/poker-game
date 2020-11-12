module Api
  module V1
    class VillainSerializer < ActiveModel::Serializer
      attributes :id, :profile, :position, :start_stack
    end
  end
end
