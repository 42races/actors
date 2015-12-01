require_relative "poc"

require 'minitest/autorun'
require 'pry'


describe Message do

  let(:msg) { Message.new("test") }

  it 'respond to process' do
    assert msg.respond_to? :process
  end

  it 'respond to status' do
    assert msg.respond_to?(:status)
  end

  it 'will be pending by default' do
    assert msg.pending?
  end

  it 'will be moved to started state' do
    msg.start!
    assert msg.started?
  end
end

describe MailBox do

  let(:mailbox) { MailBox.new }

  it 'respond to enqueue' do
    assert mailbox.respond_to? :enqueue
  end

  it 'respond to dequeue' do
    assert mailbox.respond_to? :dequeue
  end

  it 'respond to empty?' do
    assert mailbox.respond_to? :empty?
  end

  it 'respond to lenght' do
    assert mailbox.respond_to? :length
  end

  it 'respond to count' do
    assert mailbox.respond_to? :count
  end

  it 'has 0 messages by default' do
    assert_equal 0, mailbox.count
  end

  it 'has one message on enqueueing a message' do
    msg = Message.new('test')
    mailbox.enqueue(msg)
    assert_equal 1, mailbox.length
  end

  it 'has zero message on dequeue after enqueuing' do
    msg = Message.new('test')
    mailbox.enqueue(msg)
    mailbox.dequeue
    assert_equal 0, mailbox.length
  end

  it 'does not enquue messaage if the message does not respond to process' do
    msg = Class.new.new
    mailbox.enqueue(msg)
    assert_equal 0, mailbox.length
  end
end

describe Actor do

  let(:actor) { Actor.new }

  it 'initialize an actor with running status false' do
    assert !actor.running?
  end

  it 'initialize a mailbox with 0 messages' do
    assert 0, actor.mailbox.count
  end

  it 'respond to run' do
    assert actor.respond_to? :run
  end

  it 'respond to send_message' do
    assert actor.respond_to? :send_message
  end

  it 'can moves to a running state on run' do
    actor.run
    assert actor.running?
  end

  it 'processess the messages on sending a message' do
    actor.run
    msg = Message.new('test')
    actor.send_message(msg)
    sleep(1) # wait for the actor to process the message
    assert msg.processed?
  end

end
