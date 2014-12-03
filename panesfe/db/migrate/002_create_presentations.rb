migration 2, :create_presentations do
  up do
    create_table :presentations do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :user_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :presentations
  end
end
