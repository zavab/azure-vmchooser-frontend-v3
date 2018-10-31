<template>
  <section class="content">
    <div class="row center-block">
      <h2>Parameters</h2>
      <div class="input-group">
        <input class="form-control" placeholder="Backup Size on the source side" type="text" v-model="size">
        <span class="input-group-addon">GB</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Daily retention points" type="text" v-model="daily">
        <span class="input-group-addon">#</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Weekly retention points" type="text" v-model="weekly">
        <span class="input-group-addon">#</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Monthly retention points" type="text" v-model="monthly">
        <span class="input-group-addon">#</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Yearly retention points" type="text" v-model="yearly">
        <span class="input-group-addon">#</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="The daily change rate of the source data" type="text" v-model="churn">
        <span class="input-group-addon">%</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="The expected compression rate" type="text" v-model="compression">
        <span class="input-group-addon">%</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="resiliency">
          <option disabled value="">Select disk type</option>
          <option value="lrs">Single Region</option>
          <option value="grs">Replicated to Paired Region</option>
        </select>
        <span class="input-group-addon">Type</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="region">
          <option disabled value="">Deployment Region</option>
          <option v-for="region in regions" :value="region.Slug">
            {{ region.Name }}
          </option>
        </select>
        <span class="input-group-addon">Location</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="currency">
          <option disabled value="">Currency</option>
          <option value="EUR">Euro</option>
          <option value="USD">US Dollar</option>
          <option value="GBP">British Pound</option>
          <option value="AUD">Australian Dollar</option>
          <option value="JPY">Japanese Yen</option>
          <option value="CAD">Canadian Dollar</option>
          <option value="DKK">Danish Krone</option>
          <option value="CHF">Swiss Franc</option>
          <option value="SEK">Swedish Krona</option>
          <option value="IDR">Indonesian Rupee</option>
          <option value="INR">Indian Rupee</option>
        </select>
        <span class="input-group-addon">Currency</span>
      </div>
      <br />
      <div class="input-group">
        <form @submit.prevent="crunch">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Size me up! Before you go go...</button>
        </form>
      </div>
      <!-- errors -->
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{errormsg}}</p></div>
    </div>

    <div class="row center-block" v-if="calcTotalPrice > 0">
      <h2>Backup Sizer</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <tbody>
                <tr>
                  <td><b>Total Price</b></td>
                  <td>{{calcTotalPrice}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Instance</td>
                  <td>{{calcCostInstance}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Storage</td>
                  <td>{{calcCostStorage}} {{currency}}</td>
                </tr>
                <tr><td><br /></td></tr>
                <tr>
                  <td><b>Total size on backup vault</b></td>
                  <td>{{calcSizeTotal}} GB</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    
  </section>
</template>

<script>
  // Require needed datatables modules
  import 'datatables.net'
  import 'datatables.net-bs'
  // Axios needed for API Call
  import axios from 'axios'
  // Config
  import config from '../../config'

  export default {
    name: 'BackupChooser',
    mounted() {
      this.$appInsights.trackPageView('BackupChooser')
      this.getMetaDataRegions()
    },
    data() {
      return {
        posts: [],
        errors: [],
        response: '',
        errormsg: '',
        loading: '',
        daily: '',
        weekly: '',
        monthly: '',
        yearly: '',
        regions: [],
        region: 'europe-west',
        currency: 'EUR',
        resiliency: 'lrs',
        churn: '',
        compression: '',
        costinstance: '',
        coststorage: '',
        sizetotal: '',
        size: ''
      }
    },
    computed: {
      calcTotalPrice() {
        return this.fixNumberFormatting(parseFloat(this.costinstance) + parseFloat(this.coststorage))
      },
      calcCostInstance() {
        return this.fixNumberFormatting(parseFloat(this.costinstance))
      },
      calcCostStorage() {
        return this.fixNumberFormatting(parseFloat(this.coststorage))
      },
      calcSizeTotal() {
        return this.fixNumberFormatting(parseFloat(this.sizetotal))
      }
    },
    methods: {
      getMetaDataRegions() {
        var vmchooserurl = config.apiGetRegions
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.regions = response.data
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      fixNumberFormatting(input) {
        return input.toLocaleString()
      },
      crunch() {
        if (this.churn === undefined || this.churn === null) {
          this.churn = 2
        }
        if (this.compression === undefined || this.compression === null) {
          this.compression = 30
        }
        if (this.size === undefined || this.size === null) {
          this.size = 100
        }
        if (this.daily === undefined || this.daily === null) {
          this.daily = 0
        }
        if (this.weekly === undefined || this.weekly === null) {
          this.weekly = 0
        }
        if (this.monthly === undefined || this.monthly === null) {
          this.monthly = 0
        }
        if (this.yearly === undefined || this.yearly === null) {
          this.yearly = 0
        }

        var vmchooserurl = config.apiGetBackup +
          '?region=' + this.region +
          '&currency=' + this.currency +
          '&daily=' + this.daily +
          '&weekly=' + this.weekly +
          '&monthly=' + this.monthly +
          '&yearly=' + this.yearly +
          '&churn=' + this.churn +
          '&compression=' + this.compression +
          '&size=' + this.size +
          '&resiliency=' + this.resiliency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          /*
              {
                "CostInstance": "16.866",
                "SizeTotal": "1324.000",
                "CostStorage": "26.7967008000"
              }
          */
          .then(response => {
            this.costinstance = response.data['CostInstance']
            this.coststorage = response.data['CostStorage']
            this.sizetotal = response.data['SizeTotal']
            if (!this.response) {
              this.errormsg = 'No results found'
            }
            console.log(response)
          })
          .catch(e => {
            this.errors.push(e)
          })
      }
    }
  }
</script>

<style>
/* Using the bootstrap style, but overriding the font to not draw in
   the Glyphicons Halflings font as an additional requirement for sorting icons.

   An alternative to the solution active below is to use the jquery style
   which uses images, but the color on the images does not match adminlte.

@import url('/static/js/plugins/datatables/jquery.dataTables.min.css');
*/

@import url('/static/js/plugins/datatables/dataTables.bootstrap.css');

table.dataTable thead .sorting:after,
table.dataTable thead .sorting_asc:after,
table.dataTable thead .sorting_desc:after {
  font-family: 'FontAwesome';
}

table.dataTable thead .sorting:after {
  content: "\f0dc";
}

table.dataTable thead .sorting_asc:after {
  content: "\f0dd";
}

table.dataTable thead .sorting_desc:after {
  content: "\f0de";
}
</style>
