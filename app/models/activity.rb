class Activity < ActiveRecord::Base
  belongs_to :user, inverse_of: :activities
  belongs_to :trackable, polymorphic: true
end
