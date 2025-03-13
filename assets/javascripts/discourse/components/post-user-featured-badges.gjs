import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";

const PostUserFeaturedBadges = <template>
  {{#each @badges as |badge|}}
    <span
      class={{concatClass "poster-icon" badge.className badge.tlClassnames}}
      title={{badge.title}}
    >
      <a href={{badge.url}}>
        {{#if badge.image}}
          <img src={{badge.image}} alt={{badge.title}} />
        {{else}}
          {{icon badge.icon}}
        {{/if}}
      </a>
    </span>
  {{/each}}
</template>;

export default PostUserFeaturedBadges;
