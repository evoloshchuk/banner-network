# encoding: utf-8

require_relative '../libs/init'
require_relative '../models/init'

class UpdateJob

  def self.perform(impressions_fn, conversions_fn,  clicks_fn)
    puts "Processing #{impressions_fn} #{conversions_fn} #{clicks_fn} files"

    impressions = Parser.parse_filenames(
        impressions_fn, conversions_fn, clicks_fn)
    campaigns_banners = Processor.process_impressions(impressions)
    campaigns_banners.each do |campaign_id, banner_ids|
      campaign = Campaign.get_by_id campaign_id
      if campaign
        campaign.update(banner_ids)
      end
    end
  end

end
