class AuthController < ApplicationController
  def auth
    res = HTTParty.post("https://login.bigcommerce.com/oauth2/token", body: {
      "client_id" => Rails.application.credentials.bc_client_id,
      "client_secret" => Rails.application.credentials.bc_client_secret,
      "code" => params[:code],
      "context" => params[:context],
      "scope" => params[:scope],
      "grant_type" => "authorization_code",
      "redirect_uri" => "https://cockatoo-outgoing-leech.ngrok-free.app/auth"
    })

    if res.success?
      data = res.parsed_response
      owner_data = data["owner"]
      owner = User.create_with(username: owner_data["username"]).find_or_create_by(email: owner_data["email"])

      user_data = data["user"]
      user = User.create_with(username: user_data["username"]).find_or_create_by(email: user_data["email"])

      hash = extract_store_hash(data["context"])
      store = Store.create_with(access_token: data["access_token"], scope: data["scope"]).find_or_create_by(store_hash: hash)

      render plain: store

    else

      render plain: "Poo Poo error"
    end
  end

  def load
    render plain: params.inspect
  end

  private def extract_store_hash(store_string)
    match = store_string.match(/^stores\/(.*)$/)
    match ? match[1] : nil
  end
end
