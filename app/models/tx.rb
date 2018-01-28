class Tx < ApplicationRecord
  belongs_to :balance
  scope :trades, -> { where(type: 'Trade') }
  scope :movements, -> { where(type: 'Movement') }
  scope :valid, -> { where(invalidated: 0) }
  
  def self.types
    %w(Trade Movement)
  end
end
