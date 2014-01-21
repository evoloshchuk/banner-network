# encoding: utf-8

module Processor

  def self.process_impressions(impressions)
    impressions.map do |campaign_id, data|
      data = data.sort_by {|k, v| [v[:revenue], v[:clicks]]}.reverse
      banner_ids = []
      banner_cnt = 0
      data.each do |row|
        if row[1][:revenue] > 0
          banner_ids.push(row[0])
          banner_cnt += 1
          if banner_cnt == 10
            break
          end
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
