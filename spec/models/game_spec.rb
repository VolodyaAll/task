require 'rails_helper'

RSpec.describe Game, type: :model do
  subject { Game.new(division: division, team_one: team_one, team_two: team_two) }

  let(:division) { stub_model(Division, id: 1) }
  let(:team_one) { stub_model(Team, id: 1) }
  let(:team_two) { stub_model(Team, id: 2) }

  context 'associations' do
    %i(division team_one team_two).each do |association|
      it { should belong_to(association) }
    end

    it { should belong_to(:winner).optional(:true) }
  end

  context 'validations' do
    %i(division team_one team_two).each do |attribute|
      it { should validate_presence_of(attribute) }
    end
  end


  describe '#looser' do
    before { subject.winner = team_one }

    it 'returns losing team' do
      expect(subject.looser).to eq(team_two)
    end
  end
end
