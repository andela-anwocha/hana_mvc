require "spec_helper"

describe "Model Accessors" do
  before(:each){ User.destroy_all }
  let!(:users){ create_list(:user, 5) }

  describe ".find" do
    it "returns the model matching the specified id" do
      expect(User.find(1)).to eql(users.first)
    end
  end

  describe ".all" do
    it "returns all rows as model instances" do
      expect(User.all.count).to eql(users.count)
    end
  end

  describe ".last" do
    it "returns the last model instance" do
      expect(User.last).to eql(users.last)
    end
  end

  describe ".first" do
    it "returns the first model instance" do
      expect(User.first).to eql(users.first)
    end
  end

  describe ".where" do
    it "returns all model instances matching the passed in attributes" do
      create_list(:user, 2, name: "Andela")
      expect(User.where(name: "Andela").count).to eql(2)
    end
  end

end
