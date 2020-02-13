class CreateRepos < ActiveRecord::Migration[6.0]
  def change
    create_table :repos do |t|
      t.string :nickname
      t.string :url
      t.boolean :analyzed, default: false
      t.string :bundle_id, default: nil
      t.string :analysis_status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
