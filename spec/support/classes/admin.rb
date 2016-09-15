class Admin < Hana::BaseModel
  to_table :admins
  property :name, type: :text
  property :email, type: :text
  property :age, type: :integer
  create_table
end
