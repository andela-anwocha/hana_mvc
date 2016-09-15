require 'spec_helper'

describe 'QueryHelpers' do
  let(:db) { Hana::Database }
  subject { Hana::BaseModel }

  describe '.to_table' do
    it 'assigns a table name to an instance variable' do
      subject.to_table :users
      table_name = subject.instance_variable_get(:@table_name)

      expect(table_name).to eq(:users)
    end
  end

  describe '.property' do
    before { subject.property :name, type: :integer }

    it 'populates the properties instance variable' do
      property = subject.instance_variable_get(:@properties)

      expect(property.keys).to include(:name)
    end

    it 'makes the column names attribute accessible' do
      expect(subject.new).to respond_to(:name)
    end
  end

  describe '.create_table' do
    it 'executes sql query to create database table' do
      expect(db).to receive(:execute)
      subject.create_table
    end
  end
end
