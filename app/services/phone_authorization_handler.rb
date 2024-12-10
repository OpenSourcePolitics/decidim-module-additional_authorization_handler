# frozen_string_literal: true

# Allows to create a form for simple Phone authorization
class PhoneAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :phone_number, String

  validates :phone_number,
            length: { in: 10..12 },
            format: { with: /\A(\+33|0)[1-9][0-9]{8}\z/, message: I18n.t(:phone_number_format, scope: "errors.messages") },
            presence: true

  def metadata
    super.merge(phone_number: phone_number)
  end
end
