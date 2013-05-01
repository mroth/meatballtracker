require 'spec_helper'

describe Parser do

  describe ".new" do
    it "should require a URI as an argument" do
      lambda { Parser.new() }.should raise_error(ArgumentError)
    end
    it "should require that URI be valid"
    # it "should automatically retrieve and store the file on init" #lets not, that will complicate things
  end

  describe "#parse" do
    it "should copy the file to the local tmp filesystem"
    it "should store the path to the file in an instance variable"
  end
  describe "#text" do
    it "should run parse if needed"
    it "should cache the text results"
  end

  describe "#contains_meatballs?" do
    it "should fire the parse method if needed"
    it "should return true/false as to whether the menu contains meatballs"
  end

end