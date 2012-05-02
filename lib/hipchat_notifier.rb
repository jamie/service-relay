class HipchatNotifier
  def process(update)
    return if update.description =~ /^[^"].*edited "/
    send(update.description)
  end

  def send(message)
    hipchat = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    room = ENV['HIPCHAT_ROOM'].gsub('_', ' ')
    hipchat[room].send('Pivotal Tracker', message)
  end
end
