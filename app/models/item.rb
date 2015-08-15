class Item < ActiveRecord::Base
    include AASM

    belongs_to :itemable, polymorphic: true
    belongs_to :user

    has_one :report, inverse_of: :item, dependent: :destroy

    accepts_nested_attributes_for :itemable

    aasm :whiny_transitions => false do
        state :active, :initial => true
        state :locked
        state :sold
        state :inactive

        event :lock do
            transitions :from => :active, :to => :locked
        end

        event :sell do
            transitions :from => [:active, :locked], :to => :sold
        end

        event :activate do
            transitions :from => :locked, :to => :active
        end

        event :deactivate do
            transitions :from => [:active, :locked], :to => :inactive
        end
    end
end
