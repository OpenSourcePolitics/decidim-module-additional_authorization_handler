# frozen_string_literal: true

Decidim::Verifications.register_workflow(:extended_socio_demographic_authorization_handler) do |workflow|
  workflow.form = "ExtendedSocioDemographicAuthorizationHandler"
end
Decidim::Verifications.register_workflow(:phone_authorization_handler) do |workflow|
  workflow.form = "PhoneAuthorizationHandler"
end
