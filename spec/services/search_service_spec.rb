require 'rails_helper'

RSpec.describe SphinxSearchService do
  it 'have method call' do
    SearchService.new(search_body: 'object', type: 'Question').call
  end
end