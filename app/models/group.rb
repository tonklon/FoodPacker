class Group < ActiveRecord::Base
  
  validates :name, presence: true
  validates :name, uniqueness: true
  
  validates :participants_count, numericality: { :only_integer => true , :greater_than => 0}
  validates :hunger_factor, numericality: {greater_than_or_equal_to: 0.4, less_than_or_equal_to: 1.6}
  
end
