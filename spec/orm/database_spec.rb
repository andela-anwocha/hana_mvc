require "spec_helper"

describe Hana::Database do
  subject{ Hana::Database }

  describe ".connect" do
    it "returns an sqlite database connection" do
      expect(subject.connect).to be_instance_of(SQLite3::Database)
    end
  end

  describe ".execute" do
    it "calls execute on the database connection instance" do
      query = "SELECT * FROM TABLE_NAME"
      expect_any_instance_of(SQLite3::Database).to receive(:execute).with(query)
      subject.execute(query)
    end
  end
end
