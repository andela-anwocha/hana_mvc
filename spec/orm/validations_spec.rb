require 'spec_helper'

describe 'Model Validators' do
  before(:each) { User.destroy_all }

  context 'validate_presence' do
    it 'ensures presence of attribute before persistence to database' do
      User.class_eval { validates :name, presence: true }
      user = User.new(age: 10)
      user.save

      expect(user.errors).to include(name: 'name cannot be empty')
    end
  end

  context 'validate_length' do
    context 'when is attribute is used' do
      it "ensures that the length of attribute matches exactly with the value of 'is'" do
        User.class_eval { validates :name, length: { is: 4 } }
        user = User.new(name: 'Andela')
        user.save

        expect(user.errors).to include(name: 'name must be 4 characters')
      end
    end

    context 'when maximum attribute is used' do
      it 'ensure that the length of attribute does not exceed the value of maximum' do
        User.class_eval { validates :name, length: { maximum: 4 } }
        user = User.new(name: 'Andela')
        user.save

        expect(user.errors).to include(name: "name musn't exceed 4 characters")
      end
    end

    context 'when minimum attribute is used' do
      it 'ensures that the length of attribute is atleast the minimum value' do
        User.class_eval { validates :name, length: { minimum: 5 } }
        user = User.new(name: 'Test')
        user.save

        expect(user.errors).to include(name: 'name must be 5 characters atleast')
      end
    end
  end

  context 'validate_numericality' do
    it 'ensures that attribute value is numeric' do
      User.class_eval { validates :age, numericality: true }
      user = User.new(name: 'Andela', age: 'Ten')
      user.save

      expect(user.errors).to include(age: 'age must be numeric')
    end
  end

  context 'validate_format' do
    it "ensures that attribute value matches regex pattern in the 'with' attribute" do
      User.class_eval { validates :name, format: { with: /^\w+[0-9]+$/ } }
      user = User.new(name: 'Andela', age: 10)
      user.save

      expect(user.errors).to include(name: "name didn't match pattern")
    end
  end
end
