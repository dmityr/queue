class Task
  attr_accessor :finish_at, :description

  def initialize finish_at, description
    finish_at = (finish_at.is_a? Time) ? finish_at.to_i : finish_at

    @finish_at = finish_at
    @description = description
  end
end