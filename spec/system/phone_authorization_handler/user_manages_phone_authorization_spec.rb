# frozen_string_literal: true

require "spec_helper"

describe "User manages phone authorization", type: :system do
  let!(:organization) do
    create(:organization, available_authorizations: ["phone_authorization_handler"])
  end

  let(:user) { create(:user, :confirmed) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user

    visit decidim.account_path
    click_link "Authorizations"
  end

  it "displays the authorization item" do
    within ".authorizations-list" do
      expect(page).to have_content("Phone number recovery")
      expect(page).to have_content("Verify your account by entering your phone number")
    end
  end

  context "when accessing phone number authorization" do
    before do
      click_link "Phone number recovery"
    end

    it "displays authorization form" do
      expect(page).to have_content "Fill in your phone number"
      expect(page).to have_content "This personal information is reserved to the platform's administrators and is not accessible by other users."

      within ".new_authorization_handler" do
        expect(page).to have_field("Phone number (without point nor whitespace)")
      end
    end

    it "allows user to fill form" do
      fill_in "Phone number (without point nor whitespace)", with: "0123456789"
      click_button "I continue"

      expect(page).to have_content("You have been successfully authorized")
    end

    it "shows error message for too short phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "012345678"
      click_button "I continue"

      expect(page).to have_content("There is an error in this field")
    end

    it "shows error message for too long phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "01234567891234"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for not numeric phone number" do
      fill_in "Phone number (without point nor whitespace)", with: "NOT_A_VALID_FORMAT"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end

    it "shows error message for invalid phone number format" do
      fill_in "Phone number (without point nor whitespace)", with: "3344444444"
      click_button "I continue"

      expect(page).to have_content("Not a valid phone number format")
    end
  end
end
