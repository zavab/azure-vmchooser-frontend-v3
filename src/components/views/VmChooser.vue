<template>
  <section class="content">
    <div class="row center-block">
      <h2>Filter Criteria</h2>
      <div>
        <ul class="nav nav-tabs" role="tablist">
          <li role="presentation" class="active"><a href="#compute" aria-controls="compute" role="tab" data-toggle="tab">Compute</a></li>
          <li role="presentation"><a href="#storage" aria-controls="storage" role="tab" data-toggle="tab">Storage</a></li>
          <li role="presentation"><a href="#network" aria-controls="network" role="tab" data-toggle="tab">Network</a></li>
          <li role="presentation"><a href="#attributes" aria-controls="attributes" role="tab" data-toggle="tab">Attributes</a></li>
          <li role="presentation"><a href="#sap" aria-controls="sap" role="tab" data-toggle="tab">SAP</a></li>
          <li role="presentation"><a href="#aro" aria-controls="aro" role="tab" data-toggle="tab">ARO</a></li>  
          <li role="presentation"><a href="#optimize" aria-controls="optimize" role="tab" data-toggle="tab">Optimize</a></li>
          <li role="presentation"><a href="#settings" aria-controls="settings" role="tab" data-toggle="tab">Settings</a></li>
        </ul>
        <div class="tab-content">
          <div role="tabpanel" class="tab-pane active" id="compute">
            <div class="input-group">
              <input class="form-control" placeholder="Minimum # cores" type="text" v-model="cores">
              <span class="input-group-addon">#</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum memory" type="text" v-model="memory">
              <span class="input-group-addon">GB</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum performance level in Azure Compute Unit" type="text" v-model="acu">
              <span class="input-group-addon">ACU</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum performance level in DataBricks Unit" type="text" v-model="dbu">
              <span class="input-group-addon">DBU</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="storage">
            <div class="input-group">
              <select class="form-control" v-model="type">
                <option disabled value="">Select disk type</option>
                <option value="No">HDD only</option>
                <option value="Yes">SSD only</option>
                <option value="All">All options</option>
              </select>
              <span class="input-group-addon">Type</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum disk capacity" type="text" v-model="capacity">
              <span class="input-group-addon">GB</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum amount of Input Output Operations per Second (IOPS)" type="text" v-model="iops">
              <span class="input-group-addon">IO/s</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum throughput/bandwidth" type="text" v-model="throughput">
              <span class="input-group-addon">MB/s</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum temp disk capacity" type="text" v-model="temp">
              <span class="input-group-addon">GB</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="network">
            <div class="input-group">
              <input class="form-control" placeholder="Minimum # network interface cards" type="text" v-model="nics">
              <span class="input-group-addon">#</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum bandwidth" type="text" v-model="bandwidth">
              <span class="input-group-addon">Mbit/s</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="attributes">
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
              <select class="form-control" v-model="hyperthreaded">
                <option disabled value="">Hyperthreaded?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">HyperThreaded</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="burstable">
                <option disabled value="">Burstable?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">Burstable</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="isolated">
                <option disabled value="">Isolated?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">Isolated</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="constrained">
                <option disabled value="">Constrained possible?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">Constrained Cores</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="gpu">
                <option disabled value="">GPU card available?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">GPU</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="infiniband">
                <option disabled value="">Infiniband present?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">Infiniband</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="sgx">
                <option disabled value="">SGX Capable CPU?</option>
                <option value="No">No</option>
                <option value="Yes">Yes</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">SGX</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="sap">
            <div class="input-group">
              <select class="form-control" v-model="saphana">
                <option disabled value="">HANA Support</option>
                <option value="yes">Yes</option>
                <option value="no">No</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">HANA</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum SAPS 2-Tier" type="text" v-model="saps2t">
              <span class="input-group-addon">SAPS</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Minimum SAPS 3-Tier" type="text" v-model="saps3t">
              <span class="input-group-addon">SAPS</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="aro">
            <div class="input-group">
              <select class="form-control" v-model="aromaster">
                <option disabled value="">Master Node Support</option>
                <option value="yes">Yes</option>
                <option value="no">No</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">ARO</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="aroworker">
                <option disabled value="">Worker Node Support</option>
                <option value="yes">Yes</option>
                <option value="no">No</option>
                <option value="All">No Preference</option>
              </select>
              <span class="input-group-addon">ARO</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="optimize">
            <div class="input-group">
              <select class="form-control" v-model="contract">
                <option disabled value="">Contract type</option>
                <option value="payg">Pay-as-you-Go</option>
                <option value="ri1y">Reserved Instance - 1 Year Term</option>
                <option value="ri3y">Reserved Instance - 3 Year Term</option>
              </select>
              <span class="input-group-addon">Type</span>
            </div>
            <br />
            <div class="input-group">
              <select class="form-control" v-model="os">
                <option disabled value="">Operating system</option>
                <option value="linux">Linux or Windows via AHUB</option>
                <option value="windows">Windows</option>
                <option value="sql-standard">Windows + SQL Standard</option>
                <option value="sql-enterprise">Windows +  SQL Enterprise</option>
              </select>
              <span class="input-group-addon">Type</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Peak cpu usage" type="text" v-model="peakcpu">
              <span class="input-group-addon">%</span>
            </div>
            <br />
            <div class="input-group">
              <input class="form-control" placeholder="Peak memory usage" type="text" v-model="peakmemory">
              <span class="input-group-addon">%</span>
            </div>
            <br />
          </div>
          <div role="tabpanel" class="tab-pane" id="settings">
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
              <input class="form-control" placeholder="How many results do you want to see? (Default: 5)" type="text" v-model="maxresults">
              <span class="input-group-addon">#</span>
            </div>
            <br />
          </div>
        </div>
      </div>

      <div class="input-group">
        <form @submit.prevent="checkCreds">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Find my t-shirt size!</button>
        </form>
      </div>
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div v-if="rowData.length">
      <h2>VM T-Shirt Sizes</h2>
      <ag-grid-vue style="width: 100%; height: 600px" class="ag-theme-balham"
                   :columnDefs="columnDefs"
                   :rowData="rowData"
                   :enableSorting="true"
                   :enableFilter="true"
                   :rowMultiSelectWithClick="true"
                   rowSelection="multiple"
                   >
      </ag-grid-vue>
    </div>

  </section>
