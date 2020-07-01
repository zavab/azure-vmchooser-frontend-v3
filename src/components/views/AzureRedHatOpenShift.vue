<template>
  <section class="content">
    <div class="row center-block">
      <h2>Context</h2>
      <div>
        <div class="tab-content">
          <div class="input-group">
            <input class="form-control" placeholder="How many pods does the workload need at baseline (minimum)?" type="text" v-model="minpods">
            <span class="input-group-addon">Pods</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How many pods does the workload need at peak (maximum)?" type="text" v-model="maxpods">
            <span class="input-group-addon">Pods</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How many hours per month does the workload run at peak (maximum)?" type="text" v-model="maxduration">
            <span class="input-group-addon">Hours</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How much cores are required on average per pod?" type="text" v-model="cores">
            <span class="input-group-addon">Cores</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How much memory is required on average per pod?" type="text" v-model="memory">
            <span class="input-group-addon">GB</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="What is the amount of net (persistent/data) storage needed per pod?" type="text" v-model="storage">
            <span class="input-group-addon">GB</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="ftt">
              <option disabled value="">Failures To Tolerate ("N + FTT")</option>
              <option value="0">No Protection</option>
              <option value="1">N+1</option>
              <option value="2">N+2</option>
              <option value="3">N+3</option>
              <option value="AZ">Full Zone</option>
            </select>
            <span class="input-group-addon">FTT</span>
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
        </div>
      </div>

      <div class="input-group">
        <form @submit.prevent="findARO">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Optimize!</button>
        </form>
      </div>
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

  </section>
</template>

<script>
  // Axios needed for API Call
  import axios from 'axios'
  // Config
  import config from '../../config'

  export default {
    name: 'AzureRedHatOpenShift',
    data() {
      return {
        showsummary: '',
        posts: [],
        errors: [],
        response: '',
        loading: '',
        currency: 'EUR',
        region: 'europe-west',
        result: [],
        vmsizes: [],
        regions: [],
        mastervmsize: '',
        mastervmsizeprice: '',
        mastervmosdisk: '',
        mastervmosdiskprice: '',
        mastervmdatadiskconfig: '',
        mastervmdatadiskcapacity: '',
        mastervmdatadiskiops: '',
        mastervmdatadiskthroughput: '',
        mastervmdatadiskprice: '',
        mastervmsizemaxdisks: 64,
        maxnodes: 0,
        workervmsize: '',
        workervmsizeprice: '',
        workervmosdisk: '',
        workervmosdiskprice: '',
        workervmdatadiskconfig: '',
        workervmdatadiskcapacity: '',
        workervmdatadiskiops: '',
        workervmdatadiskthroughput: '',
        workervmdatadiskprice: '',
        workervmsizemaxdisks: 64,
        os: 'linux',
        contract: 'payg',
        minpods: '',
        maxpods: '',
        maxduration: '',
        cores: '',
        memory: '',
        storage: '',
        ftt: '',
        dummy: ''
      }
    },
    methods: {
      fixNumberFormatting(input) {
        return input.toLocaleString()
      },
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
      getVmSizeMaster(region, cores, memory, currency, contract, os) {
        var maxresults = '1'
        var vmchooserurl = config.apiGetVmSize +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&contract=' + contract +
          '&region=' + region +
          '&currency=' + currency +
          '&aromaster=' + 'Yes' +
          '&os=' + os
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.mastervmsize = response.data[0].Name
            this.mastervmsizeprice = response.data[0].Price * 730
            this.mastervmsizemaxdisks = response.data[0].MaxDataDiskCount
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      findARO() {
        /* Pod / Node Calc
          Source ; https://docs.microsoft.com/en-us/azure/openshift/openshift-faq
          Max 250 pods per node
          Max 100 nodes per cluster
        */

        /* Master node Calc
          Source ; https://docs.openshift.com/container-platform/4.3/scalability_and_performance/recommended-host-practices.html
          Number of worker nodes - CPU cores - Memory (GB)
          25 - 4 - 16
          100 - 8 - 32
          250 - 16 - 64
        */

        var mastercores = 4
        var mastermemory = 16

        if (this.maxnodes >= 250) {
          mastercores = 16
          mastermemory = 64
        }

        if (this.maxnodes >= 100) {
          mastercores = 8
          mastermemory = 32
        }

        this.getVmSizeMaster(this.region, mastercores, mastermemory, this.currency, this.contract, this.os)
      }
    },
    mounted: function () {
      this.getMetaDataRegions()
      // console.log(this.$appInsights)
      this.$appInsights.trackPageView('SqlChooser')
    }
  }
</script>


<style>
  table th {
    text-align: right;
  }

  table td {
    text-align: right;
  }
</style>
