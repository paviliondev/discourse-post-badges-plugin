export default {
  setupComponent(attrs, component) {
    if (attrs.model.custom_fields.featured_badges) {
      component.set('featuredBadges', attrs.model.custom_fields.featured_badges.split(',').map(b => Number(b)));
    }
    component.addObserver('featuredBadges', function() {
      if (this._state === 'destroying') return;
      
      let badges = component.get('featuredBadges');
      if (badges) {
        attrs.model.custom_fields.featured_badges = badges.join(',');
      }
    })
  }
}