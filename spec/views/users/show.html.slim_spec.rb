require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, create(:user, username: "username", email: "email@example.com"))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/username/)
    expect(rendered).to match(/email@example.com/)
  end
end
