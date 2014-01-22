require "csv"

# Public: Module responsible for building a impressions Hash by parsing
# impressions, clicks and conversion data provided in CVS format.
module Parser

  # Public: Parse given files to build a impressions Hash.
  #
  # impressions_fn - A filename of CSV-file with impressions data.
  # clicks_fn - A filename of CSV-file with clicks data.
  # conversions_fn -A filename of CSV-file with conversions data.
  #
  # Example
  #   File.read("impressions.csv")
  #   # => "banner_id,campaign_id\n100,1\n"
  #   File.read("clicks.csv")
  #   # => "click_id,banner_id,campaign_id\n1,100,1\n"
  #   File.read("conversions.csv")
  #   # => "conversion_id,click_id,revenue\n1,1,1\n"
  #   Parser.parse_filenames("impressions.csv", "clicks.csv", "conversions.csv")
  #   # =>
  #     {
  #       1 => {
  #         100 => {:revenue => 1.2, :clicks => 223},
  #         101 => {:revenue => 0, :clicks => 45}
  #       }
  #     })
  #   # => [[1, [100, 101]]]
  #
  # Returns - A impressions Hash - a Hash with keys being campaign ids
  #           and values being campaign performance Hashes.
  #           A campaign performance Hash - a Hash with keys being banner
  #           ids and values being banner performance Hashes.
  #           A banner performance Hash - a Hash with keys :revenue and
  #           :clicks and corresponding values.
  def self.parse_filenames(impressions_fn, clicks_fn, conversions_fn)
    parser = CsvParser.new(File.open(impressions_fn),
                           File.open(clicks_fn),
                           File.open(conversions_fn))
    parser.parse
  end

  # Internal: CSV data files parser.
  class CsvParser

    # Internal: Initialize a CsvParser.
    #
    # impressions_io - An IO object with impressions data.
    # clicks_io - An IO object with clicks data.
    # conversions_io - An IO object with conversions data.
    def initialize(impressions_io, clicks_io, conversions_io)
      options = {:headers => :first_row, :return_headers => false}
      @impressions_csv = CSV.new(impressions_io, options)
      @clicks_csv = CSV.new(clicks_io, options)
      @conversions_csv = CSV.new(conversions_io, options)
    end

    # Public: Parse the CSV IO and build a an impressions Hash.
    #
    # Returns - An impressions Hash.
    def parse
      impressions = {}

      impressions do |campaign_id, banner_id|
        unless impressions.has_key? campaign_id
          impressions[campaign_id] = {}
        end
        impressions[campaign_id][banner_id] = {:clicks => 0, :revenue => 0}
      end

      conversions = Hash.new(0)
      conversions do |click_id, revenue|
        conversions[click_id] = revenue
      end

      clicks do |campaign_id, banner_id, click_id|
        impressions[campaign_id][banner_id][:clicks] += 1
        impressions[campaign_id][banner_id][:revenue] += conversions[click_id]
      end

      impressions
    end

    private

    # Internal: Reads conversions data row by row from csv file.
    def conversions
      @conversions_csv.each do |row|
        yield row['click_id'].to_i, row['revenue'].to_f
      end
    end

    # Internal: Reads impressions data row by row from csv file.
    def impressions
      @impressions_csv.each do |row|
        yield row['campaign_id'].to_i, row['banner_id'].to_i
      end
    end

    # Internal: Reads click data row by row from csv file.
    def clicks
      @clicks_csv.each do |row|
        yield row['campaign_id'].to_i, row['banner_id'].to_i,
            row['click_id'].to_i
      end
    end

  end

end
