require_relative '../spec_helper'

describe "GET '/banners/:banner_id'" do

  describe "an existing banner" do
    it "returns requested image" do
      get "/banners/100"
      last_response.status.should == 200
      last_response.headers['Content-Type'].should == 'image/png'
      last_response.headers['Content-Disposition'].should == ('inline; ' +
          'filename="image_100.png"')
    end
  end

  describe "not existing banner" do
    it "returns 404" do
      get "/banners/0"
      last_response.status.should == 404
    end
    it "returns 404" do
      get "/banners/99"
      last_response.status.should == 404
    end
    it "returns 404" do
      get "/banners/501"
      last_response.status.should == 404
    end
    it "returns 404" do
      get "/banners/text"
      last_response.status.should == 404
    end
  end

  context "http caching" do
    context "on the first request" do
      it "returns a 200 Ok" do
        get "/banners/100"
        last_response.status.should == 200
        last_response.headers.should have_key('Last-Modified')
      end
    end
    context "on the subsequent request" do
      before do
        get "/banners/100"
        @last_modified = last_response.headers['Last-Modified']
      end
      it "returns a 304 Not Modified" do
        get "/banners/100", nil, {'HTTP_IF_MODIFIED_SINCE' => @last_modified}
        last_response.status.should == 304
      end
    end
  end

end
