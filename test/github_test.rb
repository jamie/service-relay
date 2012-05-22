require './test/test_helper'
require './lib/github'
require './lib/load_dev_env'

describe Github do
  before do
    @github = Github.new(ENV['GITHUB_TOKEN'], ENV['GITHUB_REPO'])
  end

  describe :branches do
    it "includes master" do
      @github.branches.must_include 'master'
    end
  end
end

