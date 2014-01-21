# encoding: utf-8

require_relative "../spec_helper"

describe "GET '/campaign/:campaign_id'" do

  cache_control = 'no-cache, must-revalidate'

  context "an existing campaign with data available" do
    before do
      campaign = Campaign.get_by_id 1
      campaign.update([150])
      campaign = Campaign.get_by_id 2
      campaign.update([160, 170])
    end
    it "redirects to the banner page" do
      get "/campaigns/1"
      last_response.status.should == 302
      last_response.headers['Cache-Control'].should == cache_control
      last_response.location.should include "/banners/150"
    end
    it "redirects to the banner page" do
      get "/campaigns/2"
      last_response.status.should == 302
      last_response.headers['Cache-Control'].should == cache_control
      last_response.location.should match "/banners/1[67]0"
    end
  end

  context "an existing campaign with no data available" do
    it "returns 204" do
      get "/campaigns/1"
      last_response.status.should == 204
      last_response.headers['Cache-Control'].should == cache_control
    end
  end

  context "not existing campaign" do
    it "returns 404" do
      get "/campaigns/0"
      last_response.status.should == 404
      last_response.headers['Cache-Control'].should == cache_control
    end
    it "returns 404" do
      get "/campaigns/51"
      last_response.status.should == 404
      last_response.headers['Cache-Control'].should == cache_control
    end
    it "returns 404" do
      get "/campaigns/text"
      last_response.status.should == 404
      last_response.headers['Cache-Control'].should == cache_control
    end
  end

end
