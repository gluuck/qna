class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question,foreign_key: true
      t.references :user,foreign_key: true
      
      t.timestamps
    end
  end
end
