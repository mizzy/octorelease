require "octorelease/version"
require "hub"
require "bundler/gem_helper"
require "octokit"

desc "Release gem and create a release on GitHub"
task "octorelease" => "release" do
  config_file = ENV['HUB_CONFIG'] || '~/.config/hub'
  file_store  = Hub::GitHubAPI::FileStore.new File.expand_path(config_file)
  file_config = Hub::GitHubAPI::Configuration.new file_store
  github_api  = Hub::GitHubAPI.new(
    file_config,
    :app_url => 'http://hub.github.com/'
  )
  user  = github_api.config.username("github.com")
  token = github_api.config.oauth_token("github.com", user)

  Octokit.configure do |c|
    c.login        = user
    c.access_token = token
  end

  current_version  = "v#{Bundler::GemHelper.new.gemspec.version.to_s}"
  previous_version = ""
  `git tag`.split(/\n/).each do |tag|
    break if tag == current_version
    previous_version = tag
  end

  log = `git log #{previous_version}..#{current_version} --grep=Merge`

  repo = `git remote -v | grep origin`.match(/([\w-]+\/[\w-]+)\.git/)[1]

  description = []
  log.split(/commit/).each do |lines|
    lines.match(/Merge pull request \#(\d+)/) do |m|
      url = "https://github.com/#{repo}/pull/#{m[1]}"
      title = Octokit.pull_request(repo, m[1]).title
      description << "* [#{title}](#{url})"
    end
  end

  Octokit.create_release(
    repo,
    current_version,
    {:body => description.join("\n")}
  )

  Bundler.ui.confirm "Release #{current_version} created."
  Bundler.ui.confirm "https://github.com/#{repo}/releases/tag/#{current_version}"
end
