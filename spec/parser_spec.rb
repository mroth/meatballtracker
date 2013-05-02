require 'spec_helper'

describe MenuParser do

  describe ".new" do
    it "should require a menu URI as an argument" do
      lambda { MenuParser.new() }.should raise_error(ArgumentError)
    end
    it "should require that URI be valid"
  end

  describe "#retrieve_file" do
    it "should copy a remote file to the local tmp filesystem", :networked => true do
      p = MenuParser.new('http://bootandshoeservice.com/wp-content/uploads/2013/04/Dinner4-30.pdf')
      p.retrieve_file
      File.exist?("./tmp/cached_menu_#{p.object_id}.pdf").should be_true
      p.local_path.should eq("./tmp/cached_menu_#{p.object_id}.pdf")
    end
    it "should copy a local file as to the local tmp filesystem" do
      p = MenuParser.new('./spec/sample_menus/Dinner4-30.pdf')
      p.retrieve_file
      File.exist?("./tmp/cached_menu_#{p.object_id}.pdf").should be_true
      p.local_path.should eq("./tmp/cached_menu_#{p.object_id}.pdf")
    end
  end

  context "parsing operations" do
    before(:all) do
      #menu for 4/30 - meatballs on a pasta ('rigatoni with tomato sauce & meatballs')
      @menu1 = MenuParser.new('./spec/sample_menus/Dinner4-30.pdf')
      #menu for 5/1 -- meatballs as an entree ('meatballs al' pizzaiolo')
      @menu2 = MenuParser.new('./spec/sample_menus/Dinner5_1.pdf')
    end
    
    describe "#text" do
      it "should return the text contained in the PDF" do
        @menu1.text.should include("please, no electronic devices during pm service")
      end
      # it "should run retrieve_file if needed" √
      # it "should cache the text results" √
    end

    describe "#menu_date" do
      it "should return the posted date on the menu (not date retrieved)" do
        @menu1.menu_date.should eq('april 30, 2013')
        @menu2.menu_date.should eq('may 1, 2013')
      end
    end

    describe "#is_delicious?" do
      it "shoud return true if the menu contains meatballs" do
        @menu1.is_delicious?.should be_true
        @menu2.is_delicious?.should be_true
      end
      it "should return false if the menu does not contain meatballs"
    end

    describe "#delicious_item" do
      it "should return a string representation of the meatball menu item" do
        @menu1.delicious_item.should eq("rigatoni with tomato sauce & meatballs")
        @menu2.delicious_item.should eq("meatballs al' pizzaiolo")
      end
      it "should return nil if there are no meatballs"
    end
  end

end