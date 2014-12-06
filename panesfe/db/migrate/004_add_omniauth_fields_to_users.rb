migration 4, :add_omniauth_fields_to_users do
  up do
    modify_table :users do
      add_column :uid, String
      add_column :provider, String
    end
  end

  down do
    modify_table :users do
      drop_column :uid
      drop_column :provider
    end
  end
end
