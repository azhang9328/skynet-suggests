class CreateRepos < ActiveRecord::Migration[6.0]
  def change
    create_table :repos do |t|
      t.string :nickname
      t.string :url
      t.boolean :analyzed
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
