require 'rails_helper'

describe ApplicationHelper, type: :helper do
  context 'title' do
    context 'is empty' do
      subject { title('') }
      it { is_expected.to eq('Sunline') }
    end

    context 'is nil' do
      subject { title(nil) }
      it { is_expected.to eq('Sunline') }
    end

    context 'is "Scripts"' do
      subject { title('Scripts') }
      it { is_expected.to eq('Scripts - Sunline') }
    end
  end
end
