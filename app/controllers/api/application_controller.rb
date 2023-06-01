module API
  class ApplicationController < ActionController::API
    include UserFinder
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_token
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found
      render json: { errors: "Record not found." }, status: :not_found
    end

    def authenticate_token
      authenticate_or_request_with_http_token("Application", "Access denied.") do |token, _|
        User.find_by(token:)
      end
    end
  end
end
