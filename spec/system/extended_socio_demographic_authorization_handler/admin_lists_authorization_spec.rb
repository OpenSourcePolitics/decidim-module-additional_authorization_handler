# frozen_string_literal: true

require "spec_helper"

describe "Authorizations" do
  let!(:organization) do
    create(:organization, available_authorizations: ["extended_socio_demographic_authorization_handler"])
  end

  context "when in system" do
    let(:admin) { create(:admin) }

    before do
      switch_to_host(organization.host)
      login_as admin, scope: :admin
      visit decidim_system.root_path
      click_link('Edit', href: "/system/organizations/#{organization.id}/edit")
    end

    it "allows the system admin to list all available authorization methods" do
      within ".edit_update_organization" do
        expect(page).to have_content("Additional informations")
      end
    end
  end

  context "when in admin back office" do
    let(:admin) { create(:user, :admin, :confirmed, organization:) }

    before do
      switch_to_host(organization.host)
      login_as admin, scope: :user
      visit decidim_admin.root_path
      click_on "Participants"
      within_admin_sidebar_menu do
        click_on "Authorizations"
      end
    end

    it "allows the user to list all available authorization methods" do
      within "[data-content]" do
        expect(page).to have_content("Additional informations")
      end
    end
  end
end
