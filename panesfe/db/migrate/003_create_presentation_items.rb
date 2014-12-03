migration 3, :create_presentation_items do
  up do
    create_table :presentation_items do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :presentation_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :presentation_items
  end
end
