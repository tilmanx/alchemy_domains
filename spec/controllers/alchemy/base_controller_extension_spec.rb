require 'spec_helper'

describe Alchemy::BaseController do

  before(:all) do
    @domain = Factory(:domain)
    @language_de = Alchemy::Language.get_default
    @language_de.update_attribute(:country_code, "de")
    @domain.localizations.create!(:language => @language_de)
  end

  describe "#multi_language?" do

    it "should return true if the current domain has more than one assigned published languages" do
      controller.request.host = @domain.hostname
      session[:domain_id] = @domain.id
      @language_kl = Factory(:language_with_country_code)
      @domain.localizations.create!(:language => @language_kl)
      controller.multi_language?.should == true
    end

    it "should return false if the current domain has just one assigned published language" do
      controller.request.host = @domain.hostname
      session[:domain_id] = @domain.id
      controller.multi_language?.should == false
    end

    it "should return false if the current domain has one assigned published language and one unpublished language" do
      controller.request.host = @domain.hostname
      session[:domain_id] = @domain.id
      @language_kl = Factory(:language_with_country_code, :public => false)
      @domain.localizations.create!(:language => @language_kl)
      controller.multi_language?.should == false
    end

  end

  after(:all) do
    @domain.destroy
  end

end
