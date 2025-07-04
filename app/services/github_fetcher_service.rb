require 'net/http'
require 'uri'
require 'json'

class GithubFetcherService
  GITHUB_API_BASE_URL = "https://api.github.com"
  # IMPORTANT: Replace 'YOUR_GITHUB_ACCESS_TOKEN' with your actual GitHub Personal Access Token.
  # This should ideally be loaded from Rails credentials or environment variables for security.
  GITHUB_ACCESS_TOKEN = ENV.fetch('GITHUB_ACCESS_TOKEN', 'YOUR_GITHUB_ACCESS_TOKEN')

  def self.call(creator)
    github_username = creator.github_username
    total_commits = 0

    unless GITHUB_ACCESS_TOKEN && GITHUB_ACCESS_TOKEN != 'YOUR_GITHUB_ACCESS_TOKEN'
      return { success: false, error: "GitHub Access Token is not configured." }
    end

    begin
      repos = fetch_user_repos(github_username)
      repos.each do |repo|
        commits_in_repo = fetch_repo_commits(repo["owner"]["login"], repo["name"])
        total_commits += commits_in_repo
      end

      { success: true, commits_count: total_commits }
    rescue StandardError => e
      { success: false, error: "Error fetching GitHub data: #{e.message}" }
    end
  end

  private

  def self.fetch_user_repos(username)
    uri = URI("#{GITHUB_API_BASE_URL}/users/#{username}/repos")
    make_github_api_request(uri)
  end

  def self.fetch_repo_commits(owner, repo_name)
    uri = URI("#{GITHUB_API_BASE_URL}/repos/#{owner}/#{repo_name}/commits?per_page=1") # Fetching 1 commit per page to get total count from Link header
    response_headers = make_github_api_request(uri, return_headers: true)

    # Extract total pages from Link header for pagination
    link_header = response_headers['link']
    if link_header
      last_page_match = link_header.match(/<[^>]+[?&]page=(\d+)>; rel="last"/)
      total_pages = last_page_match ? last_page_match[1].to_i : 1
    else
      total_pages = 1
    end

    # For simplicity, we're just returning the total number of commits based on the last page number.
    # A more robust solution would iterate through all pages if actual commit data is needed.
    total_pages
  end

  def self.make_github_api_request(uri, return_headers: false)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "token #{GITHUB_ACCESS_TOKEN}"
    request['Accept'] = 'application/vnd.github.v3+json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      error_message = JSON.parse(response.body)['message'] rescue "Unknown GitHub API error"
      raise "GitHub API Error (Status: #{response.code}): #{error_message}"
    end

    if return_headers
      response.each_header.to_h
    else
      JSON.parse(response.body)
    end
  end
end