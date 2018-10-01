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
          <span class="help-block" v-if="data >= 1024">Have you considered SQL DW for this kind of workload?</span>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="What is the minimum performance level you expect from the (persistent/data) storage?" type="text" v-model="iops">
            <span class="input-group-addon">IOPS</span>
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
            <select class="form-control" v-model="license">
              <option disabled value="">Do you want to bring your own licenses?</option>
              <option value="no">No. There are no licenses present...</option>
              <option value="yes">Yes, please! We'll bring our own licenses.</option>
            </select>
            <span class="input-group-addon">Hybrid Use Benefit</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="contract">
              <option disabled value="">Do you want a specific contract form?</option>
              <option value="payg">Pay-as-you-Go</option>
              <option value="ri1y">Reserved Instances - 1 year term</option>
              <option value="ri3y">Reserved Instances - 3 year term</option>
            </select>
            <span class="input-group-addon">%</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="sla">
              <option disabled value="">What is the minimum uptime SLA do you require?</option>
              <option value="9">99,9</option>
              <option value="95">99,95</option>
              <option value="99">99,99</option>
            </select>
            <span class="input-group-addon">%</span>
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
        <form @submit.prevent="findSQL">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Optimize!</button>
        </form>
      </div>
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div class="row center-block" v-if="showsummary">
      <h2>Summary Overview</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">Scenario</th>
                  <th colspan="1" rowspan="1">Compute</th>
                  <th colspan="1" rowspan="1">Storage</th>
                  <th colspan="1" rowspan="1">Total</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row" v-if="vmsizeprice > 0">
                  <td>IaaS : VM Based</td>
                  <td>{{calcVmSizePrice}} {{currency}}</td>
                  <td>{{calcVmStoragePrice}} {{currency}}</td>
                  <td>{{calcTotalPrice}} {{currency}}</td>
                </tr>
                <tr role="row" v-if="singleTotalPrice > 0">
                  <td>PaaS : Single Database</td>
                  <td>{{singleComputePrice}} {{currency}}</td>
                  <td>{{singleStoragePrice}} {{currency}}</td>
                  <td>{{calcSingleTotalPrice}} {{currency}}</td>
                </tr>
                <tr role="row" v-if="elasticTotalPrice > 0">
                  <td>PaaS : Elastic Database</td>
                  <td>{{elasticComputePrice}} {{currency}}</td>
                  <td>{{elasticStoragePrice}} {{currency}}</td>
                  <td>{{calcElasticTotalPrice}} {{currency}}</td>
                </tr>
                <tr role="row" v-if="managedTotalPrice > 0">
                  <td>PaaS : Managed Instance</td>
                  <td>{{managedComputePrice}} {{currency}}</td>
                  <td>{{managedStoragePrice}} {{currency}}</td>
                  <td>{{calcManagedTotalPrice}} {{currency}}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div class="row center-block" v-if="vmsizeprice > 0">
      <h2>IaaS : Based on virtual machines</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">Resiliency</th>
                  <th colspan="1" rowspan="1">Node Count</th>
                  <th colspan="1" rowspan="1">OS</th>
                  <th colspan="1" rowspan="1">VM Size</th>
                  <th colspan="1" rowspan="1">Compute (per Month)</th>
                  <th colspan="1" rowspan="1">OS Disk</th>
                  <th colspan="1" rowspan="1">OS Disk(s) Price (per Month)</th>
                  <th colspan="1" rowspan="1">Data Disk Config</th>
                  <th colspan="1" rowspan="1">Data Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Data IOPS</th>
                  <th colspan="1" rowspan="1">Data Throughput (MB/s)</th>
                  <th colspan="1" rowspan="1">Data Disk(s) (per Month)</th>
                  <th colspan="1" rowspan="1">Total Price (per Month)</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>{{calcMethod}} </td>
                  <td>{{calcNodeCount}}</td>
                  <td>{{os}} </td>
                  <td>{{vmsize}} </td>
                  <td>{{calcVmSizePrice}} {{currency}} </td>
                  <td>{{vmosdisk}} </td>
                  <td>{{calcVmOsDiskPrice}} {{currency}} </td>
                  <td>{{vmdatadiskconfig}} </td>
                  <td>{{vmdatadiskcapacity}} </td>
                  <td>{{vmdatadiskiops}} </td>
                  <td>{{vmdatadiskthroughput}} </td>
                  <td>{{calcVmDataDiskPrice}} {{currency}} </td>
                  <td>{{calcTotalPrice}} {{currency}} </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div class="row center-block" v-if="singleTotalPrice > 0">
      <h2>PaaS : Single SQL Database</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">SLA</th>
                  <th colspan="1" rowspan="1">Name</th>
                  <th colspan="1" rowspan="1">Cores</th>
                  <th colspan="1" rowspan="1">Memory (GB)</th>
                  <th colspan="1" rowspan="1">Price Compute (per Month)</th>
                  <th colspan="1" rowspan="1">Foreseen Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Max. Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Max. IOPS</th>
                  <th colspan="1" rowspan="1">Max Throughput (MB/s)</th>
                  <th colspan="1" rowspan="1">Price Storage (per Month)</th>
                  <th colspan="1" rowspan="1">Total Price (per Month)</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>99,99%</td>
                  <td>{{singleName}} </td>
                  <td>{{singleCores}} </td>
                  <td>{{singleMemory}} </td>
                  <td>{{singleComputePrice}} {{currency}} </td>
                  <td>{{singleForeseenCapacity}} </td>
                  <td>{{singleMaxCapacity}} </td>
                  <td>{{singleMaxIOPS}} </td>
                  <td>{{singleMaxThroughput}} </td>
                  <td>{{singleStoragePrice}} {{currency}} </td>
                  <td>{{calcSingleTotalPrice}} {{currency}} </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div class="row center-block" v-if="elasticTotalPrice > 0">
      <h2>PaaS : Elastic SQL Database</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">SLA</th>
                  <th colspan="1" rowspan="1">Name</th>
                  <th colspan="1" rowspan="1">Cores</th>
                  <th colspan="1" rowspan="1">Memory (GB)</th>
                  <th colspan="1" rowspan="1">Price Compute (per Month)</th>
                  <th colspan="1" rowspan="1">Foreseen Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Max. Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Max. IOPS</th>
                  <th colspan="1" rowspan="1">Max Throughput (MB/s)</th>
                  <th colspan="1" rowspan="1">Price Storage (per Month)</th>
                  <th colspan="1" rowspan="1">Total Price (per Month)</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>99,99%</td>
                  <td>{{elasticName}} </td>
                  <td>{{elasticCores}} </td>
                  <td>{{elasticMemory}} </td>
                  <td>{{elasticComputePrice}} {{currency}} </td>
                  <td>{{elasticForeseenCapacity}} </td>
                  <td>{{elasticMaxCapacity}} </td>
                  <td>{{elasticMaxIOPS}} </td>
                  <td>{{elasticMaxThroughput}} </td>
                  <td>{{elasticStoragePrice}} {{currency}} </td>
                  <td>{{calcElasticTotalPrice}} {{currency}} </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div class="row center-block" v-if="managedComputePrice > 0">
      <h2>PaaS : Managed Instance</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <thead>
                <tr role="row">
                  <th colspan="1" rowspan="1">SLA</th>
                  <th colspan="1" rowspan="1">Name</th>
                  <th colspan="1" rowspan="1">Cores</th>
                  <th colspan="1" rowspan="1">Memory (GB)</th>
                  <th colspan="1" rowspan="1">Price Compute (per Month)</th>
                  <th colspan="1" rowspan="1">Foreseen Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Foreseen IOPS</th>
                  <th colspan="1" rowspan="1">Foreseen Throughput (MB/s)</th>
                  <th colspan="1" rowspan="1">Max. Capacity (GB)</th>
                  <th colspan="1" rowspan="1">Max. IOPS</th>
                  <th colspan="1" rowspan="1">Max Throughput (MB/s)</th>
                  <th colspan="1" rowspan="1">Price Storage (per Month)</th>
                  <th colspan="1" rowspan="1">Total Price (per Month)</th>
                </tr>
              </thead>
              <tbody>
                <tr role="row">
                  <td>99,99%</td>
                  <td>{{managedName}} </td>
                  <td>{{managedCores}} </td>
                  <td>{{managedMemory}} </td>
                  <td>{{managedComputePrice}} {{currency}} </td>
                  <td>{{managedForeseenCapacity}} </td>
                  <td>{{managedForeseenIOPS}} </td>
                  <td>{{managedForeseenThroughput}} </td>
                  <td>{{managedMaxCapacity}} </td>
                  <td>{{managedMaxIOPS}} </td>
                  <td>{{managedMaxThroughput}} </td>
                  <td>{{managedStoragePrice}} {{currency}} </td>
                  <td>{{calcManagedTotalPrice}} {{currency}} </td>
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
    name: 'SqlChooser',
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
        singleName: '',
        singleCores: '',
        singleMemory: '',
        singleComputePrice: '',
        singleForeseenCapacity: '',
        singleForeseenIOPS: '',
        singleForeseenThroughput: '',
        singleMaxCapacity: '',
        singleMaxIOPS: '',
        singleMaxThroughput: '',
        singleStoragePrice: '',
        singleTotalPrice: '',
        elasticName: '',
        elasticCores: '',
        elasticMemory: '',
        elasticComputePrice: '',
        elasticForeseenCapacity: '',
        elasticForeseenIOPS: '',
        elasticForeseenThroughput: '',
        elasticMaxCapacity: '',
        elasticMaxIOPS: '',
        elasticMaxThroughput: '',
        elasticStoragePrice: '',
        elasticTotalPrice: '',
        managedName: '',
        managedCores: '',
        managedMemory: '',
        managedComputePrice: '',
        managedForeseenCapacity: '',
        managedForeseenIOPS: '',
        managedForeseenThroughput: '',
        managedMaxCapacity: '',
        managedMaxIOPS: '',
        managedMaxThroughput: '',
        managedStoragePrice: '',
        managedTotalPrice: '',
        dummy: ''
      }
    },
    computed: {
      calcMethod() {
        if (this.sla > 95) {
          return 'Availability Zones (99,99%)'
        }
        if (this.sla > 9) {
          return 'Availability Set (99,95%)'
        }
        return 'Single Instance (99,9%)'
      },
      calcNodeCount() {
        if (this.sla > 9) {
          return 2
        } else {
          return 1
        }
      },
      calcSingleTotalPrice() {
        return this.fixNumberFormatting(this.singleComputePrice + this.singleStoragePrice)
      },
      calcElasticTotalPrice() {
        return this.fixNumberFormatting(this.elasticComputePrice + this.elasticStoragePrice)
      },
      calcManagedTotalPrice() {
        return this.fixNumberFormatting(this.managedComputePrice + this.managedStoragePrice)
      },
      calcVmSizePrice() {
        return this.fixNumberFormatting(this.calcNodeCount * this.vmsizeprice)
      },
      calcVmOsDiskPrice() {
        return this.fixNumberFormatting(this.calcNodeCount * this.vmosdiskprice)
      },
      calcVmDataDiskPrice() {
        return this.fixNumberFormatting(this.calcNodeCount * this.vmdatadiskprice)
      },
      calcVmStoragePrice() {
        return this.fixNumberFormatting(this.calcNodeCount * (this.vmdatadiskprice + this.vmosdiskprice))
      },
      calcTotalPrice() {
        return this.fixNumberFormatting((this.vmsizeprice + this.vmosdiskprice + this.vmdatadiskprice) * this.calcNodeCount)
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
      cleanupPaas() {
        this.singleName = ''
        this.singleCores = ''
        this.singleMemory = ''
        this.singleMaxCapacity = ''
        this.singleMaxIOPS = ''
        this.singleMaxThroughput = ''
        this.singleComputePrice = ''
        this.singleTotalPrice = ''
        this.elasticName = ''
        this.elasticCores = ''
        this.elasticMemory = ''
        this.elasticMaxCapacity = ''
        this.elasticMaxIOPS = ''
        this.elasticMaxThroughput = ''
        this.elasticComputePrice = ''
        this.elasticTotalPrice = ''
        this.managedName = ''
        this.managedCores = ''
        this.managedMemory = ''
        this.managedMaxCapacity = ''
        this.managedMaxIOPS = ''
        this.managedMaxThroughput = ''
        this.managedComputePrice = ''
        this.managedTotalPrice = ''
        this.showsummary = ''
      },
      setSqlServiceCompute(data, index) {
        // console.log(data)
        this.showsummary = 'yes'

        // Single
        if (data.PurchaseModel === 'single') {
          this.getSqlDataPrice(data.PurchaseModel, data.Tier, this.currency, this.region)
          this.singleName = data.Name
          this.singleCores = data.Cores
          this.singleMemory = data.Memory
          this.singleMaxCapacity = data.MaxStorage
          this.singleMaxIOPS = data.MaxIops
          this.singleMaxThroughput = data.MaxThroughput
          this.singleComputePrice = data.Price * 730
          this.singleTotalPrice = this.singleComputePrice
        }

        // elastic
        if (data.PurchaseModel === 'elastic') {
          this.getSqlDataPrice(data.PurchaseModel, data.Tier, this.currency, this.region)
          this.elasticName = data.Name
          this.elasticCores = data.Cores
          this.elasticMemory = data.Memory
          this.elasticMaxCapacity = data.MaxStorage
          this.elasticMaxIOPS = data.MaxIops
          this.elasticMaxThroughput = data.MaxThroughput
          this.elasticComputePrice = data.Price * 730
          this.elasticTotalPrice = this.elasticComputePrice
        }

        // managed
        if (data.PurchaseModel === 'managed') {
          this.getSqlDataPrice(data.PurchaseModel, data.Tier, this.currency, this.region)
          this.managedName = data.Name
          this.managedCores = data.Cores
          this.managedMemory = data.Memory
          this.managedMaxCapacity = data.MaxStorage
          this.managedMaxIOPS = data.MaxIops
          this.managedMaxThroughput = data.MaxThroughput
          this.managedComputePrice = data.Price * 730
          this.managedTotalPrice = this.managedComputePrice
        }
      },
      getSqlService(region, cores, memory, data, iops, throughput, currency, contract, ahub) {
        var maxresults = '1'
        var vmchooserurl = config.apiGetSqlService +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&data=' + data +
          '&iops=' + iops +
          '&throughput=' + throughput +
          '&contract=' + contract +
          '&ahub=' + ahub +
          '&region=' + region +
          '&currency=' + currency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        this.cleanupPaas()
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.dummy = response.data.forEach(this.setSqlServiceCompute)
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getSqlDataPrice(purchasemodel, tier, currency, region) {
        var split = tier.split('-')
        if (split[0] === 'general' && purchasemodel !== 'managed') {
          tier = 'general-purpose-storage'
        }
        if (split[0] === 'business' && purchasemodel !== 'managed') {
          tier = 'business-critical-storage'
        }
        var vmchooserurl = config.apiGetSqlServiceStorage +
          '?region=' + region +
          '&purchasemodel=' + purchasemodel +
          '&currency=' + currency +
          '&tier=' + tier
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        this.summaryStorageDataCountTotal = this.summaryStorageDataCountTotal + 1
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            if (purchasemodel === 'single') {
              this.singleForeseenCapacity = this.data
              this.singleStoragePrice = this.data * response.data[0].Price
            }
            if (purchasemodel === 'elastic') {
              this.elasticForeseenCapacity = this.data
              this.elasticStoragePrice = this.data * response.data[0].Price
            }
            if (purchasemodel === 'managed') {
              var minsize = 32
              var managedcapacity = Math.ceil(this.data / minsize) * minsize
              this.managedForeseenCapacity = managedcapacity
              this.managedForeseenIOPS = managedcapacity * 120 / 32
              this.managedForeseenThroughput = managedcapacity * 25 / 32
              this.managedStoragePrice = managedcapacity * response.data[0].Price
            }
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getDataDiskConfig(ssdclass, ssdtype, currency, maxdisks, iops, capacity) {
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssdclass +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&iops=' + iops +
          '&data=' + capacity +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        this.summaryStorageDataCountTotal = this.summaryStorageDataCountTotal + 1
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.vmdatadiskprice = response.data.DiskPrice
            this.vmdatadiskconfig = response.data.DiskConfigDescription
            this.vmdatadiskcapacity = response.data.DiskConfigCapacity
            this.vmdatadiskiops = response.data.DiskConfigIops
            this.vmdatadiskthroughput = response.data.DiskConfigThroughput
            this.showsummary = 'yes'
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getOsDisk(ssdclass, ssdtype, currency) {
        var maxdisks = '1'
        var osdisk = '100' // 100GB to revert back to an S10 / P10
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssdclass +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&data=' + osdisk +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.vmosdiskprice = response.data.DiskPrice
            this.vmosdisk = response.data.DiskSize
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getVmSize(region, cores, memory, data, iops, currency, contract, os) {
        var ssd = 'yes'
        var ssdtype = 'premiumssd'
        var maxresults = '1'
        var vmchooserurl = config.apiGetVmSize +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&ssd=' + ssd +
          '&iops=' + iops +
          '&data=' + data +
          '&contract=' + contract +
          '&region=' + region +
          '&currency=' + currency +
          '&os=' + os +
          '&burstable=no'
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.vmsize = response.data[0].Name
            this.vmsizeprice = response.data[0].Price * 730
            this.vmsizemaxdisks = response.data[0].MaxDataDiskCount

            this.getOsDisk(ssd, ssdtype, this.currency)
            this.getDataDiskConfig(ssd, ssdtype, this.currency, this.vmsizemaxdisks, this.iops, this.data)
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      findSQL() {
        if (this.data <= 0) { this.data = 5 }
        if (this.license === 'yes') {
          this.os = 'linux'
        } else { this.os = 'sql-enterprise' }
        this.getVmSize(this.region, this.cores, this.memory, this.data, this.iops, this.currency, this.contract, this.os)
        this.getSqlService(this.region, this.cores, this.memory, this.data, this.iops, this.throughput, this.currency, this.contract, this.license)
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
