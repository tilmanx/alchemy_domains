require "spec_helper"

module AlchemyDomains
	describe "Requesting an existing domain" do

		context "without having a session cookie set for the language" do

			it "should set the session to the default language of the domain" do
				@domain = Domain.create!(:hostname => 'biz.wlw.de')
				@default_language = Alchemy::Language.get_default
				@language_en = Alchemy::Language.create!(:name => 'de-en', :language_code => 'en', :country_code => 'de', :page_layout => 'home', :frontpage_name => 'home', :public => true)
				@domain.localizations.create!(:language => @default_language)
				@domain.localizations.create!(:language => @language_en)
				@language_root = Alchemy::Page.create!(:name => 'Language Root', :page_layout => 'standard', :parent_id => Alchemy::Page.root.id, :language => @default_language)
				@public_page = Alchemy::Page.create!(:name => 'public page', :page_layout => 'standard', :parent_id => @language_root.id, :language => @language_root.language, :public => true)
				get 'http://biz.wlw.de'
				@request.session[:language_id].should == @default_language.id
			end

		end

	end
end
