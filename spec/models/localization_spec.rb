require "spec_helper"

module AlchemyDomains

	describe Localization do

		before(:all) do
			@default_domain = Factory(:domain)
			@localization = @default_domain.localizations.create(:language => Alchemy::Language.get_default)
		end

		describe "before_create" do
			describe "#set_to_default_for_domain" do
				context "when no default localization for that Domain exists" do
					it "should be set to the default localization" do
						@localization.default_for_domain.should be_true
					end
				end
			end
		end

		describe "before_save" do
			describe "#remove_old_default" do
				context "when the current object will become the default for the Domain" do
					it "the current default localization's default_for_domain statuts should be removed" do
					  @localization.update_attribute(:default_for_domain, true)
					  @other_localization = @default_domain.localizations.create(:language => Factory(:language), :default_for_domain => true)
					  @localization.reload; @localization.default_for_domain.should be_false
					end
				end
			end
		end

		after(:all) do
			@default_domain.destroy
		end

	end

end
