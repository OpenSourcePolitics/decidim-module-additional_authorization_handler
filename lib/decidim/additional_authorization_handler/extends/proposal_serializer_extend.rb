# frozen_string_literal: true

module Decidim::AdditionalAuthorizationHandler
  module Extends
    module ProposalSerializerExtend
      # Public: Initializes the serializer with a proposal.
      # public_scope : Bool (default: true) - Allow to add extra information when administrator exports
      def initialize(proposal, public_scope: true)
        @proposal = proposal
        @public_scope = public_scope
      end

      # Public: Exports a hash with the serialized data for this proposal.
      def serialize
        {
          id: proposal.id,
          category: {
            id: proposal.category.try(:id),
            name: proposal.category.try(:name) || empty_translatable
          },
          scope: {
            id: proposal.scope.try(:id),
            name: proposal.scope.try(:name) || empty_translatable
          },
          participatory_space: {
            id: proposal.participatory_space.id,
            url: Decidim::ResourceLocatorPresenter.new(proposal.participatory_space).url
          },
          component: { id: component.id },
          title: proposal.title,
          body: convert_to_plain_text(proposal.body),
          address: proposal.address,
          latitude: proposal.latitude,
          longitude: proposal.longitude,
          state: proposal.state.to_s,
          reference: proposal.reference,
          answer: ensure_translatable(proposal.answer),
          answered_at: proposal.answered_at,
          votes: proposal.proposal_votes_count,
          endorsements: {
            total_count: proposal.endorsements.size,
            user_endorsements:
          },
          comments: proposal.comments_count,
          attachments: proposal.attachments.size,
          followers: proposal.follows.size,
          published_at: proposal.published_at,
          url:,
          meeting_urls: meetings,
          related_proposals:,
          is_amend: proposal.emendation?,
          original_proposal: {
            title: proposal&.amendable&.title,
            url: original_proposal_url
          },
          withdrawn: proposal.withdrawn?,
          withdrawn_at: proposal.withdrawn_at
        }.merge(options_merge(author: {
          **author_fields
                              }))
      end

      # options_merge allows to add some objects to merge to the serialize
      # Params : options_object : Hash
      # Return Hash
      def options_merge(options_object)
        @public_scope ? {} : options_object
      end

      private

      def author_fields
        is_author_user_group = resource.coauthorships.map(&:decidim_user_group_id).any?

        {
          id: resource.authors.map(&:id),
          name: resource.authors.map do |author|
            author_name(is_author_user_group ? resource.coauthorships.first.user_group : author)
          end,
          url: resource.authors.map do |author|
            author_url(is_author_user_group ? resource.coauthorships.first.user_group : author)
          end
        }.merge(additional_fields(is_author_user_group))
      end

      def additional_fields(is_author_user_group)
        {
          nickname: resource.authors.map do |author|
            author_nickname(is_author_user_group ? resource.coauthorships.first.user_group : author)
          end,
          email: resource.authors.map do |author|
            author_email(is_author_user_group ? resource.coauthorships.first.user_group : author)
          end,
          phone_number: author_phone_number(resource.authors.map { |author| is_author_user_group ? "" : author.id })
        }
      end

      def author_nickname(author)
        if author.respond_to?(:nickname)
          translated_attribute(author.nickname) # is a Decidim::User or Decidim::Organization or Decidim::UserGroup
        else
          ""
        end
      end

      def author_email(author)
        if author.respond_to?(:email)
          translated_attribute(author.email) # is a Decidim::User or Decidim::Organization or Decidim::UserGroup
        else
          ""
        end
      end

      # author_phone_number retrieve the phone number of an user stored from phone_authorization_handler
      # Param: user_id : Integer
      # Return string, empty or with the phone number
      def author_phone_number(user_id)
        authorization = Decidim::Authorization.where(name: "phone_authorization_handler", decidim_user_id: user_id)
        return "" if authorization.blank?

        metadata = authorization.first.try(:metadata)
        return "" if metadata.blank?

        # rubocop:disable Lint/SafeNavigationChain
        authorization.first.try(:metadata)&.to_h["phone_number"].presence || ""
        # rubocop:enable Lint/SafeNavigationChain
      end
    end
  end
end
