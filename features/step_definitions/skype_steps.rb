Given /^I am using the Skype Api testing fake$/ do
  # Silence constant re-assignment warning.
  original_verbosity = $VERBOSE
  $VERBOSE = nil
  Rype::Api = Rype::FakeApi
  $VERBOSE = original_verbosity
end

Given /^there is a chat with id "([^\"]*)"$/ do |chat_id|
  # Let's assume it exists.
end

Given /^a client has registered a callback for notifications about "([^\"]*)"$/ do |scope|
  @callback = lambda do
    if @called
      @called
    else
      @called = true
      false
    end
  end
  Rype::Api.on_notification(scope, @callback)
end

When /^I send a chatmessage "([^\"]*)" to "([^\"]*)"$/ do |message_body, chat_id|
  Rype::Chat.new(chat_id).send_message(message_body)
end

When /^Skype issues a notification "([^\"]*)"$/ do |notification|
  Rype::Api.notify(notification)
end

Then /^the Skype Api should receive the message$/ do |string|
  Rype::Api.recorded_messages.should include(string)
end

Then /^the callback should be called$/ do
  @callback.call.should be_true
end
