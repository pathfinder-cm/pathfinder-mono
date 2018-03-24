require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      create(:user, username: "username", email: "email@example.com")
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "username".to_s, :count => 1
    assert_select "tr>td", :text => "email@example.com".to_s, :count => 1
  end
end
