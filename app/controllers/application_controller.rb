class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  after_action :track_page_view, if: :user_signed_in?

  private

  def track_page_view
    return if request.xhr? || !request.get?

    current_user.page_views.create(path: request.path)
  end
end
