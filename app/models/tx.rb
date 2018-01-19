class Tx < ApplicationRecord
  belongs_to :balance
  scope :trades, -> { where(race: 'Trade') }
  scope :movements, -> { where(race: 'Movement') }
  
  def self.types
    %w(Trade Movement)
  end
end
