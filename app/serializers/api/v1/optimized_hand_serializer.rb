module Api
  module V1
    class OptimizedHandSerializer < ActiveModel::Serializer
      attributes :id, :created_at, :updated_at
    end
  end
end
