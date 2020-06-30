<template>
  <section class="content">
    <div class="row center-block">
      <h2>Context</h2>
      <div>
        <div class="tab-content">
          <div class="input-group">
            <input class="form-control" placeholder="How many cores does the workload need at minimum?" type="text" v-model="cores">
            <span class="input-group-addon">Cores</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How much memory is required at minimum?" type="text" v-model="memory">
            <span class="input-group-addon">GB</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="What is the amount of net (persistent/data) storage the workload needs at minimum?" type="text" v-model="data">
            <span class="input-group-addon">GB</span>
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
        cores: '',
        memory: '',
        data: '',
        iops: '',
        throughput: '',
        license: 'no',
        result: [],
        vmsizes: [],
        regions: [],
        sla: '',
        vmsize: '',
        vmsizeprice: '',
        vmosdisk: '',
        vmosdiskprice: '',
        vmdatadiskconfig: '',
        vmdatadiskcapacity: '',
        vmdatadiskiops: '',
        vmdatadiskthroughput: '',
        vmdatadiskprice: '',
        vmsizemaxdisks: 64,
        os: '',
        contract: 'payg',
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
          '&os=' + os +
          '&burstable=no'
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.vmsize = response.data[0].Name
            this.vmsizeprice = response.data[0].Price * 730
            this.vmsizemaxdisks = response.data[0].MaxDataDiskCount
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      findARO() {
        this.getVmSize(this.region, this.cores, this.memory, this.currency, this.contract, this.os)
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
