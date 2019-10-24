require 'oystercard'

describe Oystercard do
  let(:entry_station)   { double :station, name: "Waterloo", zone: 1 }
  let(:exit_station)    { double :station, name: "Kings Cross", zone: 1 }
  let(:journey)         { { entry_station: entry_station, exit_station: exit_station } }

  before (:each) do
    @card = Oystercard.new
    @card.top_up(10)
  end
  # let(:card)            { described_class.new }
  # let(:subject_w_money) { card.top_up(10) }


  describe 'defaults' do
    it 'should have a balance of zero' do
      expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'should allow the user to top up their oystercard' do
      expect(@card.balance).to eq(10)
    end

    it 'should not allow user to top up if the end balance is > Max balance' do
      msg = "Max balance £#{Oystercard::MAX_BALANCE} will be exceeded"
      subject.top_up(Oystercard::MAX_BALANCE)
      expect { subject.top_up(1) }.to raise_error msg
    end
  end

  describe '#touch_in' do

    it 'should raise an error if touching in without the minimum balance' do
      msg = 'Cannot touch in: Not enough funds'
      expect { subject.touch_in(entry_station) }.to raise_error msg
    end

    it 'should charge the card a penalty if touched_in twice' do
      @card.touch_in(entry_station)
      expect { @card.touch_in(entry_station) }.to change { @card.balance }.by(-6)
    end
  end

  describe '#touch_out' do

    it 'should deduct the fare from the card' do
      @card.touch_in(entry_station)
      expect { @card.touch_out(exit_station) }.to change { @card.balance }.by(-1)
    end

    it 'should charge the card a penalty if touched_out w/o touch_in' do
      expect { @card.touch_out(exit_station) }.to change { @card.balance }.by(-6)
    end

  end
end