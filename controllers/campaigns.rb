# encoding: utf-8

class Application < Sinatra::Application

  # Display a banner for the given campaign id.
  # Because the resulted banner depends on the historical data and will be
  # different for every request - the response should expire immediately.
  # That's why the response is a 302 Moved Temporary redirect
  # to the actual banner, which will be cacheable.
  get '/campaigns/:campaign_id' do |campaign_id|
    response['Cache-Control'] = "no-cache, must-revalidate"
    if campaign_id =~ /^\d+$/
      campaign = Campaign.get_by_id(campaign_id.to_i)
      if campaign
        banner_id = campaign.get_banner_id
        if banner_id
          redirect to("/banners/#{banner_id}")
        else
          204 # No Content
        end
      else
        404 # Not Found
      end
    else
      404 # Not Found
    end
  end

end
