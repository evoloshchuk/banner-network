require_relative '../spec_helper'

describe Campaign do

  describe  ".get_by_id(id)" do
    subject { Campaign.get_by_id(id) }
    context "not existing id" do
      context "smallest existing - 1" do
        let(:id) { 0 }
        it { should be_nil }
      end
      context "biggest existing + 1" do
        let(:id) { 51 }
        it { should be_nil }
      end
    end
    context "existing id" do
      context "smallest id" do
        let(:id) { 1 }
        it { be_an_instance_of Campaign }
      end
      context "biggest id" do
        let(:id) { 50 }
        it { be_an_instance_of Campaign }
      end
    end
  end

  describe  ".get_banner_id(id, excluded_banner_id)" do
    context "no banners available" do
      it "returns nil" do
        campaign = Campaign.get_by_id(1)
        campaign.get_banner_id.should be_nil
      end
    end
    context "one banner available" do
      before do
        campaign = Campaign.get_by_id 1
        campaign.update([150])
      end
      it "returns banner id" do
        Campaign.get_by_id(1).get_banner_id.should eql 150
      end
      it "returns banner id" do
        Campaign.get_by_id(1).get_banner_id(150).should eql 150
      end
    end
    context "few banners available" do
      before do
        campaign = Campaign.get_by_id 1
        campaign.update([151, 152, 153])
      end
      it "returns banner id" do
        [151, 152, 153].should include Campaign.get_by_id(1).get_banner_id
      end
      it "returns banner id" do
        [151, 152].should include Campaign.get_by_id(1).get_banner_id(153)
      end
    end
  end

  describe  ".update(ids)" do
    context "have not been called yet" do
      it "returns nil" do
        Campaign.get_by_id(1).get_banner_id.should be_nil
      end
    end
    context "have been called once" do
      before do
        campaign = Campaign.get_by_id 1
        campaign.update([175])
      end
      it "returns banner_id" do
        Campaign.get_by_id(1).get_banner_id.should eql 175
      end
    end
    context "have been called few times" do
      before do
        campaign = Campaign.get_by_id 1
        campaign.update([175])
        campaign.update([176])
      end
      it "returns banner_id" do
        Campaign.get_by_id(1).get_banner_id(176).should eql 176
      end
    end
  end
end
