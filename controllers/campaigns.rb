class Application < Sinatra::Application

  # Display a banner for the given campaign id.
  # Because the resulted banner depends on the historical data and will be
  # different for every request - the response should expire immediately.
  # That's why the response is a 302 Moved Temporary redirect
  # to the actual banner, which will be cacheable.
  get '/campaigns/:campaign_id' do |campaign_id|
    response['Cache-Control'] = "no-cache, must-revalidate"
    campaign = get_campaign(campaign_id)
    halt 404 unless campaign # Not Found
    target_banner_id = get_target_banner_id(campaign)
    halt 204 unless target_banner_id # No Content
    redirect to("/banners/#{target_banner_id}")
  end

  private

  def get_campaign(campaign_id)
    Campaign.get_by_id(campaign_id.to_i) if campaign_id =~ /^\d+$/
  end

  def get_target_banner_id(campaign)
    if session.has_key? campaign.id
      last_shown_banner_id = session[campaign.id]
    else
      last_shown_banner_id = nil
    end
    target_banner_id = campaign.get_banner_id last_shown_banner_id
    session[campaign.id] = target_banner_id if target_banner_id
    target_banner_id
  end

end
