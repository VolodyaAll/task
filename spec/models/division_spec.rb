require 'rails_helper'

RSpec.describe Division, type: :model do
  subject { Division.new(name: name, tournament: tournament) }

  let(:name) { 'A' }
  let(:tournament) { stub_model(Tournament, id: 1) }

  context 'associations' do
    it { should belong_to(:tournament) }
    it { should have_many(:games).dependent(:destroy) }
    it { should have_and_belong_to_many(:teams) }
    it { should accept_nested_attributes_for(:games) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:name).in_array(%w(A B Playoff)) }
  end

  describe '#all_games_played?' do
    let(:games) do
      [
        stub_model(Game, id: 1, winner: winner_1),
        stub_model(Game, id: 2, winner: winner_2)
      ]
    end

    let(:winner_1) { stub_model(Team, id: 1, name: '1') }
    let(:winner_2) { stub_model(Team, id: 2, name: '2') }

    before { subject.games = games }

    context 'when all games have winners' do
      it_behaves_like 'returns true', :all_games_played?
    end

    context 'when any game have not winner' do
      let(:winner_2) { nil }

      it_behaves_like 'returns false', :all_games_played?
    end
  end

  describe '#top' do
    # let(:top) { subject.top }
    before do
      subject.save
      teams = [
        Team.create(name: '1'),
        Team.create(name: '2'),
        Team.create(name: '3'),
        Team.create(name: '4')
      ]
      games = [
        Game.create(division: subject, team_one: teams[0], team_two: teams[1], winner: teams[0]),
        Game.create(division: subject, team_one: teams[0], team_two: teams[2], winner: teams[0]),
        Game.create(division: subject, team_one: teams[0], team_two: teams[3], winner: teams[0]),
        Game.create(division: subject, team_one: teams[1], team_two: teams[2], winner: teams[1]),
        Game.create(division: subject, team_one: teams[1], team_two: teams[3], winner: teams[1]),
        Game.create(division: subject, team_one: teams[2], team_two: teams[3], winner: teams[2]),
      ]
      subject.update(teams: teams, games: games)
    end

    context 'when desired winners quantity is not provided' do
      it "returns half of division's teams quantity teams, ordered by division games won count" do
        top = subject.top

        expect(top.length).to eq(subject.teams.size / 2)
        expect(top.each_cons(2).all? { |a,b| a.wins >= b.wins }).to be true
      end
    end

    context 'when desired winners quantity is provided' do
      let(:quantity) { 1 }

      it "returns half of division's teams quantity teams, ordered by division games won count" do
        top = subject.top(quantity)

        expect(top.length).to eq(quantity)
      end
    end
  end

  describe '#playoff?' do
    context 'when division name is Playoff' do
      let(:name) { 'Playoff' }

      it_behaves_like 'returns true', :playoff?
    end

    context 'when division name is not Playoff' do
      it_behaves_like 'returns false', :playoff?
    end
  end

  describe '#final_playoff_stage?' do
    before { subject.games = games }

    context 'when games quantity is equal 1' do
      let(:games) do
        [
          stub_model(Game)
        ]
      end

      it_behaves_like 'returns true', :final_playoff_stage?
    end

    context 'when games quantity is not equal 1' do
      let(:games) do
        [
          stub_model(Game),
          stub_model(Game)
        ]
      end

      it_behaves_like 'returns false', :final_playoff_stage?
    end
  end
end
