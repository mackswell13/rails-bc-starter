require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validates presence of email address" do
    user = User.new(username: "test_username")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "validates presence of username" do
    user = User.new(email_address: "test@test.com")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "should normalize email address" do
    user = User.create!(email_address: " Test@Example.com ", username: "testuser")
    assert_equal "test@example.com", user.email_address
  end

  test "should show user as store owner" do
    user = User.create!(email_address: " Test@Example.com ", username: "testuser")
    store = Store.create!(store_hash: "test", access_token: "token")
    StoreRelationship.create!(user: user, store: store, is_owner: true, bc_id: 123)

    assert user.is_owner_of?(store)
  end
end
