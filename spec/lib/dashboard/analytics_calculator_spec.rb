require 'spec_helper'

describe AnalyticsCalculator do
  context 'initialize' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it 'receives a proper user object as its first argument' do
      expect { AnalyticsDecorator.new("not a user", "not a date range") }.to eq(false)
    end

    it 'can receive a date range as its second argument' do
      expect { AnalyticsDecorator.new(@user, "not a date range") }.to not_eq(false)
    end
  end

  context 'graph_points' do
    it 'sums the revenues of games within the date range cumutatively' do
    end

    it 'returns a hash of dates and values' do
    end
  end

  context 'revenue_amount' do
    it 'calculates the gross sum of all users games within the date range' do
    end
  end

  context 'roi' do
    it 'calculates the return on investment for all buyins and returns for all games within the date range' do
    end
  end

  context 'games_played' do
    it 'sums the number of games the user has played within the date range' do
    end
  end
end