class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!

  def login
    redirect_to root_path
  end

  def github
    oauth = request.env['omniauth.auth']

    return redirect_to root_path, alert: t(:error_authentication_failed) unless organization_member?(oauth)

    user = User.where(nickname: oauth.info.nickname).first
    if user
      user.name = oauth.info.name
    else
      user = User.new(name: oauth.info.name, nickname: oauth.info.nickname)
    end
    user.save
    sign_in_and_redirect user, event: :authentication
  end

  def logout
    sign_out current_user
    redirect_to root_path
  end

  def failure
    redirect_to root_path, alert: t(:error_authentication_failed)
  end

  private

  def organization_member?(oauth)
    return true if Settings.omniauth.github.organization.blank?

    client = Octokit::Client.new(access_token: oauth.credentials.token)
    client.organization_member?(Settings.omniauth.github.organization, oauth.info.nickname)
  end
end
