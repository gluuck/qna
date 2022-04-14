class SearchController < ApplicationController

  def search
    service = SearchService.new(search_params)
    @result = service.call
    render turbo_stream: turbo_stream.update('search_result',partial: 'search/search', locals:{result: @result})
  end

  private

  def search_params
    params.permit(:search_body, :type, :commit)
  end
end