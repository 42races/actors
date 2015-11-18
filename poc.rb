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
  def initialize(text)
    @text = text
  end

  def process
    puts "START"
    puts "Processing message #{@text}"
    puts "END"
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
          message.process
        rescue Exception => e
          puts e.backtrace
        end
      end
    end
  end
end
