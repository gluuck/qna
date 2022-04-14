ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  
  has user_id, commentable_type, commentable_id, created_at, updated_at
end