class AddIndexToVotables < ActiveRecord::Migration[7.0]
  def change
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
    add_index :votes, [:votable_id, :votable_type]
  end
end
