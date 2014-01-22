require_relative "../spec_helper"
require 'tempfile'

describe UpdateJob do

  context "job has not been run yet" do
    it "campaign has no banners" do
      Campaign.get_by_id(1).get_banner_id.should be_nil
    end
  end

  context "job has been run" do
    before do
      @impressions_f = Tempfile.new("impressions")
      @impressions_f.write("banner_id,campaign_id\n100,1\n")
      @impressions_f.close

      @clicks_f = Tempfile.new("clicks")
      @clicks_f.write("click_id,banner_id,campaign_id\n1,100,1\n")
      @clicks_f.close

      @conversions_f = Tempfile.new("conversions")
      @conversions_f.write("conversion_id,click_id,revenue\n1,1,1\n")
      @conversions_f.close

      UpdateJob.perform(@impressions_f.path,
                        @clicks_f.path,
                        @conversions_f.path)
    end
    it "campaign has banners" do
      Campaign.get_by_id(1).get_banner_id.should eql 100
    end
  end

end
