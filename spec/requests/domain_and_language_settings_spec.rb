require "spec_helper"

module Alchemy
	describe "Finding the domain" do

	  it "should get the current domain" do
	  	@domain = Domain.create!(:hostname => 'biz.wlw.de')
	  	@default_language = Language.get_default
	  	@domain.localizations.create!(:language => @default_language)
	  	@language_root = Page.create!(:name => 'Language Root', :page_layout => 'standard', :parent_id => Page.root.id, :language => @default_language)
		@public_page = Page.create!(:name => 'public page', :page_layout => 'standard', :parent_id => @language_root.id, :language => @language_root.language, :public => true)
	    get 'http://biz.wlw.de/public-page'
	    debugger
	    response.request.host.should == 'biz.wlw.de'
	  end

	end
end
