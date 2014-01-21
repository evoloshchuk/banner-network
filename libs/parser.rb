# encoding: utf-8

require "csv"

module Parser

  def self.parse_filenames(impressions_fn, conversions_fn, clicks_fn)
    parse_ios(File.open(impressions_fn),
              File.open(conversions_fn),
              File.open(clicks_fn))
  end

  def self.parse_ios(impressions_io, conversions_io, clicks_io)
    csv_options = {:headers => :first_row, :return_headers => false}
    parse_csv(CSV.new(impressions_io, csv_options),
              CSV.new(conversions_io, csv_options),
              CSV.new(clicks_io, csv_options))
  end

  def self.parse_csv(impressions_csv, conversions_csv, clicks_csv)
    impressions = {}

    parse_impressions_csv(impressions_csv) do |campaign_id, banner_id|
      unless impressions.has_key? campaign_id
        impressions[campaign_id] = {}
      end
      impressions[campaign_id][banner_id] = {:clicks => 0, :revenue => 0}
    end

    conversions = Hash.new(0)
    parse_conversions_csv(conversions_csv) do |click_id, revenue|
      conversions[click_id] = revenue
    end

    parse_clicks_csv(clicks_csv) do |campaign_id, banner_id, click_id|
      impressions[campaign_id][banner_id][:clicks] += 1
      impressions[campaign_id][banner_id][:revenue] += conversions[click_id]
    end

    impressions
  end

  def self.parse_conversions_csv(input_csv)
    input_csv.each do |row|
      yield row['click_id'].to_i, row['revenue'].to_f
    end
  end

  def self.parse_impressions_csv(input_csv)
    input_csv.each do |row|
      yield row['campaign_id'].to_i, row['banner_id'].to_i
    end
  end

  def self.parse_clicks_csv(input_csv)
    input_csv.each do |row|
      yield row['campaign_id'].to_i, row['banner_id'].to_i, row['click_id'].to_i
    end
  end

end
