require 'spec_helper'

describe Parser do

  describe ".new" do
    it "should require a URI as an argument" do
      lambda { Parser.new() }.should raise_error(ArgumentError)
    end
    it "should require that URI be valid"
    # it "should automatically retrieve and store the file on init" #lets not, that will complicate things
  end

  describe "#retrieve_file" do
    it "should copy the file to the local tmp filesystem"
    it "should store the path to the file in an instance variable"
  end

  context "parsing operations" do
    before(:each) do
      @menu = Parser.new(
          uri: 'http://bootandshoeservice.com/wp-content/uploads/2013/04/Dinner4-30.pdf',
          local_path: './spec/sample_menus/Dinner4-30.pdf'
      )
    end
    
    describe "#text" do
      it "should return the text contained in the PDF" do
        @menu.text.should include("please, no electronic devices during pm service")
      end
      it "should run retrieve_file if needed"
      it "should cache the text results"
    end

    describe "#menu_date" do
      it "should return the posted date on the menu (not date retrieved)" do
        @menu.menu_date.should eq('april 30, 2013')
      end
    end

    describe "#is_delicious?" do
      it "should fire the parse method if needed"
      it "shoud return true if the menu contains meatballs" do
        @menu.is_delicious?.should be_true
      end
      it "should return false if the menu does not contain meatballs"
    end
  end

end