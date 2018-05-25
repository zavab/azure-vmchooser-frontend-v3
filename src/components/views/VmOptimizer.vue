<template>
  <section class="content">
    <div class="row center-block">
      <h2>Context</h2>
      <div>
        <div class="tab-content">
          <div class="input-group">
            <select class="form-control" v-model="vmsize">
              <option disabled value="">Select VM Size</option>
              <option v-for="vmsizeinfo in vmsizes" :value="vmsizeinfo.Slug">
                {{ vmsizeinfo.Name }}
              </option>
            </select>
            <span class="input-group-addon">Name</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How many hours per month will the VM be running?" type="text" v-model="runtimepermonth">
            <span class="input-group-addon">Hours</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="What is the expected lifetime of the VM?" type="text" v-model="runtimeinmonths">
            <span class="input-group-addon">Months</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="tier">
              <option disabled value="">Select VM Tier</option>
              <option value="standard">Standard</option>
              <option value="lowpriority">Low Priority</option>
              <option value="basic">Basic</option>
            </select>
            <span class="input-group-addon">Tier</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="region">
              <option disabled value="">Deployment region</option>
              <option value="asia-pacific-east">Asia Pacific East</option>
              <option value="asia-pacific-southeast">Asia Pacific South-East</option>
              <option value="australia-east">Australia East</option>
              <option value="australia-southeast">Australia South East</option>
              <option value="brazil-south">Brazil South</option>
              <option value="canada-central">Canada Central</option>
              <option value="canada-east">Canada East</option>
              <option value="central-india">India Central</option>
              <option value="west-india">India West</option>
              <option value="south-india">India South</option>
              <option value="europe-north">Europe North</option>
              <option value="europe-west" selected="selected">Europe West</option>
              <option value="france-central">France Central</option>
              <option value="france-south">France South</option>
              <option value="germany-central">Germany Central</option>
              <option value="germany-northeast">Germany North East</option>
              <option value="japan-east">Japan East</option>
              <option value="japan-west">Japan West</option>
              <option value="korea-central">Korea Central</option>
              <option value="korea-south">Korea South</option>
              <option value="united-kingdom-south">UK South</option>
              <option value="united-kingdom-west">UK West</option>
              <option value="us-central">US Central</option>
              <option value="us-east">US East</option>
              <option value="us-east-2">US East 2</option>
              <option value="usgov-arizona">US Gov Arizona</option>
              <option value="usgov-iowa">US Gov Iowa</option>
              <option value="usgov-texas">US Gov Texas</option>
              <option value="usgov-virginia">US Gov Virginia</option>
              <option value="us-north-central">US North Central</option>
              <option value="us-south-central">US South Central</option>
              <option value="us-west">US West</option>
              <option value="us-west-2">US West 2</option>
              <option value="us-west-central">US West Central</option>
              <option value="all">Just give me all options!</option>
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
        </div>
      </div>

      <div class="input-group">
        <form @submit.prevent="checkCreds">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Optimize!</button>
        </form>
      </div>
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div class="row center-block" v-if="result.Name">
      <h2>Various pricing options for {{result.Name}}</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">Contract</th>
                  <th colspan="1" rowspan="1">Linux (per Hour)</th>
                  <th colspan="1" rowspan="1">Linux (per Month)</th>
                  <th colspan="1" rowspan="1">Difference Linux vs Windows (per Month)</th>
                  <th colspan="1" rowspan="1">Windows (per Hour)</th>
                  <th colspan="1" rowspan="1">Windows (per Month)</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>PAYG</td>
                  <td>{{result.Price_Linux_PAYG}} {{currency}} </td>
                  <td>{{Price_Linux_PAYG_Month}} {{currency}} </td>
                  <td>{{Diff_Os_PAYG_Month}} {{currency}} </td>
                  <td>{{result.Price_Windows_PAYG}} {{currency}} </td>
                  <td>{{Price_Windows_PAYG_Month}} {{currency}} </td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI1Y">
                  <td colspan="6"></td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI1Y">
                  <td>RI1Y</td>
                  <td>{{result.Price_Linux_RI1Y}} {{currency}} </td>
                  <td>{{Price_Linux_RI1Y_Month}} {{currency}} </td>
                  <td>{{Diff_Os_RI1Y_Month}} {{currency}} </td>
                  <td>{{result.Price_Windows_RI1Y}} {{currency}} </td>
                  <td>{{Price_Windows_RI1Y_Month}} {{currency}} </td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI1Y">
                  <td></td>
                  <td>{{result.Diff_Linux_RI1Y}} {{currency}}</td>
                  <td>(-{{Diff_Linux_RI1Y_Percentage}}%) {{Diff_Linux_RI1Y_Month}} {{currency}}</td>
                  <td></td>
                  <td>{{result.Diff_Windows_RI1Y}} {{currency}}</td>
                  <td>(-{{Diff_Windows_RI1Y_Percentage}}%) {{Diff_Windows_RI1Y_Month}} {{currency}}</td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI3Y">
                  <td colspan="6"></td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI3Y">
                  <td>RI3Y</td>
                  <td>{{result.Price_Linux_RI3Y}} {{currency}} </td>
                  <td>{{Price_Linux_RI3Y_Month}} {{currency}} </td>
                  <td>{{Diff_Os_RI3Y_Month}} {{currency}} </td>
                  <td>{{result.Price_Windows_RI3Y}} {{currency}} </td>
                  <td>{{Price_Windows_RI3Y_Month}} {{currency}} </td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI3Y">
                  <td></td>
                  <td>{{result.Diff_Linux_RI3Y}} {{currency}}</td>
                  <td>(-{{Diff_Linux_RI3Y_Percentage}}%) {{Diff_Linux_RI3Y_Month}} {{currency}}</td>
                  <td></td>
                  <td>{{result.Diff_Windows_RI3Y}} {{currency}}</td>
                  <td>(-{{Diff_Windows_RI3Y_Percentage}}%) {{Diff_Windows_RI3Y_Month}} {{currency}}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="row center-block" v-if="result.Name">
      <h2>Projecting a usage of {{runtimepermonth}} hours per month, for a total of {{runtimeinmonths}} months</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">Contract</th>
                  <th colspan="1" rowspan="1">Linux</th>
                  <th colspan="1" rowspan="1">Windows PAYG License</th>
                  <th colspan="1" rowspan="1">Windows</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>PAYG</td>
                  <td>{{RuntimeCost_Linux_PAYG}} {{currency}} </td>
                  <td>{{Diff_RuntimeCost_PAYG}} {{currency}} </td>
                  <td>{{RuntimeCost_Windows_PAYG}} {{currency}} </td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI1Y">
                  <td>RI1Y</td>
                  <td>({{RuntimeCost_Linux_RI1Y_Percentage}}%) {{RuntimeCost_Linux_RI1Y}} {{currency}} </td>
                  <td>{{Diff_RuntimeCost_RI1Y}} {{currency}} </td>
                  <td>({{RuntimeCost_Windows_RI1Y_Percentage}}%) {{RuntimeCost_Windows_RI1Y}} {{currency}} </td>
                </tr>
                <tr role="row" v-if="result.Price_Linux_RI3Y">
                  <td>RI3Y</td>
                  <td>({{RuntimeCost_Linux_RI3Y_Percentage}}%) {{RuntimeCost_Linux_RI3Y}} {{currency}} </td>
                  <td>{{Diff_RuntimeCost_RI3Y}} {{currency}} </td>
                  <td>({{RuntimeCost_Windows_RI3Y_Percentage}}%) {{RuntimeCost_Windows_RI3Y}} {{currency}} </td>
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
  // Axios needed for API Call
  import axios from 'axios'
  // Config
  import config from '../../config'

  export default {
    name: 'VmOptimizer',
    data() {
      return {
        posts: [],
        errors: [],
        response: '',
        loading: '',
        tier: 'standard',
        currency: 'EUR',
        region: 'europe-west',
        vmsize: '',
        runtimepermonth: '',
        runtimeinmonths: '',
        result: [],
        vmsizes: []
      }
    },
    computed: {
      Diff_Linux_RI3Y_Percentage: function () {
        return ((this.result.Diff_Linux_RI3Y / this.result.Price_Linux_PAYG) * 100).toPrecision(2)
      },
      Diff_Windows_RI3Y_Percentage: function () {
        return ((this.result.Diff_Windows_RI3Y / this.result.Price_Windows_PAYG) * 100).toPrecision(2)
      },
      Diff_Linux_RI1Y_Percentage: function () {
        return ((this.result.Diff_Linux_RI1Y / this.result.Price_Linux_PAYG) * 100).toPrecision(2)
      },
      Diff_Windows_RI1Y_Percentage: function () {
        return ((this.result.Diff_Windows_RI1Y / this.result.Price_Windows_PAYG) * 100).toPrecision(2)
      },
      Diff_Windows_RI3Y_Month: function () {
        return (this.result.Diff_Windows_RI3Y * 730).toFixed(2)
      },
      Diff_Windows_RI1Y_Month: function () {
        return (this.result.Diff_Windows_RI1Y * 730).toFixed(2)
      },
      Diff_Linux_RI3Y_Month: function () {
        return (this.result.Diff_Linux_RI3Y * 730).toFixed(2)
      },
      Diff_Linux_RI1Y_Month: function () {
        return (this.result.Diff_Linux_RI1Y * 730).toFixed(2)
      },
      Price_Linux_PAYG_Month: function () {
        return (this.result.Price_Linux_PAYG * 730).toFixed(2)
      },
      Price_Linux_RI1Y_Month: function () {
        return (this.result.Price_Linux_RI1Y * 730).toFixed(2)
      },
      Price_Linux_RI3Y_Month: function () {
        return (this.result.Price_Linux_RI3Y * 730).toFixed(2)
      },
      Price_Windows_PAYG_Month: function () {
        return (this.result.Price_Windows_PAYG * 730).toFixed(2)
      },
      Price_Windows_RI1Y_Month: function () {
        return (this.result.Price_Windows_RI1Y * 730).toFixed(2)
      },
      Price_Windows_RI3Y_Month: function () {
        return (this.result.Price_Windows_RI3Y * 730).toFixed(2)
      },
      Diff_Os_PAYG_Month: function () {
        return (this.result.Diff_Os_PAYG * 730)
      },
      Diff_Os_RI1Y_Month: function () {
        return (this.result.Diff_Os_RI1Y * 730)
      },
      Diff_Os_RI3Y_Month: function () {
        return (this.result.Diff_Os_RI3Y * 730)
      },
      RuntimeCost_Linux_PAYG: function () {
        return (this.result.Price_Linux_PAYG * this.runtimepermonth * this.runtimeinmonths).toFixed(2)
      },
      RuntimeCost_Linux_RI1Y: function () {
        return (this.Price_Linux_RI1Y_Month * this.runtimeinmonths).toFixed(2)
      },
      RuntimeCost_Linux_RI3Y: function () {
        return (this.Price_Linux_RI3Y_Month * this.runtimeinmonths).toFixed(2)
      },
      RuntimeCost_Windows_PAYG: function () {
        return (this.result.Price_Windows_PAYG * this.runtimepermonth * this.runtimeinmonths).toFixed(2)
      },
      RuntimeCost_Windows_RI1Y: function () {
        return (this.Price_Windows_RI1Y_Month * this.runtimeinmonths).toFixed(2)
      },
      RuntimeCost_Windows_RI3Y: function () {
        return (this.Price_Windows_RI3Y_Month * this.runtimeinmonths).toFixed(2)
      },
      Diff_RuntimeCost_PAYG: function () {
        return (this.RuntimeCost_Windows_PAYG - this.RuntimeCost_Linux_PAYG).toFixed(2)
      },
      Diff_RuntimeCost_RI1Y: function () {
        return (this.RuntimeCost_Windows_RI1Y - this.RuntimeCost_Linux_RI1Y).toFixed(2)
      },
      Diff_RuntimeCost_RI3Y: function () {
        return (this.RuntimeCost_Windows_RI3Y - this.RuntimeCost_Linux_RI3Y).toFixed(2)
      },
      RuntimeCost_Windows_RI1Y_Percentage: function () {
        if (parseFloat(this.RuntimeCost_Windows_RI1Y) > parseFloat(this.RuntimeCost_Windows_PAYG)) {
          console.log('larger')
          console.log(this.RuntimeCost_Windows_RI1Y + ' > ' + this.RuntimeCost_Windows_PAYG)
          return ((1 - (this.RuntimeCost_Windows_PAYG / this.RuntimeCost_Windows_RI1Y)) * 100).toPrecision(2)
        } else {
          console.log('smaller')
          console.log(this.RuntimeCost_Windows_RI1Y + ' > ' + this.RuntimeCost_Windows_PAYG)
          return ((1 - (this.RuntimeCost_Windows_RI1Y / this.RuntimeCost_Windows_PAYG)) * 100).toPrecision(2)
        }
      },
      RuntimeCost_Windows_RI3Y_Percentage: function () {
        if (parseFloat(this.RuntimeCost_Windows_RI3Y) > parseFloat(this.RuntimeCost_Windows_PAYG)) {
          console.log('larger')
          console.log(this.RuntimeCost_Windows_RI3Y + ' > ' + this.RuntimeCost_Windows_PAYG)
          return ((1 - (this.RuntimeCost_Windows_PAYG / this.RuntimeCost_Windows_RI3Y)) * 100).toPrecision(2)
        } else {
          console.log('smaller')
          console.log(this.RuntimeCost_Windows_RI3Y + ' > ' + this.RuntimeCost_Windows_PAYG)
          return ((1 - (this.RuntimeCost_Windows_RI3Y / this.RuntimeCost_Windows_PAYG)) * 100).toPrecision(2)
        }
      },
      RuntimeCost_Linux_RI1Y_Percentage: function () {
        if (parseFloat(this.RuntimeCost_Linux_RI1Y) > parseFloat(this.RuntimeCost_Linux_PAYG)) {
          console.log('larger')
          console.log(this.RuntimeCost_Linux_RI1Y + ' > ' + this.RuntimeCost_Linux_PAYG)
          return ((1 - (this.RuntimeCost_Linux_PAYG / this.RuntimeCost_Linux_RI1Y)) * 100).toPrecision(2)
        } else {
          console.log('smaller')
          console.log(this.RuntimeCost_Linux_RI1Y + ' > ' + this.RuntimeCost_Linux_PAYG)
          return ((1 - (this.RuntimeCost_Linux_RI1Y / this.RuntimeCost_Linux_PAYG)) * 100).toPrecision(2)
        }
      },
      RuntimeCost_Linux_RI3Y_Percentage: function () {
        if (parseFloat(this.RuntimeCost_Linux_RI3Y) > parseFloat(this.RuntimeCost_Linux_PAYG)) {
          console.log('larger')
          console.log(this.RuntimeCost_Linux_RI3Y + ' > ' + this.RuntimeCost_Linux_PAYG)
          return ((1 - (this.RuntimeCost_Linux_PAYG / this.RuntimeCost_Linux_RI3Y)) * 100).toPrecision(2)
        } else {
          console.log('smaller')
          console.log(this.RuntimeCost_Linux_RI3Y + ' > ' + this.RuntimeCost_Linux_PAYG)
          return ((1 - (this.RuntimeCost_Linux_RI3Y / this.RuntimeCost_Linux_PAYG)) * 100).toPrecision(2)
        }
      }
    },
    methods: {
      getMetaData() {
        var vmchooserurl = config.apiGetVmSizes
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            console.log(response.data)
            this.vmsizes = response.data
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      checkCreds() {
        const { vmsize, tier, region, currency } = this
        if (this.runtimeinmonths < 1) {
          this.runtimeinmonths = 12
        }
        if (this.runtimepermonth < 1) {
          this.runtimepermonth = 730
        }
        var vmchooserurl = config.apiCalcVmOptimizations + '?vmsize=' + vmsize + '&tier=' + tier + '&region=' + region + '&currency=' + currency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          /*
          {

            "Currency": "EUR",
            "Name": "f8",
            "Tier": "standard",
            "Region": "europe-west",
            "Price_Windows_PAYG": 0.822,
            "Price_Windows_RI1Y": 0.70008,
            "Price_Windows_RI3Y": 0.59011,
            "Price_Linux_PAYG": 0.454,
            "Price_Linux_RI1Y": 0.33208,
            "Price_Linux_RI3Y": 0.22211,
            "Diff_Os_PAYG": 0.368,
            "Diff_Os_RI1Y": 0.36800,
            "Diff_Os_RI3Y": 0.36800,
            "Diff_Windows_RI1Y": 0.12192,
            "Diff_Windows_RI3Y": 0.23189,
            "Diff_Linux_RI1Y": 0.12192,
            "Diff_Linux_RI3Y": 0.23189
          }
          */
          .then(response => {
            this.setResult(response.data)
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      setResult(result) {
        // console.log(result)
        this.result = result
      }
    },
    mounted: function () {
      this.getMetaData()
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
