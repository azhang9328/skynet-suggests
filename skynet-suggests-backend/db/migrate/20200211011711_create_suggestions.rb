class CreateSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :suggestions do |t|
      t.string :file
      t.integer :marker
      t.string :rows
      t.string :cols
      t.string :dp_id
      t.string :message
      t.integer :severity
      t.references :repo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
