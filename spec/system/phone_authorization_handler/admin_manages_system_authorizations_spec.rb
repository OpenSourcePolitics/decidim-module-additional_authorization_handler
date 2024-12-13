# frozen_string_literal: true

require "spec_helper"

describe "Admin manages system authorizations" do
  let!(:organization) { create(:organization, available_authorizations: ["phone_authorization_handler"]) }
  let(:admin) { create(:admin) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :admin
    visit decidim_system.edit_organization_path(id: organization.id)
  end

  it "allow system administrator to list all available authorizations" do
    within ".edit_update_organization" do
      expect(page).to have_content("Phone number recovery")
    end
  end

  it "can activate phone authorization handler" do
    within ".edit_update_organization" do
      find("input[value='phone_authorization_handler']").set(true)
      expect(find("input[value='phone_authorization_handler']").checked?).to be(true)

      click_on "Save"
    end

    expect(page).to have_content("Organization successfully updated.")
  end
end
