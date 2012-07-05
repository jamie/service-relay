require 'builder'
require 'time'

class SalesforcePivotalFormatter
  def initialize(cases)
    @cases = cases
  end

  def story_type(k)
    { 'Escalated--Defect'  => 'bug',
      'Escalated--Feature' => 'feature',
      'Escalated--Task'    => 'chore'
    }[k]
  end

  def format_timestamp(string)
    Time.parse(string).strftime('%Y/%m/%d %H:%M:%S UTC')
  end

  def to_xml
    builder = Builder::XmlMarkup.new(:indent => 2)
    builder.instruct! :xml, :version => '1.0'
    builder.external_stories(:type => 'array') do |x|
      @cases.each do |c|
        next unless story_type(c['Status'])
        x.external_story do |story|
          story.external_id c['Id']
          story.name c['Subject']
          story.description c['Developer_Instructions__c']
          story.requested_by([c['SuppliedCompany'], c['SuppliedName'], c['Partner_Relationship__c']].compact.join(' / '))
          story.created_at(format_timestamp(c['CreatedDate']), :type => 'datetime')
          story.story_type story_type(c['Status'])
          story.estimate -1, :type => 'integer'
        end
      end
    end
  end
end

