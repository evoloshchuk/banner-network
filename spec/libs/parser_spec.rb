# encoding: utf-8

require_relative '../spec_helper'

describe Parser do

  before do
    impressions_arr = [ # [banner_id, campaign_d_id]
        [101, 1001], [102, 1001], [103, 1001], [104, 1001], [105, 1001],
        [101, 1002], [102, 1002], [103, 1002], [104, 1002], [105, 1002],
        [101, 1003], [102, 1003], [103, 1003], [104, 1003], [105, 1003]]
    clicks_arr = [ # [click_id,banner_id,campaign_id]
        [1, 101, 1001], [2, 101, 1001], [3, 102, 1001], [4, 103, 1001],
        [5, 104, 1001], [6, 105, 1001], [7, 105, 1001], [8, 105, 1001],
        [9, 105, 1001], [10, 105, 1001], [11, 101, 1002], [12, 101, 1002],
        [13, 101, 1002], [14, 102, 1002], [15,102,1002]]
    conversions_arr = [ # [conversion_id,click_id,revenue]
        [1, 1, 0.7], [2, 2, 0.3], [3, 4, 0.5]]

    def to_csv(arr)
      arr = arr.map { |row| row.join(',') }
      arr.join("\n")
    end

    @impressions_str = "banner_id,campaign_id\n" + to_csv(impressions_arr)
    @clicks_str = "conversion_id,click_id,revenue\n" + to_csv(conversions_arr)
    @conversions_str = "click_id,banner_id,campaign_id\n" + to_csv(clicks_arr)

    @expected_impressions = {
        1001 => {
            101 => {:revenue => 1, :clicks => 2},
            102 => {:revenue => 0, :clicks => 1},
            103 => {:revenue => 0.5, :clicks => 1},
            104 => {:revenue => 0, :clicks => 1},
            105 => {:revenue => 0, :clicks => 5},
        },
        1002 => {
            101 => {:revenue => 0, :clicks => 3},
            102 => {:revenue => 0, :clicks => 2},
            103 => {:revenue => 0, :clicks => 0},
            104 => {:revenue => 0, :clicks => 0},
            105 => {:revenue => 0, :clicks => 0},
        },
        1003 => {
            101 => {:revenue => 0, :clicks => 0},
            102 => {:revenue => 0, :clicks => 0},
            103 => {:revenue => 0, :clicks => 0},
            104 => {:revenue => 0, :clicks => 0},
            105 => {:revenue => 0, :clicks => 0},
        },
    }
  end

  describe  ".parse_ios(impressions_io, conversions_io, clicks_io)" do
    subject { Parser.parse_ios(impressions_io, conversions_io, clicks_io) }
    let(:impressions_io) { StringIO.new(@impressions_str) }
    let(:conversions_io) { StringIO.new(@clicks_str) }
    let(:clicks_io) { StringIO.new(@conversions_str) }
    it { should == @expected_impressions }
  end

end
