module UserFinder
  extend ActiveSupport::Concern

  private

  def current_user
    authorization_header = request.headers['Authorization']
    token = if authorization_header && authorization_header.match(/^Bearer /)
      # Extract the token from the "Authorization" header
      authorization_header.gsub(/^Bearer /, '')
    end

    User.find_by(token:)
  end
end
