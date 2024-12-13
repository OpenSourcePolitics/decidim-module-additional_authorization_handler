# Decidim::AdditionalAuthorizationHandler

Module additional authorization handler.

## Usage

AdditionalAuthorizationHandler will be available as a Component for a Participatory
Space. This module provides 2 new handlers:
- phone_authorization_handler on proposals, to get the phone number of users
- extended_socio_demographic_authorization_handler, to get socio-demographic informations on user

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-additional_authorization_handler", git: 'github.com/OpenSourcePolitics/decidim-module-additional_authorization_handler.git', branch: 'master'
```

And then execute:

```bash
bundle
```

## Getting started

You can setup easily the handlers from Decidim system and backoffice, let's see :
1. First, log in system side at https://example.com/system
2. Edit your organization
3. Check the "Phone number recovery" checkbox if you want to activate phone_authorization_handler
4. Check the "Additional informations" checkbox if you want to activate extended_socio_demographic_authorization_handler
5. Save your organization's configuration
6. 
Great the handler(s) you picked should be available now !

Then you need to activate them in back office:
1. Log in as administrator
2. For the phone_authorization_handler
  * Navigate to participatory process in back office
  * Navigate to Components show view
  * Manage permissions for the proposals
  * Enable phone authorization handler by checking "Phone number recovery" checkbox
3. For the extended_socio_demographic_authorization_handler
   * Navigate to participatory process in back office
   * Navigate to Components show view
   * Manage permissions for the desired component
   * Enable socio-demographic handler by checking "Additional informations" checkbox

Congratulations, users will have to refer new informations before being authorized to perform actions.

## Please note the customizations

The phone_authorization_handler overrides decidim's exporters by adding an admin export to prevent phone number from being exported by non admin users.

At the moment, this module is fully compatible with Decidim instance, however conflicts can happen with other modules.

## Contributing

Contributions are welcome !

We expect the contributions to follow the [Decidim's contribution guide](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## Security

Security is very important to us. If you have any issue regarding security, please disclose the information responsibly by sending an email to __security [at] opensourcepolitics [dot] eu__ and not by creating a GitHub issue.

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
