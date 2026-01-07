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
          taxonomies:,
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
          state_published_at: proposal.state_published_at,
          reference: proposal.reference,
          answer: ensure_translatable(proposal.answer),
          answered_at: proposal.answered_at,
          votes: (proposal.proposal_votes_count unless
            proposal.component.current_settings.votes_hidden?),
          likes: {
            total_count: proposal.likes.size,
            user_likes:
          },
          comments: proposal.comments_count,
          attachments: proposal.attachments.size,
          follows_count: proposal.follows_count,
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
          withdrawn_at: proposal.withdrawn_at,
          created_at: proposal.created_at,
          updated_at: proposal.updated_at,
          created_in_meeting: proposal.created_in_meeting,
          coauthorships_count: proposal.coauthorships_count,
          cost: proposal.cost,
          cost_report: proposal.cost_report,
          execution_period: proposal.execution_period
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

      attr_reader :proposal
      alias resource proposal

      def meetings
        proposal.linked_resources(:meetings, "proposals_from_meeting").map do |meeting|
          Decidim::ResourceLocatorPresenter.new(meeting).url
        end
      end

      def related_proposals
        proposal.linked_resources(:proposals, %w(copied_from_component merged_from_component splitted_from_component)).map do |proposal|
          Decidim::ResourceLocatorPresenter.new(proposal).url
        end
      end

      def url
        Decidim::ResourceLocatorPresenter.new(proposal).url
      end

      def user_likes
        proposal.likes.for_listing.map { |identity| identity.author&.name }
      end

      def original_proposal_url
        return unless proposal.emendation? && proposal.amendable.present?

        Decidim::ResourceLocatorPresenter.new(proposal.amendable).url
      end

      # Recursively strips HTML tags from given Hash strings using convert_to_text from Premailer
      def convert_to_plain_text(value)
        return value.transform_values { |v| convert_to_plain_text(v) } if value.is_a?(Hash)

        convert_to_text(value)
      end

      def author_fields
        {
          id: resource.authors.map(&:id),
          name: resource.authors.map do |author|
            author_name(author)
          end,
          url: resource.authors.map do |author|
            author_url(author)
          end
        }.merge(additional_fields)
      end

      def author_name(author)
        if author.respond_to?(:name)
          translated_attribute(author.name) # is a Decidim::User or Decidim::Organization
        elsif author.respond_to?(:title)
          translated_attribute(author.title) # is a Decidim::Meetings::Meeting
        end
      end

      def author_url(author)
        if author.respond_to?(:nickname)
          profile_url(author) # is a Decidim::User
        elsif author.respond_to?(:title)
          meeting_url(author) # is a Decidim::Meetings::Meeting
        else
          root_url # is a Decidim::Organization
        end
      end

      def meeting_url(meeting)
        Decidim::EngineRouter.main_proxy(meeting.component).meeting_url(id: meeting.id, host:)
      end

      def additional_fields
        {
          nickname: resource.authors.map do |author|
            author_nickname(author)
          end,
          email: resource.authors.map do |author|
            author_email(author)
          end,
          phone_number: author_phone_number(resource.authors.map(&:id))
        }
      end

      def author_nickname(author)
        if author.respond_to?(:nickname)
          translated_attribute(author.nickname)
        else
          ""
        end
      end

      def author_email(author)
        if author.respond_to?(:email)
          translated_attribute(author.email)
        else
          ""
        end
      end

      # author_phone_number retrieve the phone number of a user stored from phone_authorization_handler
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
