<template>
  <!-- Main content -->
  <section class="content">

  </section>
  <!-- /.content -->
</template>

<script>

  import config from '../../config'
  import * as AuthenticationContext from 'adal-angular/lib/adal'

  export default {
    mounted() {
      this.$appInsights.trackPageView('Logout')
      this.authContext = new AuthenticationContext(config)
      this.authContext.logOut()
    }
  }
</script>
