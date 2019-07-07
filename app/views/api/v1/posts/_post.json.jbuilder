json.extract! post, :id, :blog, :body, :visits, :likes, :private
json.created_at l(post.created_at, format: :short)
json.updated_at l(post.updated_at, format: :short)
