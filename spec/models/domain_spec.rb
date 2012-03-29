require "spec_helper"

module AlchemyDomains

	describe Domain do
	
		before(:all) do
			@default_domain = Factory(:domain)
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
				@other_domain = Factory(:domain, :hostname => "test.de")
				Domain.default.should == @default_domain
			end
		end

		describe "before_create" do
			describe "#set_to_default" do
				context "when no default Domain exists" do
					it "should be set to the default Domain" do
					  Domain.destroy_all
					  Factory(:domain).default.should be_true
					end
				end
				context "when a default Domain already exists" do
					it "should be set to the default Domain" do
						@default_domain.update_attribute(:default, true)
						Factory(:domain, :hostname => "test.de").default.should be_false
					end
				end
			end
		end

		describe "before_save" do
			describe "#remove_old_default" do
				context "when the current Domain object will become the default Domain" do
					it "the current default Domain's default statuts should be removed" do
					  @default_domain.update_attribute(:default, true)
					  Factory(:domain, :hostname => "test.de", :default => true)
					  @default_domain.reload; @default_domain.default.should be_false
					end
				end
			end
		end
		
		describe "validate_format_of" do
			describe "hostname" do
				it "should have errors on saving when hostname untypical chars are used" do
					Factory.build(:domain, :hostname => "test+me.de").valid?.should be_false
					Factory.build(:domain, :hostname => "test&me.de").valid?.should be_false
					Factory.build(:domain, :hostname => "test@me.de").valid?.should be_false
					Factory.build(:domain, :hostname => "test_me.de").valid?.should be_false
					Factory.build(:domain, :hostname => "test.").valid?.should be_false
				end
				it "should be valid when using dots, word and digit chars" do
					Factory.build(:domain, :hostname => "test.de").valid?.should be_true
					Factory.build(:domain, :hostname => "localhost").valid?.should be_true
					Factory.build(:domain, :hostname => "sub.domain.de").valid?.should be_true
					Factory.build(:domain, :hostname => "sub.sub.domain.de").valid?.should be_true
					Factory.build(:domain, :hostname => "sub-sub.domain.de").valid?.should be_true
					Factory.build(:domain, :hostname => "sub.domain864.de").valid?.should be_true
				end
			end
		end

		after(:all) do
			@default_domain.destroy
		end

	end

end