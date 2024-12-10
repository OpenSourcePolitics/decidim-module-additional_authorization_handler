# frozen_string_literal: true

require "spec_helper"
require "decidim/dev/test/authorization_shared_examples"

describe PhoneAuthorizationHandler do
  let(:handler) { described_class.new(params.merge(extra_params)) }
  let(:params) { { user: create(:user, :confirmed) } }
  let(:extra_params) { {} }

  it_behaves_like "an authorization handler"

  describe "metadata" do
    subject { handler.metadata }

    let(:extra_params) { { phone_number: "0666666666" } }

    it { is_expected.to eq(phone_number: "0666666666") }
  end

  describe "valid?" do
    subject { handler.valid? }

    let(:extra_params) { { phone_number: phone_number } }

    context "when no phone number" do
      let(:phone_number) { nil }

      it { is_expected.to be(false) }
    end

    context "when phone number is not valid format" do
      let(:phone_number) { "8888888888" }

      it { is_expected.to be(false) }
    end

    context "when phone number contains letters" do
      let(:phone_number) { "FGHGFDSD" }

      it { is_expected.to be(false) }
    end

    context "when phone number is a french phone number" do
      let(:phone_number) { "0666666666" }

      it { is_expected.to be(true) }
    end

    context "when phone number has internationalized format" do
      let(:phone_number) { "+33666666666" }

      it { is_expected.to be(true) }
    end

    context "when phone number is too short" do
      let(:phone_number) { "+33666" }

      it { is_expected.to be(false) }
    end

    context "when phone number is too long" do
      let(:phone_number) { "+3366666666666" }

      it { is_expected.to be(false) }
    end
  end
end
