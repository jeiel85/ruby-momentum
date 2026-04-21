class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  after_create_commit { broadcast_append_to post, partial: "comments/comment", locals: { comment: self } }
end

