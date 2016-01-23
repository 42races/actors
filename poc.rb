class MailBox
  def initialize
    @entries = []
  end

  def enqueue(item)
    if item.respond_to? :process
      @entries.push(item)
    else
      puts "Item can't be enqueued as it does not respond to process"
    end
  end

  def dequeue
    @entries.shift
  end

  def empty?
    @entries.empty?
  end

  def length
    @entries.size
  end

  alias_method :count, :length
end

# anything that respond to process is a messgae
# Example
# class Work
#   # ....
#   # ...
#   # must implement a process method
#   def process
#     # write implementation here
#   end
# end

class Message

  STATES = %w(pending started finished failed)

  STATES.each do |st|
    define_method "#{st}?" do
      self.status == st
    end
  end

  def initialize(text)
    @text = text
    @status = 'pending'
  end

  def status
    @status
  end

  def start!
    started! if self.pending?
  end

  def finish!
    finished! if self.started?
  end

  def fail!
    failed! if self.started?
  end

  def processed?
    !pending?
  end

  def process
    puts "Processing message #{@text}"
  end

  private

  STATES.each do |st|
    define_method "#{st}!" do
      @status = st
    end
  end
end

class Actor
  def initialize
    @mailbox = MailBox.new
    @running = false
  end

  def mailbox
    @mailbox
  end

  def send_message(message)
    mailbox.enqueue(message)
  end

  def running?
    @running
  end

  def run
    return if running?
    run_actor
  end

  private

  def run_actor
    @running = true

    Thread.new do
      loop do

        if mailbox.empty?
          sleep(1)
          next
        end

        message = mailbox.dequeue

        begin
          message.start!
          message.process
          message.finish!
        rescue Exception => e
          message.fail!
          puts e.backtrace
        end
      end
    end
  end
end

class Supervisor
  def initialize()
    @address_pool = { default: [] }
  end

  def send_message(address, msg)
  end
end
