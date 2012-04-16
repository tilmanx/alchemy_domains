module Alchemy

	PagesController.class_eval do

		def perform_search
			searchresult_page_layouts = PageLayout.get_all_by_attributes({:searchresults => true})
			if searchresult_page_layouts.any?
				@search_result_page = Page.find_by_page_layout_and_public_and_language_id(searchresult_page_layouts.first["name"], true, session[:language_id])
				if !params[:query].blank? && @search_result_page
					@search_results = []
					%w(Alchemy::EssenceText Alchemy::EssenceRichtext).each do |e|
						@search_results += e.constantize.includes(:contents => {:element => :page}).find_with_ferret(
							"*#{params[:query]}*",
							{:limit => :all},
							{:conditions => [
								'alchemy_pages.language_id = ? AND alchemy_pages.public = ? AND alchemy_pages.layoutpage = ? AND alchemy_pages.restricted = ?',
								@search_result_page.language_id, true, false, false
							]}
						)
					end
					return @search_results.sort{ |y, x| x.ferret_score <=> y.ferret_score } if @search_results.any?
				end
			end
		end

		protected

		# If merged into Alchemy Core, this can be deleted.
		def load_page
			return @page if @page
			if params[:urlname].blank?
				@page = Page.language_root_for(Language.get_default.id)
			else
				@page = Page.contentpages.find_by_urlname_and_language_id(params[:urlname], session[:language_id])
			end
		end

	end

end
