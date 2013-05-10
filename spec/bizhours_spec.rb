require 'spec_helper'
require 'timecop'

describe Bizhours do

  describe "#open?" do
    it "should return true or false during appropriate business hours" do
      biz = Bizhours.new
      @lunchtime =   Time.new(2001,1,1,12,1,1,"-08:00")
      @dinnertime =  Time.new(2001,1,1,19,1,1,"-08:00")
      @crackofdawn = Time.new(2001,1,1,5,1,1,"-08:00")
      Timecop.travel(@lunchtime)   { biz.open?.should be_true }
      Timecop.travel(@dinnertime)  { biz.open?.should be_true }
      Timecop.travel(@crackofdawn) { biz.open?.should be_false }
    end
  end

end