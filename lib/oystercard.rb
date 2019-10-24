require_relative 'journey'
require_relative 'station'
require_relative 'journey_log'

class Oystercard
  attr_reader :balance, :journey_log
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_CHARGE = 1

  def initialize(journeylog = JourneyLog)
    @balance = 0
    @journey_log = journeylog.new
  end

  def top_up(value)
    raise "Max balance £#{MAX_BALANCE} will be exceeded" if max_reached?(value)
    @balance += value
  end

  def touch_in(station)
    deduct unless @journey_log.journey.entry_station.nil?
    raise 'Cannot touch in: Not enough funds' if balance < MIN_BALANCE
    journey_log.start(station)
  end

  def touch_out(station)
    journey_log.finish(station)
    deduct
    journey_log.add_to_history
    journey_log.current_journey
  end

  private

  def max_reached?(value)
    balance + value > MAX_BALANCE
  end

  def deduct(value = journey_log.price)
    @balance -= value
  end
end