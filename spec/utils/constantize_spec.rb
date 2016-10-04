require 'spec_helper'

describe 'Utility Methods' do
  context '#constantize' do
    context 'Hash' do
      it { expect('Hash'.constantize).to eq Hash }
    end

    context 'String' do
      it { expect('String'.constantize).to eq String }
    end

    context 'Array' do
      it { expect('Array'.constantize).to eq Array }
    end
  end
end
