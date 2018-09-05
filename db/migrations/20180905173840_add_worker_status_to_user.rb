Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :worker_status, FalseClass, default: false
    end
  end
end
