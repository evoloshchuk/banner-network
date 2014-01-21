# encoding: utf-8

require_relative '../spec_helper'

describe Banner do

  describe  ".get_by_id(id)" do
    subject { Banner.get_by_id(id) }
    context "not existing id" do
      context "0" do
        let(:id) { 0 }
        it { should be_nil }
      end
      context "smallest existing - 1" do
        let(:id) { 99 }
        it { should be_nil }
      end
      context "biggest existing + 1" do
        let(:id) { 501 }
        it { should be_nil }
      end
    end
    context "existing id" do
      context "smallest id" do
        let(:id) { 100 }
        it { be_an_instance_of Banner }
      end
      context "biggest id" do
        let(:id) { 500 }
        it { be_an_instance_of Banner }
      end
    end
  end

  describe "banner attributes" do
    it "returns filename" do
      banner = Banner.get_by_id(100)
      banner.id.should eql 100
      banner.filename.should eql 'image_100.png'
    end
  end

end
