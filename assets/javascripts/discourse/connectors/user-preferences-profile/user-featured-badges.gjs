import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { hash } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { i18n } from "discourse-i18n";
import MultiSelect from "select-kit/components/multi-select";

export default class UserFeaturedBadges extends Component {
  @service site;

  @tracked
  featuredBadges = this.args.outletArgs.model.custom_fields.featured_badges
    .split(",")
    .map(Number);

  @action
  updateFeaturedBadges(value) {
    this.featuredBadges = value;
    this.args.outletArgs.model.custom_fields.featured_badges = [
      ...new Set(value),
    ].join(",");
  }

  <template>
    <div class="control-group pref-featured-badges">
      <label class="control-label">{{i18n "user.featured_badges.label"}}</label>
      <div class="controls">
        <MultiSelect
          @value={{this.featuredBadges}}
          @onChange={{this.updateFeaturedBadges}}
          @content={{@outletArgs.model.badges}}
          @options={{hash maximum=3}}
          @none="user.featured_badges.none"
        />
      </div>
      <div class="instructions">
        {{i18n "user.featured_badges.description"}}
      </div>
    </div>
  </template>
}
