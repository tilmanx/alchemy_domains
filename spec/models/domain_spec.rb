require "spec_helper"

module AlchemyDomains

	describe Domain do
	
		before(:all) do
			@default_domain = Domain.create!(:hostname => "my.default.de", :default => true)
			@default_language = Alchemy::Language.get_default
			@default_localization = @default_domain.localizations.create!(:language => @default_language)
		end

		describe "#default_localization" do
			it "should find the default localization for this domain" do
				@language_en = Alchemy::Language.create!(:name => 'de-en', :language_code => 'en', :country_code => 'de', :page_layout => 'home', :frontpage_name => 'home', :public => true)
				@new_default_localization = @default_domain.localizations.create!(:language => @language_en, :default_for_domain => true)
				@default_domain.default_localization.should == @new_default_localization
			end
		end

		describe "#default_language" do
			it "should find the default language for this domain" do
				@language_en = Alchemy::Language.create!(:name => 'de-en', :language_code => 'en', :country_code => 'de', :page_layout => 'home', :frontpage_name => 'home', :public => true)
				@default_domain.localizations.create!(:language => @language_en)
				@default_domain.default_language.should == @default_language
			end
		end

		describe "#default" do
			it "should find the unique default domain" do
				@other_domain = Domain.create!(:hostname => "my.test.de")
				Domain.default.should == @default_domain
			end
		end

		describe "#find_by_hostname_or_default" do
			context "when passing an existing hostname" do
				it "should find a domain " do
					@other_domain = Domain.create!(:hostname => "my.test.de")
					Domain.find_by_hostname_or_default("my.test.de").should == @other_domain
				end
			end

			context "when passing a not existent hostname" do
				it "should find the default domain " do
					@other_domain = Domain.create!(:hostname => "my.test.de")
					Domain.find_by_hostname_or_default("oh-no").should == @default_domain
				end
			end
		end

		after(:all) do
			@default_domain.destroy
		end

	end

end