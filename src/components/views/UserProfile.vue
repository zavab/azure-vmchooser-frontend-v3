<template>
  <!-- Main content -->
  <section class="content">
    <!-- Info boxes -->
    <div class="row">
      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> VMchooser is open source!</h4>
        Click on icon to check it out on github. <a href="https://github.com/kvaes?tab=repositories&q=vmchooser" target="_blank"><i class="fa fa-github fa-2x"></i></a>
      </div>
      <div class="col-md-3 col-sm-6 col-xs-12">
        <router-link class="pageLink" to="/vmchooser">
          <div class="info-box">
            <span class="info-box-icon bg-aqua"><i class="fa fa-desktop"></i></span>
            <div class="info-box-content">
              <span class="info-box-number">VMchooser</span>
              <span class="info-box-text"><small>VM T-Shirt Size</small></span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </router-link>
      </div>
      <!-- /.col -->
      <div class="col-md-3 col-sm-6 col-xs-12">
        <router-link class="pageLink" to="/diskchooser">
          <div class="info-box">
            <span class="info-box-icon bg-aqua"><i class="fa fa-database"></i></span>
            <div class="info-box-content">
              <span class="info-box-number">Data Disk Configurator</span>
              <span class="info-box-text"><small>Disk config</small></span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </router-link>
      </div>
      <!-- /.col -->
      <div class="col-md-3 col-sm-6 col-xs-12">
        <router-link class="pageLink" to="/bulkuploader">
          <div class="info-box">
            <span class="info-box-icon bg-aqua"><i class="fa fa-sliders-h"></i></span>
            <div class="info-box-content">
              <span class="info-box-number">Bulk Uploader</span>
              <span class="info-box-text"><small>Upload CSV</small></span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </router-link>
      </div>
      <!-- /.col -->
      <div class="col-md-3 col-sm-6 col-xs-12">
        <router-link class="pageLink" to="/vmoptimizer">
          <div class="info-box">
            <span class="info-box-icon bg-aqua"><i class="fa fa-balance-scale"></i></span>
            <div class="info-box-content">
              <span class="info-box-number">VM Optimizer</span>
              <span class="info-box-text"><small>Budget Optimization</small></span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </router-link>
      </div>
      <!-- /.col -->
      <!-- /.col -->
      <div class="col-md-3 col-sm-6 col-xs-12">
        <router-link class="pageLink" to="/sqlchooser">
          <div class="info-box">
            <span class="info-box-icon bg-aqua"><i class="fa fa-coins"></i></span>
            <div class="info-box-content">
              <span class="info-box-number">SQL Service Finder (Preview)</span>
              <span class="info-box-text"><small>SQL Deploys</small></span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
        </router-link>
      </div>
      <!-- /.col -->
      <!-- fix for small devices only -->
      <div class="clearfix visible-sm-block"></div>
    </div>
    <!-- /.row -->

  </section>
  <!-- /.content -->
</template>

<script>

export default {
  data () {
    return {
      generateRandomNumbers (numbers, max, min) {
        var a = []
        for (var i = 0; i < numbers; i++) {
          a.push(Math.floor(Math.random() * (max - min + 1)) + max)
        }
        return a
      }
    }
  },
  computed: {
    coPilotNumbers () {
      return this.generateRandomNumbers(12, 1000000, 10000)
    },
    personalNumbers () {
      return this.generateRandomNumbers(12, 1000000, 10000)
    },
    isMobile () {
      return (window.innerWidth <= 800 && window.innerHeight <= 600)
    }
  },
  mounted() {
    this.$appInsights.trackPageView('UserProfile')
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
