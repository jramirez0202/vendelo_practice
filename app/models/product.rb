class Product < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_full_text, against: {
      title: 'A',
      description: 'B'
    }
    
  belongs_to :category
  has_one_attached :photo
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  
  ORDER_BY = { 
    newest: 'created_at DESC',
    cheapest: 'price ASC',
    expensive: 'price DESC'
  }
  
 
    
end
