class QueueError < Exception
end

class Queue
  attr_reader :list

  def initialize
    @list = []
    @mutex = Mutex.new
    @counter = 0
  end

  def push task
  end

  def get_task finish_at
  end

  def pop
  end
end