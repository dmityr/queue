class QueueException < Exception
end

class Queue
  attr_reader :list

  def initialize
    @list = []
    @mutex = Mutex.new
    @list_sorted = true
  end

  # push new task in the pool
  def push task
    raise QueueException, "Incorrect data type" unless valid? task

    @mutex.synchronize do
      @list << task
      @list_sorted = false
    end

    true
  end
  alias << push

  def get_task finish_at
    current_time = Time.new

    quick_extract_task do |task|
      task.finish_at < current_time || task.finish_at == finish_at
    end
  end

  def pop
    current_time = Time.new

    quick_extract_task do |task|
      task.finish_at < current_time
    end
  end

  private
  # base extract
  def extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      if @list_sorted == false
        @list.sort_by!{|task| task.finish_at}
        @list_sorted = true
      end

      valid = yield(@list[0])

      if valid
        @list.delete_at(0)
      else
        nil
      end
    end
  end

  # quick extract
  def quick_extract_task
    return nil if @list.empty?

    @mutex.synchronize do
      finish_at, task_id = nil, nil
      @list.each_with_index do |task, i|
        if yield(task)
          if finish_at.nil?
            finish_at = task.finish_at
            task_id = i
          else
            if task.finish_at < finish_at
              finish_at = task.finish_at
              task_id = i
            end
          end
        end
      end

      @list.delete_at(task_id) if task_id
    end
  end

  def valid? task
    task.class == Task
  end
end