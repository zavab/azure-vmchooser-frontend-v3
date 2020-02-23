<template>
  <!-- Main content -->
  <section class="content">
    <!-- Info boxes -->
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">Issuer</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.iss">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">UPN</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.upn">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">family_name</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.family_name">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">given_name</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.given_name">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">name</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.name">
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-sm-6 col-xs-12">
        <div class="input-group">
          <label class="control-label">unique_name</label>
          <input class="form-control" placeholder="Minimum # cores" type="text" v-model="user.profile.unique_name">
        </div>
      </div>
    </div>

  </section>
  <!-- /.content -->
</template>

<script>

  import config from '../../config'
  import * as AuthenticationContext from 'adal-angular/lib/adal'

  export default {
    data() {
      return {
        user: []
      }
    },
    mounted() {
      this.$appInsights.trackPageView('Profile')
      this.authContext = new AuthenticationContext(config)
      this.user = this.authContext.getCachedUser()
      console.log(this.user)
      console.log(this.user.profile)
    }
  }
</script>

<style>
  .info-box {
    cursor: pointer;
  }

  .info-box-content {
    text-align: center;
    vertical-align: middle;
    display: inherit;
  }

  .fullCanvas {
    width: 100%;
  }
</style>
