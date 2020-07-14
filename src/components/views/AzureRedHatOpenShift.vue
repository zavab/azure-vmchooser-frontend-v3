<template>
  <section class="content">
    <div class="row center-block">
      <h2>Context</h2>
      <div>
        <div class="tab-content">
          <div class="input-group">
            <input class="form-control" placeholder="How many pods does the workload need as a baseline (minimum)?" type="text" v-model="minpods">
            <span class="input-group-addon">Pods</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How many hours per month does the workload run as a baseline (maximum)?" type="text" v-model="minduration">
            <span class="input-group-addon">Hours</span>
          </div>
          <br />
          <div class="input-group">
              <select class="form-control" v-model="mincontract">
                <option disabled value="">Contract type for the baseline</option>
                <option value="payg">Pay-as-you-Go</option>
                <option value="ri1y">Reserved Instance - 1 Year Term</option>
                <option value="ri3y">Reserved Instance - 3 Year Term</option>
              </select>
              <span class="input-group-addon">Type</span>
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
              <select class="form-control" v-model="maxcontract">
                <option disabled value="">Contract type for the peak</option>
                <option value="payg">Pay-as-you-Go</option>
                <option value="ri1y">Reserved Instance - 1 Year Term</option>
                <option value="ri3y">Reserved Instance - 3 Year Term</option>
              </select>
              <span class="input-group-addon">Type</span>
            </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How much cores are required on average per pod?" type="text" v-model="cores">
            <span class="input-group-addon">Milicores (1000 Milicores = 1 Core)</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="How much memory is required on average per pod?" type="text" v-model="memory">
            <span class="input-group-addon">MB</span>
          </div>
          <br />
          <div class="input-group">
            <input class="form-control" placeholder="What is the amount of net (persistent/data) storage needed per pod?" type="text" v-model="storage">
            <span class="input-group-addon">MB</span>
          </div>
          <br />
          <div class="input-group">
            <select class="form-control" v-model="ftt">
              <option disabled value="">Failures To Tolerate ("N + FTT")</option>
              <option value="0">No Protection</option>
              <option value="1">N+1</option>
              <option value="2">N+2</option>
              <option value="3">N+3</option>
              <option value="99">Full Zone</option>
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
      <div v-if=WorkerErrors class="text-red"><p class="vertical-5p lead">{{WorkerErrors}}</p></div>
    </div>

    <div class="row center-block" v-if="MasterProcessed && WorkersProcessed">
      <h2>Azure Red Hat OpenShift Configuration</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <tbody>
                <tr>
                  <td>Node Type</td>
                  <td>Node Count</td>
                  <td>VM Type</td>
                  <td>Disk Type</td>
                  <td>Cores / Node</td>
                  <td>Memory / Node</td>
                  <td>Storage / Node</td>
                  <td>Cores / Cluster</td>
                  <td>Memory / Cluster</td>
                  <td>Storage / Cluster</td>
                  <td>Runtime (Hours)</td>
                  <td>Compute Cost</td>
                  <td>Compute Contract</td>
                  <td>Storage Cost</td>
                  <td>Storage Contract</td>
                  <td>License Cost</td>
                  <td>License Contract</td>
                  <td>Total Cost</td>
                </tr>
                <tr>
                  <td>Master nodes</td>
                  <td>{{MasterCount}}</td>
                  <td>{{MasterVmType}}</td>
                  <td>{{MasterStorageSize}}</td>
                  <td>{{MasterCoresNode}}</td>
                  <td>{{MasterMemoryNode}} {{UnitMemory}}</td>
                  <td>{{MasterStorageNode}} {{UnitDisk}}</td>
                  <td>{{MasterCoresTotal}}</td>
                  <td>{{MasterMemoryTotal}} {{UnitMemory}}</td>
                  <td>{{MasterStorageTotal}} {{UnitDisk}}</td>
                  <td>{{MasterRuntime}}</td>
                  <td>{{showMasterCompute}}</td>
                  <td>{{MasterComputeContract}}</td>
                  <td>{{showMasterStorage}}</td>
                  <td>{{MasterStorageContract}}</td>
                  <td>{{showMasterLicense}}</td>
                  <td>{{MasterLicenseContract}}</td>
                  <td>{{showMasterTotal}}</td>
                </tr>
                <tr>
                  <td>Worker nodes - Baseline</td>
                  <td>{{WorkerBaselineCount}}</td>
                  <td>{{WorkerBaselineVmType}}</td>
                  <td>{{WorkerBaselineStorageSize}}</td>
                  <td>{{WorkerBaselineCoresNode}}</td>
                  <td>{{WorkerBaselineMemoryNode}} {{UnitMemory}}</td>
                  <td>{{WorkerBaselineStorageNode}} {{UnitDisk}}</td>
                  <td>{{WorkerBaselineCoresTotal}}</td>
                  <td>{{WorkerBaselineMemoryTotal}} {{UnitMemory}}</td>
                  <td>{{WorkerBaselineStorageTotal}} {{UnitDisk}}</td>
                  <td>{{WorkerBaselineRuntime}}</td>
                  <td>{{showWorkerBaselineCompute}}</td>
                  <td>{{WorkerBaselineComputeContract}}</td>
                  <td>{{showWorkerBaselineStorage}}</td>
                  <td>{{WorkerBaselineStorageContract}}</td>
                  <td>{{showWorkerBaselineLicense}}</td>
                  <td>{{WorkerBaselineLicenseContract}}</td>
                  <td>{{showWorkerBaselineTotal}}</td>
                </tr>
                <tr>
                  <td>Worker nodes - Burstable</td>
                  <td>{{WorkerPeakCount}}</td>
                  <td>{{WorkerPeakVmType}}</td>
                  <td>{{WorkerPeakStorageSize}}</td>
                  <td>{{WorkerPeakCoresNode}}</td>
                  <td>{{WorkerPeakMemoryNode}} {{UnitMemory}}</td>
                  <td>{{WorkerPeakStorageNode}} {{UnitDisk}}</td>
                  <td>{{WorkerPeakCoresTotal}}</td>
                  <td>{{WorkerPeakMemoryTotal}} {{UnitMemory}}</td>
                  <td>{{WorkerPeakStorageTotal}} {{UnitDisk}}</td>
                  <td>{{WorkerPeakRuntime}}</td>
                  <td>{{showWorkerPeakCompute}}</td>
                  <td>{{WorkerPeakComputeContract}}</td>
                  <td>{{showWorkerPeakStorage}}</td>
                  <td>{{WorkerPeakStorageContract}}</td>
                  <td>{{showWorkerPeakLicense}}</td>
                  <td>{{WorkerPeakLicenseContract}}</td>
                  <td>{{showWorkerPeakTotal}}</td>
                </tr>

                <tr>
                  <td>Summary</td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td>{{showTotalCompute}}</td>
                  <td></td>
                  <td>{{showTotalStorage}}</td>
                  <td></td>
                  <td>{{showTotalLicense}}</td>
                  <td></td>
                  <td>{{showTotalTotal}}</td>
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
    name: 'AzureRedHatOpenShift',
    data() {
      return {
        UnitDisk: 'GB',
        UnitMemory: 'GB',
        UnitRuntime: 'hours',
        MasterProcessed: '',
        WorkersProcessed: '',
        WorkerErrors: '',
        MasterCount: '',
        MasterVmType: '',
        MasterRuntime: '',
        MasterCoresNode: '',
        MasterMemoryNode: '',
        MasterStorageNode: '',
        MasterCoresTotal: '',
        MasterMemoryTotal: '',
        MasterStorageTotal: '',
        MasterCompute: '',
        MasterComputeContract: '',
        MasterStorage: '',
        MasterStorageSize: '',
        MasterStorageCapacity: '',
        MasterStorageContract: '',
        MasterLicense: '',
        MasterLicenseContract: '',
        MasterTotal: '',
        WorkerBaselineCount: '',
        WorkerBaselineVmType: '',
        WorkerBaselineRuntime: '',
        WorkerBaselineCoresNode: '',
        WorkerBaselineMemoryNode: '',
        WorkerBaselineStorageNode: '',
        WorkerBaselineCoresTotal: '',
        WorkerBaselineMemoryTotal: '',
        WorkerBaselineStorageTotal: '',
        WorkerBaselineCompute: '',
        WorkerBaselineComputeContract: '',
        WorkerBaselineStorage: '',
        WorkerBaselineStorageSize: '',
        WorkerBaselineStorageCapacity: '',
        WorkerBaselineStorageContract: '',
        WorkerBaselineLicense: '',
        WorkerBaselineLicenseContract: '',
        WorkerBaselineTotal: '',
        WorkerPeakCount: '',
        WorkerPeakVmType: '',
        WorkerPeakRuntime: '',
        WorkerPeakCoresNode: '',
        WorkerPeakMemoryNode: '',
        WorkerPeakStorageNode: '',
        WorkerPeakCoresTotal: '',
        WorkerPeakMemoryTotal: '',
        WorkerPeakStorageTotal: '',
        WorkerPeakCompute: '',
        WorkerPeakComputeContract: '',
        WorkerPeakStorage: '',
        WorkerPeakStorageSize: '',
        WorkerPeakStorageCapacity: '',
        WorkerPeakStorageContract: '',
        WorkerPeakLicense: '',
        WorkerPeakLicenseContract: '',
        WorkerPeakTotal: '',
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
        maxnodes: 100,
        os: 'linux',
        ossize: '16', 
        storage: '',
        mincontract: 'ri3y',
        minpods: '',
        minduration: '',
        maxcontract: 'payg',
        maxpods: '',
        maxduration: '',
        cores: '',
        memory: '',
        ftt: '',
        dummy: ''
      }
    },
    computed: {
      showMasterCompute() {
        return this.fixNumberFormatting(this.MasterCompute) + ' ' + this.currency
      },
      showMasterStorage() {
        return this.fixNumberFormatting(this.MasterStorage * this.MasterCount) + ' ' + this.currency
      },
      showMasterLicense() {
        return this.fixNumberFormatting(this.MasterLicense) + ' ' + this.currency
      },
      showMasterTotal() {
        return this.fixNumberFormatting(this.MasterTotal) + ' ' + this.currency
      },
      showWorkerBaselineCompute() {
        return this.fixNumberFormatting(this.WorkerBaselineCompute) + ' ' + this.currency
      },
      showWorkerBaselineStorage() {
        return this.fixNumberFormatting(this.WorkerBaselineStorage * this.WorkerBaselineCount) + ' ' + this.currency
      },
      showWorkerBaselineLicense() {
        return this.fixNumberFormatting(this.WorkerBaselineLicense) + ' ' + this.currency
      },
      showWorkerBaselineTotal() {
        return this.fixNumberFormatting(this.WorkerBaselineTotal) + ' ' + this.currency
      },
      showWorkerPeakCompute() {
        return this.fixNumberFormatting(this.WorkerPeakCompute) + ' ' + this.currency
      },
      showWorkerPeakStorage() {
        return this.fixNumberFormatting(this.WorkerPeakStorage * this.WorkerPeakCount) + ' ' + this.currency
      },
      showWorkerPeakLicense() {
        return this.fixNumberFormatting(this.WorkerPeakLicense) + ' ' + this.currency
      },
      showWorkerPeakTotal() {
        return this.fixNumberFormatting(this.WorkerPeakTotal) + ' ' + this.currency
      },
      showTotalCompute() {
        return this.fixNumberFormatting(this.MasterCompute + this.WorkerBaselineCompute + this.WorkerPeakCompute) + ' ' + this.currency
      },
      showTotalStorage() {
        return this.fixNumberFormatting(this.MasterStorage + this.WorkerBaselineStorage + this.WorkerPeakStorage) + ' ' + this.currency
      },
      showTotalLicense() {
        return this.fixNumberFormatting(this.MasterLicense + this.WorkerBaselineLicense + this.WorkerPeakLicense) + ' ' + this.currency
      },
      showTotalTotal() {
        return this.fixNumberFormatting(this.MasterTotal + this.WorkerBaselineTotal + this.WorkerPeakTotal) + ' ' + this.currency
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
      getOsDisk(region, currency, size, count) {
        var maxdisks = '1'
        var ssd = 'Yes'
        var ssdtype = 'premiumssd'
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssd +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&region=' + region +
          '&data=' + size +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.MasterStorageSize = response.data.DiskSize
            this.MasterStorageNode = response.data.DiskConfigCapacity
            this.MasterStorageTotal = response.data.DiskConfigCapacity * count
            this.MasterStorage = response.data.DiskPrice
            /*
              {…}
              DiskCapacity: 128
              DiskConfigCapacity: 128
              DiskConfigDescription: "A striped (raid0) set of 1 p10 disk(s)."
              DiskConfigIops: 500
              DiskConfigThroughput: 100
              DiskCount: 1
              DiskCurrency: "JPY"
              DiskIops: 500
              DiskName: "md-p10-premium-europe-west"
              DiskPrice: 2211.36
              DiskSize: "p10"
              DiskThroughput: 100
              DiskType: "premium"
              __proto__: Object { … }
            */
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getDataDisk(region, currency, size) {
        var maxdisks = '1'
        var ssd = 'Yes'
        var ssdtype = 'premiumssd'
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssd +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&region=' + region +
          '&data=' + size +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            this.WorkerPeakStorageSize = response.data.DiskSize
            this.WorkerBaselineStorageSize = response.data.DiskSize
            this.WorkerPeakStorageNode = response.data.DiskConfigCapacity
            this.WorkerBaselineStorageNode = response.data.DiskConfigCapacity
            this.WorkerPeakStorageTotal = response.data.DiskConfigCapacity * this.WorkerPeakCount
            this.WorkerBaselineStorageTotal = response.data.DiskConfigCapacity * this.WorkerBaselineCount
            this.WorkerPeakStorage = response.data.DiskPrice
            this.WorkerBaselineStorage = response.data.DiskPrice
            /*
              {…}
              DiskCapacity: 128
              DiskConfigCapacity: 128
              DiskConfigDescription: "A striped (raid0) set of 1 p10 disk(s)."
              DiskConfigIops: 500
              DiskConfigThroughput: 100
              DiskCount: 1
              DiskCurrency: "JPY"
              DiskIops: 500
              DiskName: "md-p10-premium-europe-west"
              DiskPrice: 2211.36
              DiskSize: "p10"
              DiskThroughput: 100
              DiskType: "premium"
              __proto__: Object { … }
            */
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getVmSizeAroMaster(region, cores, memory, currency, contract, os) {
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
            this.MasterVmType = response.data[0].Name
            this.MasterRuntime = this.minduration
            this.MasterCompute = response.data[0].Price * this.MasterRuntime * this.MasterCount
            this.MasterComputeContract = this.mincontract
            this.MasterStorage = 0
            this.MasterStorageContract = 'payg'
            this.MasterLicense = 0
            this.MasterLicenseContract = 'n/a'
            this.MasterTotal = this.MasterCompute + this.MasterStorage + this.MasterLicense
            this.MasterCoresNode = response.data[0].Cores
            this.MasterMemoryNode = response.data[0].Memory
            this.MasterCoresTotal = this.MasterCoresNode * this.MasterCount
            this.MasterMemoryTotal = this.MasterMemoryNode * this.MasterCount

            this.MasterProcessed = 'Yes'

            this.getOsDisk(region, currency, this.ossize, this.MasterCount)
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getAroWorkers(minpods, maxpods, minduration, maxduration, mincontract, maxcontract, cores, memory, ftt, region, currency, storage) {
        var vmchooserurl = config.apiGetAroWorkers +
          '?minpods=' + minpods +
          '&maxpods=' + maxpods +
          '&minduration=' + minduration +
          '&maxduration=' + maxduration +
          '&cores=' + cores +
          '&memory=' + memory +
          '&storage=' + storage +
          '&region=' + region +
          '&currency=' + currency +
          '&mincontract=' + mincontract +
          '&maxcontract=' + maxcontract +
          '&ftt=' + ftt
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            /*
            {
              "VmSize": "d4sv3",
              "VmCores": 4,
              "VmMemory": 16.0,
              "PodsCores": 0.1,
              "PodsMemory": 0.125,
              "PodsMin": 1.0,
              "PodsMinCores": 0.1,
              "PodsMinMemory": 0.125,
              "DurationMin": 730.0,
              "NodeCountMin": 1.0,
              "CostMin": 345.916853190,
              "ContractMin": "ri3y",
              "OpenShifCostMin": 0.385067646,
              "OpenShifContractMin": "ri1y",
              "PodsMax": 0.0,
              "PodsMaxCores": 0.0,
              "PodsMaxMemory": 0.000,
              "DurationMax": 0.0,
              "NodeCountMax": 0.0,
              "CostMax": 0.0000000,
              "ContractMax": "payg",
              "OpenShifCostMax": 0.6417513,
              "OpenShifContractMax": "payg",
              "CostTotal": 345.916853190,
              "Error": ""
            }
            */
            console.log(response.data)
            this.WorkerBaselineVmType = response.data.VmSize
            this.WorkerBaselineCount = response.data.NodeCountMin
            this.WorkerBaselineRuntime = this.minduration
            this.WorkerBaselineCompute = response.data.CostMin
            this.WorkerBaselineComputeContract = response.data.ContractMin
            this.WorkerBaselineStorage = 0
            this.WorkerBaselineStoragePod = response.data.PodsMinStorage
            this.WorkerBaselineStorageContract = 'payg'
            this.WorkerBaselineLicense = response.data.OpenShifCostMin * this.WorkerBaselineRuntime * this.WorkerBaselineCount
            this.WorkerBaselineLicenseContract = response.data.OpenShifContractMin
            this.WorkerBaselineTotal = this.WorkerBaselineCompute + this.WorkerBaselineStorage + this.WorkerBaselineLicense
            this.WorkerBaselineCoresNode = response.data.VmCores
            this.WorkerBaselineMemoryNode = response.data.VmMemory
            this.WorkerBaselineCoresTotal = this.WorkerBaselineCoresNode * this.WorkerBaselineCount
            this.WorkerBaselineMemoryTotal = this.WorkerBaselineMemoryNode * this.WorkerBaselineCount

            this.WorkerPeakVmType = response.data.VmSize
            this.WorkerPeakCount = response.data.NodeCountMax
            this.WorkerPeakRuntime = this.maxduration
            this.WorkerPeakCompute = response.data.CostMax
            this.WorkerPeakComputeContract = response.data.ContractMax
            this.WorkerPeakStorage = 0
            this.WorkerPeakStoragePod = response.data.PodsMaxStorage
            this.WorkerPeakStorageContract = 'payg'
            this.WorkerPeakLicense = response.data.OpenShifCostMin * this.WorkerPeakRuntime * this.WorkerPeakCount
            this.WorkerPeakLicenseContract = response.data.OpenShifContractMax
            this.WorkerPeakTotal = this.WorkerPeakCompute + this.WorkerPeakStorage + this.WorkerPeakLicense
            this.WorkerPeakCoresNode = response.data.VmCores
            this.WorkerPeakMemoryNode = response.data.VmMemory
            this.WorkerPeakCoresTotal = this.WorkerPeakCoresNode * this.WorkerPeakCount
            this.WorkerPeakMemoryTotal = this.WorkerPeakMemoryNode * this.WorkerPeakCount

            this.WorkerErrors = response.data.Error

            this.WorkerStorage = this.WorkerBaselineStoragePod + this.ossize
            this.getDataDisk(region, currency, this.WorkerStorage)

            this.WorkersProcessed = 'Yes'
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

        /* WorkerBaseline node Calc
          Source ; https://docs.openshift.com/container-platform/4.3/scalability_and_performance/recommended-host-practices.html
          Number of worker nodes - CPU cores - Memory (GB)
          25 - 4 - 16
          100 - 8 - 32
          250 - 16 - 64
        */

        if (!parseFloat(this.storage) > 0) {
          this.storage = 128
        }
        if (!parseFloat(this.minduration) > 0) {
          this.minduration = 730
        }
        if (!parseFloat(this.maxduration) > 0) {
          this.maxduration = 200
        }

        this.MasterProcessed = ''
        this.WorkersProcessed = ''

        var WorkerBaselinecores = 4
        var WorkerBaselinememory = 16

        if (this.maxnodes >= 250) {
          WorkerBaselinecores = 16
          WorkerBaselinememory = 64
        }

        if (this.maxnodes >= 100) {
          WorkerBaselinecores = 8
          WorkerBaselinememory = 32
        }

        this.MasterCount = 3

        this.getVmSizeAroMaster(this.region, WorkerBaselinecores, WorkerBaselinememory, this.currency, this.mincontract, this.os)
        this.getAroWorkers(this.minpods, this.maxpods, this.minduration, this.maxduration, this.mincontract, this.maxcontract, this.cores, this.memory, this.ftt, this.region, this.currency, this.storage)
      }
    },
    mounted: function () {
      this.getMetaDataRegions()
      // console.log(this.$appInsights)
      this.$appInsights.trackPageView('AzureRedHatOpenshift')
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
