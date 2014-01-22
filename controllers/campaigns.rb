class Application < Sinatra::Application

  # Display a banner for the given campaign id.
  # Because the resulted banner depends on the historical data and will be
  # different for every request - the response should expire immediately.
  # That's why the response is a 302 Moved Temporary redirect
  # to the actual banner, which will be cacheable.
  get '/campaigns/:campaign_id' do |campaign_id|
    response['Cache-Control'] = "no-cache, must-revalidate"
    halt 404 unless campaign_id =~ /^\d+$/ # Not Found
    campaign = Campaign.get_by_id(campaign_id.to_i)
    halt 404 unless campaign # Not Found
    if session.has_key? campaign_id
      last_shown_banner_id = session[campaign_id]
    else
      last_shown_banner_id = nil
    end
    banner_id = campaign.get_banner_id last_shown_banner_id
    halt 204 unless banner_id # No Content
    session[campaign_id] = banner_id
    redirect to("/banners/#{banner_id}")
  end

end
