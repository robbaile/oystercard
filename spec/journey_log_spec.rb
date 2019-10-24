require 'journey_log'
require 'journey'

describe JourneyLog do

  let(:entry_station)   { double :station, name: "Arsenal", zone: 2 }
  let(:exit_station)    { double :station, name: "Kings Cross", zone: 1 }
  let(:journey_class)   { double :journey_class, new: journey }
  let(:journey)         { double :journey, entry_station: entry_station, exit_station: exit_station, incomplete_journey?: true }


  describe '#new' do
    it 'should initialize journey_log with an empty journey_history array' do
      expect(subject.journey_history).to be_empty
    end
  end

  describe '#journey_log start' do
    it 'should start a new journey' do
      subject.start(entry_station)
      expect(subject.journey.entry_station).to eq entry_station
    end
  end

  describe '#journey_log finish' do
    it 'should finish a journey at the specified station' do
      subject.finish(exit_station)
      expect(subject.journey.exit_station).to eq exit_station
    end
  end

  describe '#add_to_history' do
    it 'should add a journey to the journey history array' do
      journey_log = JourneyLog.new(journey_class)
      journey_log.add_to_history
      expect(journey_log.journey_history).to include ({:entry_station=>entry_station, :exit_station=>exit_station})
    end
  end

  describe '#current_journey' do
    it 'Should return current journey if unsuccessful' do
      complete = JourneyLog.new(journey_class)
      complete.current_journey
      expect(complete.current_journey).to eq journey
    end
  end

  describe '#journeys' do
    it 'Should return a copy of the journey history variable' do
      expect(subject.journeys).to eq []
    end
  end
end