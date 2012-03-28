require 'spec_helper'

include Alchemy::BaseHelper

describe Alchemy::PagesHelper do

	describe "#language_switcher" do

		before(:all) do
			@domain = Factory(:domain)
			@default_language = Alchemy::Language.get_default
			@default_language.update_attribute(:country_code, "de")
			@domain.localizations.create!(:language => @default_language)
		end

		before :each do
			helper.request.host = @domain.hostname
			session[:domain_id] = @domain.id
			helper.stub(:multi_language?).and_return(true)
			helper.stub(:configuration) { |arg| arg == :redirect_to_public_child ? true : false }
		end

		it "should return nil when having one public language for the current domain" do
			helper.language_switcher.should be nil
		end

		it "should return nil when having one public language and a language_root page for the current domain" do
			@default_language_root = Factory(:language_root_page, :language => @default_language, :name => 'Default Language Root')
			helper.language_switcher.should be nil
		end

		context "with two public languages with language_root pages assigned to the current domain" do

			before :each do
				@default_language_root = Factory(:language_root_page, :language => @default_language, :name => 'Default Language Root')
				@klingonian = Factory(:language_with_country_code)
				@domain.localizations.create!(:language => @klingonian)
				@klingonian_language_root = Factory(:language_root_page, :language => @klingonian)
			end

			context "and config redirect_to_public_child is set to TRUE" do

				it "should return nil if only one language_root is public and both do not have children" do
					@klingonian_language_root.update_attributes(:public => false)
					helper.language_switcher.should == nil
				end

				it "should return nil if only one language_root is public and both have none public children" do
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => false, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => false, :name => "child1")
					helper.language_switcher.should == nil
				end

				it "should render two links when having two public language_root pages" do
					helper.language_switcher.should have_selector('a', :count => 2)
				end

				it "should render two links when having just one public language_root but a public children in both language_roots" do
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => true, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => true, :name => "child1")
					helper.language_switcher.should have_selector('a', :count => 2)
				end

				it "should render two links when having two not public language_roots but a public children in both" do
					@default_language_root.update_attributes(:public => false)
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => true, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => true, :name => "child1")
					helper.language_switcher.should have_selector('a', :count => 2)
				end

				it "should return nil when having two not public language_roots and a public children in only one of them" do
					@default_language_root.update_attributes(:public => false)
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => false, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => true, :name => "child1")
					helper.language_switcher.should == nil
				end

			end

			context "and config redirect_to_public_child is set to FALSE" do

				before :each do
					# simulates link_to_public_child = false
					helper.stub(:configuration).and_return(false)
				end

				it "should render two links when having two public language_root pages" do
					helper.language_switcher.should have_selector('a', :count => 2)
				end

				it "should render nil when having just one public language_root but a public children in both language_roots" do
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => true, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => true, :name => "child1")
					helper.language_switcher.should == nil
				end

				it "should render nil when having two not public language_roots but a public children in both" do
					@default_language_root.update_attributes(:public => false)
					@klingonian_language_root.update_attributes(:public => false)
					@default_first_public_child = Factory(:page, :language => @default_language, :parent_id => @default_language_root.id, :public => true, :name => "child1")
					@klingonian_first_public_child = Factory(:page, :language => @klingonian, :parent_id => @klingonian_language_root.id, :public => true, :name => "child1")
					helper.language_switcher.should == nil
				end

			end

		end

		after(:all) do
			@domain.destroy
		end

	end

end