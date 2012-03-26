require 'spec_helper'

describe Alchemy::BaseHelper do

	describe "#multi_language?" do

		before(:all) do
			@domain = Factory(:default_domain)
			@language_de = Alchemy::Language.get_default
			@language_de.update_attribute(:country_code, "de")
			@domain.localizations.create!(:language => @language_de)
		end

		describe "#multi_language?" do

			before(:each) do
				helper.request.host = @domain.hostname
				session[:domain_id] = @domain.id
			end

			it "should return true if the current domain has more than one assigned published languages" do
				@language_kl = Factory(:language_with_country_code)
				@domain.localizations.create!(:language => @language_kl)
				helper.multi_language?.should == true
			end

			it "should return false if the current domain has just one assigned published language" do
				helper.multi_language?.should == false
			end

			it "should return false if the current domain has one assigned published language and one unpublished language" do
				@language_kl = Factory(:language_with_country_code, :public => false)
				@domain.localizations.create!(:language => @language_kl)
				helper.multi_language?.should == false
			end

		end

		after(:all) do
			@domain.destroy
		end

	end

end