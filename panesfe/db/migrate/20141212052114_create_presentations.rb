class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :name, null: false
      t.boolean :published, default: false, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
