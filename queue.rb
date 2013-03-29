class QueueException < Exception
end

class Queue
  attr_reader :list

  def initialize
    @list = []
    @mutex = Mutex.new
  end

  # push new task in the pool
  def push task
    raise QueueException, "Incorrect data type" unless valid? task

    @mutex.synchronize do
      @list << task
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
      if task[1] < current_time
        task[0]
      end
    end
  end

  private
  def extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      nl = @list.sort_by{|x| x.finish_at}
      pos = yield(nl[0])

      unless pos.nil?
        valid_element = @list.delete_at(pos)
        valid_element[2]
      end
    end
  end

  def valid? task
    task.class == Task
  end
end