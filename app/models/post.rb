class Post < ApplicationRecord
  validates :body, presence: true
  has_one_attached :image
  broadcasts_to ->(post) { "posts" }, inserts_by: :prepend
end
