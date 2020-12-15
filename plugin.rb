# frozen_string_literal: true

# name: discourse-post-badges-plugin
# about: A plugin built based on the Official Discourse Post Badges Theme Component
# version: 0.1
# author: Faizaan Gagan
# url: https://github.com/discourse/discourse-calendar
# based on: https://github.com/discourse/discourse-post-badges

enabled_site_setting :post_badges_plugin_enabled
register_asset 'stylesheets/common.scss'
after_initialize do
  add_to_serializer(:post, :user_badges) do
    ActiveModel::ArraySerializer.new(object&.user&.badges, each_serializer: BadgeSerializer).as_json
  end
end
