require 'spec_helper'

describe 'Utility Methods' do
  describe '#camelize' do
    context 'person_controller' do
      it { expect('person_controller'.camelize).to eq 'PersonController' }
    end
    context 'person__todo_app' do
      it { expect('person__todo_app'.camelize).to eq 'PersonTodoApp' }
    end
    context 'person' do
      it { expect('person'.camelize).to eq 'Person' }
    end
  end
end
