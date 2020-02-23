// Import ES6 Promise
import 'es6-promise/auto'

// Import System requirements
import Vue from 'vue'
import VueRouter from 'vue-router'

import { sync } from 'vuex-router-sync'
import routes from './routes'
import store from './store'

// Import Helpers for filters
import { domain, count, prettyDate, pluralize } from './filters'

// Import Views - Top level
import AppView from './components/App.vue'

// Import Install and register helper items
Vue.filter('count', count)
Vue.filter('domain', domain)
Vue.filter('prettyDate', prettyDate)
Vue.filter('pluralize', pluralize)

Vue.use(VueRouter)

import config from './config'

// Application Insights Tracking
import VueAppInsights from 'vue-application-insights'
Vue.use(VueAppInsights, {
  id: config.appinsightsid,
  router
})

// Routing logic
var router = new VueRouter({
  routes: routes,
  mode: 'history',
  linkExactActiveClass: 'active',
  scrollBehavior: function (to, from, savedPosition) {
    return savedPosition || { x: 0, y: 0 }
  }
})

// AAD
import * as AuthenticationContext from 'adal-angular/lib/adal'
var authContext = new AuthenticationContext(config)

router.beforeEach((to, from, next) => {
  if (authContext.isCallback(window.location.hash) || window.self !== window.top) {
    authContext.handleWindowCallback()
  }
  if (to.meta.requiresAuthentication) {
    var user = authContext.getCachedUser()
    if (typeof (user) !== 'undefined' && user !== null) {
      // console.log(user.profile)
    } else {
      console.log('not logged in')
      authContext.login()
    }
    next()
  } else {
    next()
  }
})

// Not Sure what this does again... #honest
sync(store, router)

// Start out app!
// eslint-disable-next-line no-new
new Vue({
  el: '#root',
  router: router,
  store: store,
  render: h => h(AppView)
})
