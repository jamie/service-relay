require './test/test_helper'
require './lib/github'
require './lib/load_dev_env'

describe Github do
  before do
    @repo_name = ENV['GITHUB_REPO']
    @github = Github.new(ENV['GITHUB_TOKEN'], @repo_name)
  end

  describe :branches do
    it "includes master" do
      @github.branches.keys.must_include 'master'
    end
  end

  describe :create_branch do
    it "creates the ref" do
      @github.expects(:branches).returns('master' => 'abcdef')
      @github.expects(:post).with do |url, opts|
        url == "/repos/#{@repo_name}/git/refs" &&
        JSON.parse(opts[:body]) == {'ref'=>'refs/heads/this-is-a-test', 'sha'=>'abcdef'}
      end

      @github.create_branch('this-is-a-test')
    end

    it "sanitizes the branch name" do
      @github.expects(:branches).returns('master' => 'abcdef')
      @github.expects(:post).with do |url, opts|
        JSON.parse(opts[:body])['ref'] == 'refs/heads/this-is-a-test'
      end

      @github.create_branch(' This is! (a test 123) ')
    end
  end
end

