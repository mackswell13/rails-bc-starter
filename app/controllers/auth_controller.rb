class AuthController < ApplicationController
  allow_unauthenticated_access

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
      owner = User.create_with(username: owner_data["username"]).find_or_create_by(email_address: owner_data["email"])

      user_data = data["user"]
      user = User.create_with(username: user_data["username"]).find_or_create_by(email_address: user_data["email"])

      hash = extract_store_hash(data["context"])
      store = Store.create_with(access_token: data["access_token"], scope: data["scope"]).find_or_create_by(store_hash: hash)

      StoreRelationship.create(user: owner, store: store, is_owner: true, bc_id: owner_data["id"])

      if owner != user
        StoreRelationship.create(user: owner, store: store, is_owner: false, bc_id: user_data["id"])
      end

      # All of the data is set correctly need to find a good way to process the redirect without needing to serialize a jwt

      render plain: store

    else

      render plain: "Eorror with the auth"
    end
  end

  def load
    encoded_token = JWT::EncodedToken.new(params[:signed_payload_jwt])

    encoded_token.verify_signature!(algorithm: "HS256", key: Rails.application.credentials.bc_client_secret)

    payload = encoded_token.payload

    user_data = payload["user"]

    store_hash = extract_store_hash(payload["sub"])

    store = Store.find_by(store_hash: store_hash)

    user = store.users.where("email_address IS ?", user_data["email"]).first

    # resume session if possible
    resume_session

    # For this app we need to check the user and the store as a user can exist in multiple stores
    if Current.user != user || Current.user != store
      start_new_session_for user, store
    end

    redirect_to controller: "pages", action: "home"
  end

  private def extract_store_hash(store_string)
    match = store_string.match(/^stores\/(.*)$/)
    match ? match[1] : nil
  end
end
