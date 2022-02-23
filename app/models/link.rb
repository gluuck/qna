class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::regexp(%w[http https]), content: 'is invalid' }

  def gist?
    !URI(url).host.nil? && URI(url).host.include?('gist')
  end

  def open_gist
    http_client = Octokit::Client.new
    http_client.gist(URI(url).path.split('/').last).files
  end
end
