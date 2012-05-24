# encoding: utf-8

class Hipchat
  # http://daringfireball.net/2010/07/improved_regex_for_matching_urls
  URL_REGEX = %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}

  def initialize(token, room)
    @token = token
    @room = room.gsub('_', ' ')
  end

  def hipchat
    @hipchat ||= HipChat::Client.new(@token)
  end

  def room
    @room ||= hipchat[@room]
  end

  def format_message(msg)
    msg.
      gsub(URL_REGEX, '<a href="\1">\1</a>').
      gsub(/(^|\s)\*(.*\w.*)\*(\s|$)/, '\1<strong>\2</strong>\3')
  end

  def send(speaker, message, color='yellow')
    message = format_message(message) unless message =~ /<(a-z)+>/
    room.send(speaker, message)
  end

end
