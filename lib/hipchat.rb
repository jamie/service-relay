# encoding: utf-8

class Hipchat
  # http://daringfireball.net/2010/07/improved_regex_for_matching_urls
  # modified to check that we're not inside a link already with (?<!href=")
  URL_REGEX = %r{(?<![">])(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}

  def initialize(token, room)
    @token = token
    @room = room.gsub('_', ' ')
  end

  def hipchat
    @hipchat ||= HipChat::Client.new(@token)
  end

  def format_message(msg)
    msg.
      gsub(URL_REGEX, '<a href="\1">\1</a>').
      gsub(/(^|\s)\*(.*\w.*)\*(\s|$)/, '\1<strong>\2</strong>\3')
  end

  def send(speaker, message, opts = {})
    message = format_message(message) unless message =~ /<[a-z]+/
    if opts && opts[:color] && !%w(yellow red green purple random).include?(opts[:color])
      raise ArgumentError, "Invalid message color: #{opts[:color]}"
    end
    hipchat[@room].send(speaker, message, opts)
  end

end
