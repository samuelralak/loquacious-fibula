class Item < ActiveRecord::Base
  belongs_to :itemable, polymorphic: true
  belongs_to :user

  accepts_nested_attributes_for :itemable
end
