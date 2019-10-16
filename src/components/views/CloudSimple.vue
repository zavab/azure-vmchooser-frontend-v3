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
        <input class="form-control" placeholder="Minimum amount of (usable) storage needed" type="text" v-model="storage">
        <span class="input-group-addon">TB</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="ftt">
          <option disabled value="">Failures To Tolerate ("N + FTT")</option>
          <option value="0">No Protection</option>
          <option value="1">N+1</option>
          <option value="2">N+2</option>
          <option value="3">N+3</option>
        </select>
        <span class="input-group-addon">FTT</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="ftm">
          <option disabled value="">Fault Tolerance Mode ("Storage Raid")</option>
          <option value="0">Raid0 - Stripe / Span</option>
          <option value="1">Raid1 - Mirroring</option>
          <option value="5">Raid5 - Erasure Coding - Single Parity per stripe</option>
          <option value="6">Raid6 - Erasure Coding - Parity + additional syndrome per stripe</option>
        </select>
        <span class="input-group-addon">FTM</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="overcommit">
          <option disabled value="">Overcommit Ratio (Cores)</option>
          <option value="1">1:1 - No Overcommit</option>
          <option value="2">2:1 - Cautious</option>
          <option value="4">4:1 - Safe</option>
          <option value="6">6:1 - Realistic</option>
          <option value="8">8:1 - Optimistic</option>
        </select>
        <span class="input-group-addon">Ratio</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control" v-model="deduplication">
          <option disabled value="">Data Deduplication Ratio</option>
          <option value="1">1:1 - No Deduplication</option>
          <option value="1.5">1.5:1 - Safe </option>
          <option value="2">2:1 - Realistic </option>
          <option value="3">3:1 - Optimistic</option>
        </select>
        <span class="input-group-addon">Ratio</span>
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
                  <td>Node Type</td>
                  <td>{{NodeType}}</td>
                </tr>
                <tr>
                  <td>Node Count</td>
                  <td>{{TotalNodes}}</td>
                </tr>

                <tr><td><br /></td></tr>

                <tr>
                  <td>Monthly price for entire configuration</td>
                  <td>{{TotalPricePerMonth}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Hourly price for entire configuration</td>
                  <td>{{TotalPricePerHour}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Total Cores</td>
                  <td>{{TotalCores}}</td>
                </tr>
                <tr>
                  <td>Total Memory (GB)</td>
                  <td>{{TotalMemoryGB}}</td>
                </tr>
                <tr>
                  <td>Total Storage - Raw (TB)</td>
                  <td>{{TotalStorageRawTB}}</td>
                </tr>
                <tr>
                  <td>Total Storage - FTM Enabled (TB)</td>
                  <td>{{TotalStorageUsableTB}}</td>
                </tr>

                <tr><td><br /></td></tr>

                <tr>
                  <td>Total Usable Nodes - Worst Case (FTT)</td>
                  <td>{{TotalNodesUsable}}</td>
                </tr>
                <tr>
                  <td>Total Usable Cores - Worst Case (FTT)</td>
                  <td>{{TotalCoresUsable}}</td>
                </tr>
                <tr>
                  <td>Total Memory (GB) - Worst Case (FTT)</td>
                  <td>{{TotalMemoryGBUsable}}</td>
                </tr>
                <tr>
                  <td>Total Storage - Raw (TB) - Worst Case (FTT)</td>
                  <td>{{TotalStorageRawTBUsable}}</td>
                </tr>
                <tr>
                  <td>Total Storage - FTM Enabled (TB) - Worst Case (FTT)</td>
                  <td>{{TotalStorageUsableTBUsable}}</td>
                </tr>

                <tr><td><br /></td></tr>

                <tr>
                  <td>Monthly price for one node</td>
                  <td>{{NodePricePerMonth}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Hourly price for one node</td>
                  <td>{{NodePricePerHour}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Total cores per Node</td>
                  <td>{{NodeCores}}</td>
                </tr>
                <tr>
                  <td>Memory (GB) per Node</td>
                  <td>{{NodeMemoryGB}}</td>
                </tr>
                <tr>
                  <td>Storage - Raw (TB) per Node</td>
                  <td>{{NodeStorageRawTB}}</td>
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
        currency: 'EUR',
        TotalPricePerHour: '',
        TotalPricePerMonth: '',
        TotalNodes: '',
        TotalCores: '',
        TotalMemoryGB: '',
        TotalStorageRawTB: '',
        TotalNodesUsable: '',
        TotalCoresUsable: '',
        TotalMemoryGBUsable: '',
        TotalStorageRawTBUsable: '',
        TotalStorageUsableTB: '',
        TotalStorageUsableTBUsable: '',
        NodeType: '',
        NodeCores: '',
        NodeMemoryGB: '',
        NodeStorageRawTB: '',
        NodePricePerHour: '',
        NodePricePerMonth: '',
        description: '',
        regions: [],
        region: 'us-east',
        overcommit: 6,
        deduplication: 2,
        ftt: 2,
        ftm: 6
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
          '&ftt=' + this.ftt +
          '&ftm=' + this.ftm +
          '&overcommit=' + this.overcommit +
          '&deduplication=' + this.deduplication +
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
            "TotalPricePerHour": 31.0503060,
            "TotalPricePerMonth": 22666.7233800,
            "TotalNodes": 4.0,
            "TotalNodesUsable": 2.0,
            "TotalCores": 144.0,
            "TotalCoresUsable": 72.0,
            "TotalMemoryGB": 2048.0,
            "TotalMemoryGBUsable": 1024.0,
            "TotalStorageRawTB": 45.00,
            "TotalStorageRawTBUsable": 22.50,
            "TotalStorageUsableTB": 29.7,
            "TotalStorageUsableTBUsable": 14.85,
            "NodeType": "cs36-payg-us-east",
            "NodeCores": 36.0,
            "NodeMemoryGB": 512.0,
            "NodeStorageRawTB": 11.25,
            "NodePricePerHour": 7.7625765,
            "NodePricePerMonth": 5666.6808450
          }
          */
          .then(response => {
            this.TotalPricePerHour = response.data['TotalPricePerHour'].toFixed(2)
            this.TotalPricePerMonth = response.data['TotalPricePerMonth'].toFixed(2)
            this.TotalNodes = response.data['TotalNodes']
            this.TotalNodesUsable = response.data['TotalNodesUsable']
            this.TotalCores = response.data['TotalCores']
            this.TotalCoresUsable = response.data['TotalCoresUsable']
            this.TotalMemoryGB = response.data['TotalMemoryGB']
            this.TotalMemoryGBUsable = response.data['TotalMemoryGBUsable']
            this.TotalStorageRawTB = response.data['TotalStorageRawTB']
            this.TotalStorageRawTBUsable = response.data['TotalStorageRawTBUsable']
            this.TotalStorageUsableTB = response.data['TotalStorageUsableTB']
            this.TotalStorageUsableTBUsable = response.data['TotalStorageUsableTBUsable']
            this.NodeType = response.data['NodeType']
            this.NodeCores = response.data['NodeCores']
            this.NodeMemoryGB = response.data['NodeMemoryGB']
            this.NodeStorageRawTB = response.data['NodeStorageRawTB']
            this.NodePricePerHour = response.data['NodePricePerHour'].toFixed(2)
            this.NodePricePerMonth = response.data['NodePricePerMonth'].toFixed(2)
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
