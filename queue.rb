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
    current_time = Time.new

    extract_task do |task|
      if task[1] < current_time || task[1] == finish_at
        task[0]
      end
    end
  end

  def pop
    current_time = Time.new

    extract_task do |task|
      if task < current_time
        task[0]
      end
    end
  end

  private
  def extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      nl = @list.sort_by{|x| [x[1], x[0]]}
      pos = yield(nl[0])

      @list.delete_at(pos) unless pos.nil?
    end
  end

  def valid? task
    task.class == Task
  end
end