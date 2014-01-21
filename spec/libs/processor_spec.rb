# encoding: utf-8

require_relative '../spec_helper'

describe Processor do

  describe  ".process_impressions(impressions)" do
    subject do
      Processor.process_impressions(impressions)
    end

    context "empty impressions" do
      let(:impressions) { {} }
      it { should == [] }
    end

    context "few campaigns with impressions" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 1, :clicks => 10},
            },
            1002 => {
                101 => {:revenue => 1, :clicks => 10},
                102 => {:revenue => 0, :clicks => 20},
            },
            1003 => {
                101 => {:revenue => 1, :clicks => 10},
                102 => {:revenue => 0, :clicks => 20},
                103 => {:revenue => 0, :clicks => 0},
            },
        }
      end
      it { should == [[1001, [101]],
                      [1002, [101, 102]],
                      [1003, [101, 102, 103]]] }
    end

    context "more than 10 banners with revenue" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 1.1, :clicks => 10},
                102 => {:revenue => 1.2, :clicks => 20},
                103 => {:revenue => 1.3, :clicks => 30},
                104 => {:revenue => 1.4, :clicks => 20},
                105 => {:revenue => 1.5, :clicks => 40},
                106 => {:revenue => 1.6, :clicks => 50},
                107 => {:revenue => 1.7, :clicks => 200},
                108 => {:revenue => 1.8, :clicks => 30},
                109 => {:revenue => 1.9, :clicks => 10},
                110 => {:revenue => 2.0, :clicks => 20},
                111 => {:revenue => 1.0, :clicks => 100},
                112 => {:revenue => 1.0, :clicks => 300},
                113 => {:revenue => 1.0, :clicks => 20},
                114 => {:revenue => 1.0, :clicks => 20},
                115 => {:revenue => 1.0, :clicks => 500},
                116 => {:revenue => 1.0, :clicks => 600},
                117 => {:revenue => 1.0, :clicks => 700},
                118 => {:revenue => 1.0, :clicks => 800},
                119 => {:revenue => 1.0, :clicks => 900},
                120 => {:revenue => 1.0, :clicks => 0},
            },
        }
      end
      it { should == [[1001,
                       [110, 109, 108, 107, 106, 105, 104, 103, 102, 101]]] }
    end

    context "between 5 and 9 banners with revenue" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 1.1, :clicks => 10},
                102 => {:revenue => 1.2, :clicks => 20},
                103 => {:revenue => 1.3, :clicks => 30},
                104 => {:revenue => 1.4, :clicks => 20},
                105 => {:revenue => 1.5, :clicks => 40},
                106 => {:revenue => 0, :clicks => 50},
                107 => {:revenue => 0, :clicks => 200},
                108 => {:revenue => 0, :clicks => 30},
                109 => {:revenue => 0, :clicks => 10},
                110 => {:revenue => 0, :clicks => 0},
            },
        }
      end
      it { should == [[1001, [105, 104, 103, 102, 101]]] }
    end

    context "between 1 and 4 banners with revenue" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 1.1, :clicks => 100},
                102 => {:revenue => 0, :clicks => 20},
                103 => {:revenue => 0, :clicks => 30},
                104 => {:revenue => 0, :clicks => 40},
                105 => {:revenue => 0, :clicks => 50},
                106 => {:revenue => 0, :clicks => 10},
                107 => {:revenue => 0, :clicks => 10},
                108 => {:revenue => 0, :clicks => 10},
                109 => {:revenue => 0, :clicks => 0},
                110 => {:revenue => 0, :clicks => 0},
            },
        }
      end
      it { should == [[1001, [101, 105, 104, 103, 102]]] }
    end

    context "no banners with revenue and enough with clicks" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 0, :clicks => 10},
                102 => {:revenue => 0, :clicks => 20},
                103 => {:revenue => 0, :clicks => 30},
                104 => {:revenue => 0, :clicks => 40},
                105 => {:revenue => 0, :clicks => 50},
                106 => {:revenue => 0, :clicks => 5},
                107 => {:revenue => 0, :clicks => 4},
                108 => {:revenue => 0, :clicks => 3},
                109 => {:revenue => 0, :clicks => 2},
                110 => {:revenue => 0, :clicks => 0},
            },
        }
      end
      it { should == [[1001, [105, 104, 103, 102, 101]]] }
    end

    context "no banners with revenue and not enough with clicks" do
      let(:impressions) do
        {
            1001 => {
                101 => {:revenue => 0, :clicks => 10},
                102 => {:revenue => 0, :clicks => 20},
                103 => {:revenue => 0, :clicks => 30},
                104 => {:revenue => 0, :clicks => 0},
                105 => {:revenue => 0, :clicks => 0},
            },
        }
      end
      it { should == [[1001, [103, 102, 101, 104, 105]]] }
    end

  end

end
