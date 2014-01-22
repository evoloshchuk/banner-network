require_relative '../libs/init'
require_relative '../models/init'

# This job updates campaign's banners to be displayed based on the data
# from the provided files.
class UpdateJob

  # Public: Parse given files and process the data in order to update campaigns
  # with banners to be displayed,
  #
  # impressions_fn - A filename of CSV-file with impressions data.
  # clicks_fn - A filename of CSV-file with clicks data.
  # conversions_fn -A filename of CSV-file with conversions data.
  def self.perform(impressions_fn, clicks_fn, conversions_fn)
    impressions = Parser.parse_filenames(
        impressions_fn, clicks_fn, conversions_fn)
    campaigns_banners = Processor.process_impressions(impressions)
    campaigns_banners.each do |campaign_id, banner_ids|
      campaign = Campaign.get_by_id campaign_id
      if campaign
        campaign.update(banner_ids)
      end
    end
  end

end
