# Public: Module responsible for deciding which banners to choose for campaigns
# based on the provided impressions data.
module Processor

  # Public: Process given impressions and return campaign's banners.
  #
  # impressions - A impressions Hash - a Hash with keys being campaign ids
  #               and values being campaign performance Hashes.
  #               A campaign performance Hash - a Hash with keys being banner
  #               ids and values being banner performance Hashes.
  #               A banner performance Hash - a Hash with keys :revenue and
  #               :clicks and corresponding values.
  #
  # Example
  #   Processor.process_impressions(
  #     {
  #       1 => {
  #         100 => {:revenue => 1.2, :clicks => 223},
  #         101 => {:revenue => 0, :clicks => 45}
  #       }
  #     })
  #   # => [[1, [100, 101]]]
  #
  #
  # Returns - An campaign's banners Array - An Array of campaign Arrays.
  #           A campaign Array - an Array with two elements: campaign id and
  #           an Array of banners ids.
  def self.process_impressions(impressions)
    impressions.map do |campaign_id, data|
      data = data.sort_by {|k, v| [v[:revenue], v[:clicks]]}.reverse
      banner_ids = []
      banner_cnt = 0
      data.each do |row|
        if row[1][:revenue] > 0
          banner_ids.push(row[0])
          banner_cnt += 1
          break if banner_cnt == 10
        elsif banner_cnt < 5
          banner_ids.push(row[0])
          banner_cnt += 1
        else
          break
        end
      end
      [campaign_id, banner_ids]
    end
  end

end
