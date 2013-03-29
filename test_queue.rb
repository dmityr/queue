require "minitest/autorun"
require "./queue"
require "./task"

class TestQueue < MiniTest::Unit::TestCase
  def setup
    @queue = Queue.new
  end

  def test_push_incorrect_value_to_queue
    types = [1, "Test", true, [], {}]

    types.each do |type|
      assert_raises QueueException do
        @queue << type
      end
    end
  end

  def test_push_correct_value_to_queue
    assert_equal true, @queue.push(Task.new(Time.new, "test"))
  end

  def test_get_task
    @queue << Task.new(Time.new(2010, 1, 1), "Hej! I am outdate task")

    assert_equal true, @queue.pop.is_a?(Task)
  end

  def test_outdated_task
    tasks = []

    # create task with known time
    known_time = Time.new + 3600
    known_task = Task.new(known_time, "Task with known time")
    tasks << known_task

    #generate actual tasks
    100.times do |i|
      tasks << Task.new(Time.new + 3600*24*(1+rand(20)), "Typical Task_#{i} in the future")
    end

    # create outdated tasks
    task_1 = Task.new(Time.new(2010, 1, 1), "Hej! I am outdate task")
    task_2 = Task.new(Time.new(2010, 1, 2), "Hey! I am outdated task too")


    tasks << task_1
    tasks << task_2

    tasks.shuffle.each{|t| @queue << t}

    assert_equal task_1, @queue.pop
    assert_equal task_2, @queue.get_task(known_time)
    assert_equal known_task, @queue.get_task(known_time)
  end

  def test_empty_queue
    known_time = Time.new + 3600

    assert_equal nil, @queue.get_task(known_time)
    assert_equal nil, @queue.pop
  end

  def test_wo_outdated
    known_time = Time.new + 3600

    10.times do |i|
      @queue << Task.new(Time.new + 3600*(2+rand(4)), "Task_#{i}")
    end

    assert_equal nil, @queue.get_task(known_time)
    assert_equal nil, @queue.pop
  end

  def test_count_task_after_get_task
    time_1 = Time.new - 3600
    task_1 = Task.new(time_1, "Old task")

    time_2 = Time.new - 3600*2
    task_2 = Task.new(time_2, "Very old task")

    @queue << task_1
    @queue << task_2

    assert_equal 2, @queue.list.size
    assert_equal task_2, @queue.get_task(time_2)
    assert_equal 1, @queue.list.size
    assert_equal task_1, @queue.get_task(time_1)
    assert_equal 0, @queue.list.size
    assert_equal nil, @queue.pop
  end

  def test_count_task_after_pop
    task_1 = Task.new(Time.new - 3600, "Old task")
    task_2 = Task.new(Time.new - 3600*2, "Very old task")
    @queue << task_1
    @queue << task_2

    assert_equal 2, @queue.list.size
    assert_equal task_2, @queue.pop
    assert_equal 1, @queue.list.size
    assert_equal task_1, @queue.pop
    assert_equal 0, @queue.list.size
    assert_equal nil, @queue.pop
  end
end