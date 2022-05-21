require 'rails_helper'

RSpec.describe Tournament, type: :model do
  subject { Tournament.new(name: name, status: status, teams: teams) }

  let(:name) { 'Tournament 1' }
  let(:status) { 'draft' }
  let(:teams) do
    (1..16).map do |i|
      Team.new(id: i, name: i)
    end
  end

  context 'associations' do
    it { should have_many(:divisions).dependent(:destroy) }
    it { should have_many(:playoffs).conditions(name: 'Playoff').class_name('Division').dependent(:destroy) }
    it { should belong_to(:winner).class_name('Team').optional(:true) }
    it { should belong_to(:finalist).class_name('Team').optional(:true) }
    it { should have_and_belong_to_many(:teams) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w(draft in_progress done)) }

    context 'when quantity of unique teams is equal TEAMS_COUNT constant' do
      it { should allow_value(teams).for(:teams) }
    end

    context 'when quantity of unique teams is not equal TEAMS_COUNT constant' do
      let(:teams) do
        (1..15).map do |i|
          Team.new(id: i, name: i)
        end
      end

      it { should_not allow_value(teams).for(:teams) }
    end
  end

  describe '#create_a_playoff_stage?' do
    let(:divisions) { [ division_a, division_b ] }
    let(:division_a) { mock_model(Division) }
    let(:division_b) { mock_model(Division) }

    before do
      subject.divisions = divisions
      allow(division_a).to receive(:all_games_played?).and_return(true)
      allow(division_b).to receive(:all_games_played?).and_return(true)
    end

    context 'when all games in any previous divisions or playoff stages are finished' do
      it_behaves_like 'returns true', :create_a_playoff_stage?

      context 'when quantity of playoff stages is less than Math.log2(TEAMS_COUNT) - 1' do
        let(:playoffs) { [playoff, playoff] }
        let(:playoff) { mock_model(Division) }

        before { subject.playoffs = playoffs }

        it_behaves_like 'returns true', :create_a_playoff_stage?
      end

      context 'when quantity of playoff stages is not less than Math.log2(TEAMS_COUNT) - 1' do
        let(:playoffs) { [playoff, playoff, playoff] }
        let(:playoff) { mock_model(Division) }

        before { subject.playoffs = playoffs }

        it_behaves_like 'returns false', :create_a_playoff_stage?
      end
    end

    context 'when all games in any previous divisions or playoff stages are finished' do
      before do
        allow(division_b).to receive(:all_games_played?).and_return(false)
      end

      it_behaves_like 'returns false', :create_a_playoff_stage?
    end
  end

  describe '#finish' do
    let(:winner) { mock_model(Team) }
    let(:finalist) { mock_model(Team) }
    let(:expected_attributes) do
      {
        'status' => 'done',
        'finalist_id' => finalist.id,
        'winner_id' => winner.id
      }
    end

    it 'updates model with provided attributes and sets done status' do
      expect(subject.finish(finalist, winner)).to eq(true)
      expect(subject.attributes).to include(expected_attributes)
    end
  end

  describe '#start' do
    let(:expected_attributes) { { 'status' => 'in_progress' } }

    it 'sets in_progress status' do
      expect(subject.start).to eq(true)
      expect(subject.attributes).to include(expected_attributes)
    end
  end
end
