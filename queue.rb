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

    @mutex.synchronize do
      @list << [@counter, task.finish_at, task]
      @counter += 1
    end

    true
  end
  alias << push

  def get_task finish_at
  end

  def pop
  end

  private
  def valid? task
    task.class == Task
  end
end