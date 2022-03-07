require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_count' do
    let(:model) { described_class }
    let(:votable_author) { create :user }
    let(:vote_author) { create :user }
    let(:votable) { create(described_class.to_s.underscore.to_sym, user: votable_author) }
    let(:vote) { create :vote, votable: votable, user: vote_author }

    context 'like' do
      it 'up vote count' do
        vote.vote_up
        expect(votable.vote_count).to eq 1
      end

      it 'down vote count' do
        vote.vote_down
        expect(votable.vote_count).to eq(-1)
      end
    end
  end
end
