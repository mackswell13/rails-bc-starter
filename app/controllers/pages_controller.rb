class PagesController < ApplicationController
  def home
    puts "Cookies: ", cookies.to_hash
    puts "Auth?: ", authenticated?
    @store = Current.session.store
    @user = Current.user
    @session = Current.session
  end
end
