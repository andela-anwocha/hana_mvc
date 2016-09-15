require 'spec_helper'

describe 'Model Accessors' do
  before(:each) { User.destroy_all }

  let(:db) { Hana::Database }
  let!(:users) { create_list(:user, 5) }

  describe '.create' do
    it 'creates a new record in the database' do
      expect { User.create(name: 'Andela', age: 3) }
        .to change { User.all.count }.by(1)
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

  describe '.destroy_all' do
    it 'removes all object rows from database' do
      User.destroy_all
      expect(User.all.count).to eql(0)
    end
  end

  describe '#destroy' do
    it 'deletes the model row from database' do
      expect { users.first.destroy }.to change { User.all.count }.by(-1)
    end
  end
end
