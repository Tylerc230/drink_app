require "rspec"
require 'spec_helper'

describe "Checkin business logic tests" do

  before :each do
    create_beer
    create_mimosa
  end

  it "return checkins with specified tags" do
    Factory.create_list(:checkin, 5, :drink => @budweiser)
    Factory.create_list(:checkin, 3, :drink => @mimosa)
    beer_related_checkins = Checkin.tagged_with('beer')

    beer_related_checkins.should have(5).checkins


  end
end