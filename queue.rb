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
      task.finish_at < current_time || task.finish_at == finish_at
    end
  end

  def pop
    current_time = Time.new

    extract_task do |task|
      task.finish_at < current_time
    end
  end

  private
  def extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      @list.sort_by!{|x| x.finish_at}
      valid = yield(@list[0])

      if valid
        @list.delete_at(0)
      else
        nil
      end
    end
  end

  def valid? task
    task.class == Task
  end
end