require './test/test_helper'
require './lib/hipchat'

describe Hipchat do
  before do
    @hipchat = Hipchat.new('','')
  end

  describe :format_message do
    it "links urls" do
      msg = "http://example.com"
      expected = '<a href="http://example.com">http://example.com</a>'
      @hipchat.format_message(msg).must_equal expected
    end

    it "bolds" do
      {
        'hi *you*' => 'hi <strong>you</strong>',
        '*hi* you' => '<strong>hi</strong> you',
        '*hello*' => '<strong>hello</strong>',
        'Look* *out' => 'Look* *out',
        'Woo **hoo** yeah!' => 'Woo <strong>*hoo*</strong> yeah!',
        'and *multi words* too' => 'and <strong>multi words</strong> too'
      }.each do |msg, expected|
        @hipchat.format_message(msg).must_equal expected
      end
    end
  end
end

