require 'date'
require 'nokogiri'
require 'pp'

class PivotalPing
  class PivotalStory
    attr_reader :id, :url, :state, :integration_id, :other_id

    def initialize(xml)
      @id    = xml.xpath('id').first.content.to_i
      @url   = xml.xpath('url').first.content
      @state = xml.xpath('current_state').first.content rescue ''
      @integration_id = xml.xpath('integration_id').first.content.to_i rescue nil
      @other_id = xml.xpath('other_id').first.content rescue nil
    end

    def to_hash
      { :id => @id,
        :url => @url,
        :current_state => @state
      }
    end
  end

  attr_reader :id, :version, :event_type, :occurred_at, :author, :project_id, :description, :stories

  def initialize(post_string)
    xml = Nokogiri.XML(post_string)
    @id          = xml.xpath('activity/id').first.content.to_i
    @version     = xml.xpath('activity/version').first.content.to_i
    @event_type  = xml.xpath('activity/event_type').first.content
    @occurred_at = DateTime.parse(xml.xpath('activity/occurred_at').first.content)
    @author      = xml.xpath('activity/author').first.content
    @project_id  = xml.xpath('activity/project_id').first.content.to_i
    @description = xml.xpath('activity/description').first.content
    @stories = xml.xpath('activity/stories/story').map{|x|PivotalStory.new(x)}
  end

  def story_ids
    @stories.map{|e|e.id}
  end

  def to_hash
    { :id => @id,
      :version => @version,
      :event_type => @event_type,
      :occurred_at => @occurred_at.to_s,
      :author => @author,
      :project_id => @project_id,
      :description => @description,
      :stories => @stories.map{|e|e.to_hash}
    }
  end

  # Did someone just edit the story?
  def edit?
    @description =~ /^[^"].*edited "/
  end
end

