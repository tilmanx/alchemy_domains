module AlchemyDomains
  module Admin
    class LocalizationsController < Alchemy::Admin::ResourcesController

      def update
        @localization = Localization.find(params[:id])
        @localization.update_attributes(params[:localization])
        render_errors_or_redirect(
          @localization,
          admin_domains_path,
          flash_notice_for_resource_action
        )
      end

    end
  end
end
