require_relative 'journey'

class JourneyLog

  attr_reader :journey_history, :journey

  def initialize(journey=Journey)
    @journey = journey.new
    @journey_history = []
  end

  def start(station)
    @journey.start_journey(station)
  end

  def finish(station)
    @journey.stop_journey(station)
  end

  def add_to_history
    @journey_history << { entry_station: @journey.entry_station, exit_station: @journey.exit_station }
  end

  def price
    @journey.fare
  end

  def current_journey
    return journey if journey.incomplete_journey?
    @journey = Journey.new
  end

  def journeys
    @journey_history.dup
  end
end