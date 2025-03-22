class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :reauth ]

  def home
    puts "Cookies: ", cookies.to_hash
    puts "Auth?: ", authenticated?
    @store = Current.session.store
    @user = Current.user
    @session = Current.session
  end

  def reauth
  end
end
