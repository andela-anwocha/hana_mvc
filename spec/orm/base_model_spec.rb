require 'spec_helper'

describe 'Base_Model' do
  before(:each) { User.destroy_all }
  let(:db) { Hana::Database }
  let!(:users) { create_list(:user, 5) }

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

  describe '.create' do
    it 'creates a new record in the database' do
      expect { User.create(name: 'Andela', age: 3) }
        .to change { User.all.count }.by(1)
    end
  end

  describe '.destroy_all' do
    it 'removes all object rows from database' do
      User.destroy_all
      expect(User.all.count).to eql(0)
    end
  end

  describe '.find' do
    it 'returns the model matching the specified id' do
      expect(User.find(1)).to eql(users.first)
    end
  end

  describe '.all' do
    it 'returns all rows as model instances' do
      expect(User.all.count).to eql(users.count)
    end
  end

  describe '.last' do
    it 'returns the last model instance' do
      expect(User.last).to eql(users.last)
    end
  end

  describe '.first' do
    it 'returns the first model instance' do
      expect(User.first).to eql(users.first)
    end
  end

  describe '.where' do
    it 'returns all model instances matching the passed in attributes' do
      create_list(:user, 2, name: 'Andela')
      expect(User.where(name: 'Andela').count).to eql(2)
    end
  end

  describe '#save' do
    it 'persists a model instance to the database' do
      user = User.new(name: 'Andela', age: 3)
      expect { user.save }
        .to change { User.all.count }.by(1)
    end
  end

  describe '#update' do
    it 'updates a models attribute and persists it to database' do
      user = User.create(name: 'Andela', age: 3)
      user.update(age: 2)

      expect(user.age).to eql(2)
      expect(User.find(user.id).age).to eq(2)
    end
  end

  describe '#reload' do
    it 'updates models attributes to match with database' do
      user = User.create(name: 'Andela', age: 10)
      db.execute "update users set name=? where id=#{user.id}", 'Patience'
      user.reload

      expect(user.name).to eql('Patience')
    end
  end

  describe '#destroy' do
    it 'deletes the model row from database' do
      expect { users.first.destroy }.to change { User.all.count }.by(-1)
    end
  end
end
