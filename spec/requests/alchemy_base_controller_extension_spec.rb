require "spec_helper"

module AlchemyDomains

	describe "AlchemyBaseControllerExtension" do

		before(:all) do
			@domain = Factory(:domain)
			@language_de = Alchemy::Language.get_default
			@language_de.update_attribute(:country_code, "de")
			@domain.localizations.create!(:language => @language_de)
			@language_root = Alchemy::Page.create!(:name => 'Language Root', :page_layout => 'standard', :parent_id => Alchemy::Page.root.id, :language => @language_de)
			@public_page = Alchemy::Page.create!(:name => 'public page', :page_layout => 'standard', :parent_id => @language_root.id, :language => @language_root.language, :public => true)
		end

		describe "Requesting a domain" do

			context "that exists in the database" do
			  
				it "should save the domain_id in the session" do
					get "http://#{@domain.hostname}"
					@request.session[:domain_id].should == @domain.id
				end

				context "without passing language params via the url" do
					it "should save the default localization's language_id of the domain in the session" do
						@language_en = Alchemy::Language.create!(:name => 'en-de', :language_code => 'en', :country_code => 'de', :page_layout => 'home', :frontpage_name => 'home', :public => true)
						@domain.localizations.create!(:language => @language_en, :default_for_domain => true)
						get "http://#{@domain.hostname}"
						@request.session[:language_id].should == @language_en.id
					end
				end

				context "when passing a language parameter via the url" do
					it "should save the language in the session" do
						@language_en = Alchemy::Language.create!(:name => 'en-de', :language_code => 'en', :country_code => 'de', :page_layout => 'home', :frontpage_name => 'home', :public => true)
						@domain.localizations.create!(:language => @language_en, :default_for_domain => true)
						get "http://#{@domain.hostname}/de-de/"
						@request.session[:language_id].should == @language_de.id
					end
				end

			end

			context "that does not exist in the database" do
				it "should redirect to the default domain " do
					get "http://wtf.example.com"
					response.should redirect_to "http://#{@domain.hostname}"
				end
			end

		end

		after(:all) do
			@domain.destroy
			@language_root.destroy						
		end

	end

end
