module Api
  module V1
    class CommentSerializer < ActiveModel::Serializer
      attributes :id, :step, :comment, :created_at, :updated_at
    end
  end
end