</template>

<script>
  // Axios needed for API Call
  import axios from 'axios'
  // Config
  import config from '../../config'
  // AG Grid
  import { AgGridVue } from 'ag-grid-vue'

  function priceComparator(price1, price2) {
    price1 = price1.toLocaleString()
    price2 = price2.toLocaleString()
    return price1 - price2
  }

  export default {
    name: 'VmChooser',
    components: {
      'ag-grid-vue': AgGridVue
    },
    beforeMount() {
      this.columnDefs = [
        { headerName: 'Name', field: 'Name' },
        { headerName: 'Price / Hour', field: 'Price', type: 'numericColumn', comparator: priceComparator },
        { headerName: 'Price / Month', field: 'PricePerMonth', type: 'numericColumn', comparator: priceComparator },
        { headerName: 'Currency', field: 'Currency' },
        { headerName: 'Tier', field: 'Tier' },
        { headerName: 'Region', field: 'Region' },
        { headerName: 'Contract', field: 'Contract' },
        { headerName: 'OS', field: 'OperatingSystem' },
        { headerName: 'ACU', field: 'ACU', type: 'numericColumn' },
        { headerName: 'DBU', field: 'DBU', type: 'numericColumn' },
        { headerName: 'SSD', field: 'SSD' },
        { headerName: 'Cores', field: 'Cores', type: 'numericColumn' },
        { headerName: 'Memory', field: 'Memory', type: 'numericColumn' },
        { headerName: 'Burstable', field: 'Burstable' },
        { headerName: 'Isolated', field: 'Isolated' },
        { headerName: 'Infiniband', field: 'Infiniband' },
        { headerName: 'GPU', field: 'GPU' },
        { headerName: 'SGX', field: 'SGX' },
        { headerName: 'Hyperthreaded', field: 'Hyperthreaded' },
        { headerName: 'Max. Nics', field: 'MaxNics', type: 'numericColumn' },
        { headerName: 'Bandwidth', field: 'Bandwidth', type: 'numericColumn' },
        { headerName: 'Max. Disks', field: 'MaxDataDiskCount', type: 'numericColumn' },
        { headerName: 'Max. IOPS', field: 'MaxVmIops', type: 'numericColumn' },
        { headerName: 'Max. Throughput', field: 'MaxVmThroughputMBs', type: 'numericColumn' },
        { headerName: 'HANA Support', field: 'SAPHANA' },
        { headerName: 'SAPS 2-Tier', field: 'SAPS2T', type: 'numericColumn' },
        { headerName: 'SAPS 3-Tier', field: 'SAPS3T', type: 'numericColumn' }
      ]
    },
    mounted() {
      this.$appInsights.trackPageView('VmChooser')
      this.getMetaDataRegions()
    },
    data() {
      return {
        columnDefs: [],
        rowData: [],
        posts: [],
        errors: [],
        loading: '',
        response: '',
        cores: '',
        memory: '',
        acu: '',
        dbu: '',
        capacity: '',
        iops: '',
        throughput: '',
        temp: '',
        type: '',
        nics: '',
        bandwidth: '',
        tier: 'standard',
        hyperthreaded: '',
        burstable: '',
        isolated: '',
        constrained: '',
        infiniband: '',
        gpu: '',
        sgx: '',
        contract: '',
        peakcpu: '',
        peakmemory: '',
        region: 'europe-west',
        currency: 'EUR',
        maxresults: '50',
        os: 'linux',
        regions: [],
        aromaster: '',
        aroworker: '',
        saphana: '',
        saps2t: '',
        saps3t: ''
      }
    },
    methods: {
      calcMonthlyPrice() {
        for (var i = 0; i < this.posts.length; i++) {
          var post = this.posts[i]
          post.PricePerMonth = (post.Price * 730).toFixed(4)
          post.Price = post.Price.toFixed(4)
        }
      },
      setVmoptimizerLink() {
        for (var i = 0; i < this.posts.length; i++) {
          var post = this.posts[i]
          post.linkVmoptimizer = '/vmoptimizer/' + post.Name
        }
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
      checkCreds() {
        const { maxresults, cores, memory, acu, capacity, iops, throughput, temp, type, nics, bandwidth, tier, hyperthreaded, burstable, isolated, constrained, contract, peakcpu, peakmemory, region, currency, os, saphana, saps2t, saps3t, gpu, infiniband, sgx, dbu, aromaster, aroworker } = this
        var vmchooserurl = config.apiGetVmSize +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&acu=' + acu +
          '&dbu=' + dbu +
          '&ssd=' + type +
          '&temp=' + temp +
          '&throughput=' + throughput +
          '&iops=' + iops +
          '&data=' + capacity +
          '&nics=' + nics +
          '&bandwidth=' + bandwidth +
          '&tier=' + tier +
          '&ht=' + hyperthreaded +
          '&burstable=' + burstable +
          '&isolated=' + isolated +
          '&constrained=' + constrained +
          '&infiniband=' + infiniband +
          '&gpu=' + gpu +
          '&sgx=' + sgx +
          '&contract=' + contract +
          '&avgcpupeak=' + peakcpu +
          '&avgmempeak=' + peakmemory +
          '&region=' + region +
          '&currency=' + currency +
          '&os=' + os +
          '&aroapp=' + aroworker +
          '&aromaster=' + aromaster +
          '&saphana=' + saphana +
          '&saps2t=' + saps2t +
          '&saps3t=' + saps3t
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.posts = response.data
            this.rowData = response.data
            if (!this.posts) {
              this.response = 'No results found'
            } else {
              this.calcMonthlyPrice()
              this.setVmoptimizerLink()
            }
          })
          .catch(e => {
            this.errors.push(e)
          })
      }
    }
  }
</script>
