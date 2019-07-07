json.extract! comment, :id, :user, :post, :body, :likes
json.created_at l(comment.created_at, format: :short)
