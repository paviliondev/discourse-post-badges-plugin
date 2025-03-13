import { schedule } from "@ember/runloop";
import { hbs } from "ember-cli-htmlbars";
import { makeArray } from "discourse/lib/helpers";
import { withPluginApi } from "discourse/lib/plugin-api";
import { registerWidgetShim } from "discourse/widgets/render-glimmer";

const BADGE_CLASS = [
  "badge-type-gold",
  "badge-type-silver",
  "badge-type-bronze",
];

const TRUST_LEVEL_BADGE = ["basic", "member", "regular", "leader"];
const USER_BADGE_PAGE = "user's badge page";

function loadUserBadges({ allBadges, username, linkDestination }) {
  let badgePage = "";

  const isUserBadgePage = linkDestination === USER_BADGE_PAGE;
  if (isUserBadgePage) {
    badgePage = `?username=${username}`;
  }

  return makeArray(allBadges).map((badge) => {
    return {
      icon: badge.icon.replace("fa-", ""),
      image: badge.image_url ? badge.image_url : badge.image,
      className: BADGE_CLASS[badge.badge_type_id - 1],
      tlClassnames:
        badge.id >= 1 && badge.id <= 4 ? TRUST_LEVEL_BADGE[badge.id - 1] : "",
      name: badge.slug,
      id: badge.id,
      badgeGroup: badge.badge_grouping_id,
      title: badge.description.replace(/<\/?[^>]+(>|$)/g, ""),
      url: `/badges/${badge.id}/${badge.slug}${badgePage}`,
    };
  });
}

function addHighestTLClassname(widget, badges) {
  if (!widget || !badges) {
    return;
  }

  let trustLevel = "";
  let highestBadge = 0;

  badges.forEach((badge) => {
    if (badge.badgeGroup === 4 && badge.id > highestBadge) {
      highestBadge = badge.id;
      trustLevel = `${TRUST_LEVEL_BADGE[highestBadge - 1]}-highest`;
    }
  });

  if (trustLevel) {
    widget._componentInfo.element.classList.add(trustLevel);
  }
}

export default {
  name: "discourse-post-badges-plugin",

  initialize(container) {
    withPluginApi((api) => {
      const siteSettings = container.lookup("service:site-settings");
      const isMobileView = container.lookup("service:site").mobileView;
      const location = isMobileView ? "before" : "after";

      let containerClassname = ["poster-icon-container"];
      if (siteSettings.post_badges_only_show_highest_trust_level) {
        containerClassname.push("show-highest");
      }

      registerWidgetShim(
        "featured-badges",
        `div.${containerClassname.join(".")}`,
        hbs`<PostUserFeaturedBadges @badges={{@data.badges}} @tagName="" />`
      );

      api.includePostAttributes("user_badges");

      api.decorateWidget(`poster-name:${location}`, (decorator) => {
        const { user_badges: allBadges, username } = decorator.attrs;
        const linkDestination = siteSettings.post_badges_badge_link_destination;
        const badges = loadUserBadges({
          allBadges,
          username,
          linkDestination,
        });

        const widget = decorator.attach("featured-badges", { badges });

        schedule("afterRender", () => {
          addHighestTLClassname(widget, badges);
        });

        return widget;
      });
    });
  },
};
