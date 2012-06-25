require './test/test_helper'
require './lib/pivotal_ping'

class PivotalPing
  attr_writer :description
end

STORY_UPDATE = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<activity>
  <id type="integer">182280221</id>
  <version type="integer">10</version>
  <event_type>story_update</event_type>
  <occurred_at type="datetime">2012/04/10 16:34:17 UTC</occurred_at>
  <author>Jamie Macey</author>
  <project_id type="integer">519145</project_id>
  <description>Jamie Macey edited &quot;test one&quot;</description>
  <stories type="array">
    <story>
      <id type="integer">27783807</id>
      <url>http://www.pivotaltracker.com/services/v3/projects/519145/stories/27783807</url>
      <current_state>unscheduled</current_state>
    </story>
  </stories>
</activity>
XML

NOTE_CREATE = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<activity>
  <id type="integer">212616375</id>
  <version type="integer">1684</version>
  <event_type>note_create</event_type>
  <occurred_at type="datetime">2012/06/25 18:59:47 UTC</occurred_at>
  <author>Jamie Macey</author>
  <project_id type="integer">519145</project_id>
  <description>Jamie Macey added comment: &quot;test&quot;</description>
  <stories type="array">
    <story>
      <id type="integer">27783807</id>
      <url>http://www.pivotaltracker.com/services/v3/projects/519145/stories/27783807</url>
      <current_state></current_state>
    </story>
  </stories>
</activity>
XML

describe PivotalPing do
  before do
    @ping = PivotalPing.new(STORY_UPDATE)
  end

  it "converts to hash" do
    @ping.to_hash.must_equal({
      :id => 182280221,
      :version => 10,
      :event_type => 'story_update',
      :occurred_at => DateTime.new(2012, 4, 10, 16, 34, 17).to_s,
      :author => 'Jamie Macey',
      :project_id => 519145,
      :description => 'Jamie Macey edited "test one"',
      :stories => [
        {:id => 27783807, :current_state => "unscheduled", :url => "http://www.pivotaltracker.com/services/v3/projects/519145/stories/27783807"}
      ]
    })
  end

  describe :edit? do
    it "detects edits" do
      @ping.must_be :edited?
    end

    it "detects non-edits" do
      @ping.description = 'Jamie Macey started "a story"'
      @ping.wont_be :edited?
    end
  end
end

