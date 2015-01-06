class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.references :presentation, index: true, null: false
      t.string :image

      t.timestamps
    end
  end
end
