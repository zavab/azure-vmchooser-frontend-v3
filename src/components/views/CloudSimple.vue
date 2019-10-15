<template>
  <section class="content">
    <div class="row center-block">
      <h2>Parameters</h2>
      <div class="input-group">
        <input class="form-control" placeholder="Minimum number of cores needed" type="text" v-model="cores">
        <span class="input-group-addon">#</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Minimum amount of memory needed" type="text" v-model="memory">
        <span class="input-group-addon">GB</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Minimum amount of storage needed" type="text" v-model="storage">
        <span class="input-group-addon">TB</span>
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
          <option value="RUB">Russian Ruble</option>
        </select>
        <span class="input-group-addon">Currency</span>
      </div>
      <br />
      <div class="input-group">
        <form @submit.prevent="getCloudSimple">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Cloud Simple me!</button>
        </form>
      </div>
      <!-- errors -->
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div class="row center-block" v-if="NodeType && NodeType.length">
      <h2>CloudSimple Configuration</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <tbody>
                <tr>
                  <td>Monthly price for entire configuration</td>
                  <td>{{TotalPricePerMonth}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Node Type</td>
                  <td>{{NodeType}}</td>
                </tr>
                <tr><td><br /></td></tr>
                <tr>
                  <td>Capacity per Disk</td>
                  <td>{{diskcapacity}} GB</td>
                </tr>
                <tr>
                  <td>IOPS per Disk</td>
                  <td>{{diskiops}}</td>
                </tr>
                <tr>
                  <td>Throughput per Disk</td>
                  <td>{{diskthroughput}} MB/s</td>
                </tr>
                <tr v-if="diskcount > 1"><td><br /></td></tr>
                <tr v-if="diskcount > 1">
                  <td>Disk used in entire config</td>
                  <td>{{diskcount}}</td>
                </tr>
                <tr v-if="diskcount > 1">
                  <td>Capacity for entire config</td>
                  <td>{{configcapacity}} GB</td>
                </tr>
                <tr v-if="diskcount > 1">
                  <td>IOPS for entire config</td>
                  <td>{{configiops}}</td>
                </tr>
                <tr v-if="diskcount > 1">
                  <td>Throughput for entire config</td>
                  <td>{{configthroughput}} MB/s</td>
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
  import 'datatables.net'
  import 'datatables.net-bs'
  import axios from 'axios'
  import config from '../../config'

  export default {
    name: 'DiskChooser',
    mounted() {
      this.$appInsights.trackPageView('CloudSimple')
      this.getMetaDataRegions()
    },
    data() {
      return {
        posts: [],
        errors: [],
        response: '',
        loading: '',
        cores: '',
        memory: '',
        storage: '',
        NodeType: '',
        TotalPricePerMonth: '',
        currency: 'EUR',
        price: '',
        diskcount: '',
        maxdisks: '',
        tshirtsize: '',
        disktype: '',
        diskcapacity: '',
        diskiops: '',
        diskthroughput: '',
        configcapacity: '',
        configiops: '',
        configthroughput: '',
        description: '',
        regions: [],
        region: 'us-east'
      }
    },
    methods: {
      getMetaDataRegions() {
        var vmchooserurl = config.apiGetRegions
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
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
      getCloudSimple() {
        var vmchooserurl = config.apiGetCloudSimple +
          '?region=' + this.region +
          '&cores=' + this.cores +
          '&memory=' + this.memory +
          '&storage=' + this.storage +
          '&currency=' + this.currency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          /*
          {
            "TotalPricePerHour": 23.2877295,
            "TotalPricePerMonth": 17000.0425350,
            "TotalNodes": 3.0,
            "TotalCores": 108.0,
            "TotalMemoryGB": 1536.0,
            "TotalStorageRawTB": 33.75,
            "NodeType": "cs36-payg-us-east",
            "NodeCores": 36.0,
            "NodeMemoryGB": 512.0,
            "NodeStorageRawTB": 11.25,
            "NodePricePerHour": 7.7625765,
            "NodePricePerMonth": 5666.6808450
          }
          */
          .then(response => {
            this.NodeType = response.data['NodeType']
            this.TotalPricePerMonth = response.data['TotalPricePerMonth'].toFixed(2)
            if (!this.TotalPricePerMonth) {
              this.response = 'No results found'
            }
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
