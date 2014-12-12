class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :given_name
      t.string :family_name
      t.string :uid
      t.string :provider
      t.string :role

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
