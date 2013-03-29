class QueueError < Exception
end

class Queue
  attr_reader :list

  def initialize
    @list = []
    @mutex = Mutex.new
    @counter = 0
  end

  # push new task in the pool
  def push task
    raise QueueError, "Incorrect data type" unless valid? task
  end

  def get_task finish_at
  end

  def pop
  end

  private
  def valid? task
    task.class == Task
  end
end