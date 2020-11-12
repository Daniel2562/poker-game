module Api
  module V1
    class HandSerializer < ActiveModel::Serializer
      attributes :id, :level, :level_time, :hand_limit,
                 :small_blind, :big_blind, :ante,
                 :players_dealt, :position,
                 :start_pot, :start_stack, :final_stack, :state,
                 :created_at, :updated_at

      has_many :hole_cards
      has_many :table_cards
      has_many :villains, root: :villains_attributes
      has_many :steps, root: :steps_attributes

      has_one :session

      def steps
        object.steps.order('id')
      end

      def villains
        object.villains.order('id')
      end
    end
  end
end
