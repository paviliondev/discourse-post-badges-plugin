# frozen_string_literal: true

# name: discourse-post-badges-plugin
# about: A plugin built based on the Official Discourse Post Badges Theme Component
# version: 0.1
# author: Faizaan Gagan
# url: https://github.com/paviliondev/discourse-post-badges-plugin
# based on: https://github.com/discourse/discourse-post-badges

enabled_site_setting :post_badges_plugin_enabled
register_asset 'stylesheets/common.scss'

after_initialize do
  register_editable_user_custom_field(:featured_badges)
  
  add_to_serializer(:user, :custom_fields) { object.custom_fields }
  add_to_serializer(:user, :badges) do
    badges = []
    
    object.badges.each do |b|
      b.icon.gsub! "fa-", ""
      badges.push(b)
    end
    
    ActiveModel::ArraySerializer.new(
      badges,
      each_serializer: BadgeSerializer
    ).as_json
  end
  
  add_to_serializer(:post, :user_badges) do
    ActiveModel::ArraySerializer.new(object&.user&.featured_badges, each_serializer: BadgeSerializer).as_json
  end
  
  add_to_serializer(:post, :include_user_badges?) do
    object&.user&.featured_badges.present?
  end
  
  add_to_class(:user, :featured_badges) do
    if custom_fields['featured_badges'] != nil && (
        featured_badges = custom_fields['featured_badges'].split(',').map(&:to_i)
      ).present?
      badges.select { |b| featured_badges.include?(b.id) }
    else
      []
    end
  end
end
