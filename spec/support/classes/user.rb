class User < Hana::BaseModel
  to_table :users
  property :name, type: :text
  property :age, type: :integer
  property :admin_id, type: :integer
  create_table
end
