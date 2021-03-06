# Not the same thing as a Regimen. A schedule is a "dumb" list of sequecnes that
# are executed at fixed intervals. Schedules are less flexible than Regimens
# because they can only perform one sequence. Also unlike Regimens, they can run
# forever.
class Schedule < ActiveRecord::Base
  UNITS_OF_TIME = %w(minutely hourly daily weekly monthly yearly)

  belongs_to :sequence
  validates :sequence_id, presence: true
  belongs_to :device
  validates :device_id, presence: true

  def schedule_rules
    @schedule_rules ||= IceCube::Schedule.new(start_time, end_time: end_time) do |sch|
      sch.add_recurrence_rule IceCube::Rule.send(time_unit.to_sym, repeat)
    end
  end

  def calculate_next_occurence
    schedule_rules.next_occurrence
  end

  def between(start, finish)
    # Just for reference for later. Probably should just delegate.
    schedule_rules.occurrences_between(start, finish)
  end
end
