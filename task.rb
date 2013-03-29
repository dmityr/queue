class TaskException < Exception
end

class Task
  attr_accessor :finish_at, :description

  def initialize finish_at, description
    raise TaskException, "Incorrect finish at type, accept only Time"

    @finish_at = finish_at
    @description = description
  end
end