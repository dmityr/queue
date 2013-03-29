class TaskException < Exception
end

class Task
  attr_reader :finish_at, :description

  def initialize finish_at, description
    raise TaskException, "Incorrect finish at type, accept only Time" unless finish_at.is_a?(Time)

    @finish_at = finish_at
    @description = description
  end
end