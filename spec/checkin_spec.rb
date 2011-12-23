require "rspec"
require 'spec_helper'

describe "Checkin business logic tests" do

  before :each do
    create_beer
    create_mimosa
  end

  it "should return checkins with specified tags" do
    Factory.create_list(:checkin, 5, :drink => @budweiser)
    Factory.create_list(:checkin, 3, :drink => @mimosa)
    beer_related_checkins = Checkin.tagged_with('beer')

    beer_related_checkins.should have(5).checkins


  end

  it "should return all checkins" do
    setup_time_scope_tests
    checkins = Checkin.before_time nil
    checkins.should have(2).checkins

    checkins = Checkin.after_time nil
    checkins.should have(2).checkins
  end

  it "should return 1 checkin before specified time" do
    setup_time_scope_tests
    checkins = Checkin.before_time 11.hours
    all_checkins = checkins.all

    checkins.should have(1).checkin
    checkins.last.should eq(@before)
    checkins.last.should_not eq(@after)
  end

  it "should return checkins after specified time" do
    setup_time_scope_tests
    checkins = Checkin.after_time 11.hours

    checkins.should have(1).checkin
    checkins.last.should eq(@after)
    checkins.last.should_not eq(@before)

  end

  def setup_time_scope_tests
    @before = Factory.create(:checkin, :checkin_time => 10.hours)
    @after = Factory.create(:checkin, :checkin_time => 12.hours)
  end

  it "should create checkin with same session id" do
    create_2_checkins_with_time_diff (Checkin::SESSION_DIVIDER - 1.hour)
    @current_checkin.session_id.should_not be_nil
    @current_checkin.session_id.should eq(@last_checkin.session_id)
  end

  it "should create checkin with new session id" do
    create_2_checkins_with_time_diff (Checkin::SESSION_DIVIDER + 1.hour)
    @current_checkin.session_id.should_not be_nil
    @current_checkin.session_id.should eq(@last_checkin.session_id + 1)
  end

  def create_2_checkins_with_time_diff(time_diff)
    last_checkin_time = DateTime.new(2011, 12, 11)
    @last_checkin = FactoryGirl.create(:checkin, :checkin_time => last_checkin_time)

    current_checkin_time = last_checkin_time + time_diff
    @current_checkin = FactoryGirl.create(:checkin, :checkin_time => current_checkin_time)
  end




end