module Api
  module V1
    class StepSerializer < ActiveModel::Serializer
      attributes :id, :actor, :action, :amount, :stack, :title, :comment
    end
  end
end