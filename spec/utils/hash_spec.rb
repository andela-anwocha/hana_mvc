require 'spec_helper'

describe Hash do
  describe '#permit' do
    it 'allows only the specified keys' do
      expect({ id: 1, name: 'test' }.permit(:id)).to eq(id: 1)
    end
  end

  describe '#symbolize_keys' do
    it 'symbolizes the hash keys' do
      expect({ 'id' => 1 }.symbolize_keys).to eq(id: 1)
    end
  end
end
