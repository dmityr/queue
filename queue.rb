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
  def extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      nl = @list.sort_by{|x| [x[1], x[0]]}
      pos = yield(b.arity != 0 ? nl : nil)
      nl.delete_at(pos)
    end
  end

  def valid? task
    task.class == Task
  end
end