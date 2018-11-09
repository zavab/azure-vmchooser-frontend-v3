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
              <input class="form-control" placeholder="Minimum performance level" type="text" v-model="acu">
              <span class="input-group-addon">ACU</span>
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

    <div class="row center-block" v-if="posts.length">
      <h2>VM T-Shirt Sizes</h2>
      <div class="col-md-12">
        <div class="box">
          <!-- /.box-header -->
          <div class="box-body">
            <div class="dataTables_wrapper form-inline dt-bootstrap" id="example1_wrapper">
              <div class="row">
                <div class="col-sm-6">
                  <div id="example1_length" class="dataTables_length">
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="col-sm-12 table-responsive">
                  <table aria-describedby="example1_info" role="grid" id="example1" class="table table-bordered table-striped dataTable">
                    <thead>
                      <tr role="row">
                        <th colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Name</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Price / Hour</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Price / Month</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Currency</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Tier</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Region</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Contract</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">OS</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">ACU</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SSD</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Cores</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Memory</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Burstable</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Isolated</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Infiniband</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">GPU</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SGX</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">HyperThreaded</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. NICs</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Bandwidth</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. Disks</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. IOPS</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. Throughput</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">HANA Support</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SAPS 2-Tier</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SAPS 3-Tier</th>
                      </tr>
                    </thead>
                    <tbody v-if="posts && posts.length">
                      <tr v-for="post of posts" role="row">
                        <td class="sorting_1"><a :href="post.linkVmoptimizer">{{post.Name}}</a></td>
                        <td>{{post.Price}}</td>
                        <td>{{post.PricePerMonth}}</td>
                        <td>{{post.Currency}}</td>
                        <td>{{post.Tier}}</td>
                        <td>{{post.Region}}</td>
                        <td>{{post.Contract}}</td>
                        <td>{{post.OperatingSystem}}</td>
                        <td>{{post.ACU}}</td>
                        <td>{{post.SSD}}</td>
                        <td>{{post.Cores}}</td>
                        <td>{{post.Memory}}</td>
                        <td>{{post.Burstable}}</td>
                        <td>{{post.Isolated}}</td>
                        <td>{{post.Infiniband}}</td>
                        <td>{{post.GPU}}</td>
                        <td>{{post.SGX}}</td>
                        <td>{{post.Hyperthreaded}}</td>
                        <td>{{post.MaxNics}}</td>
                        <td>{{post.Bandwidth}}</td>
                        <td>{{post.MaxDataDiskCount}}</td>
                        <td>{{post.MaxVmIops}}</td>
                        <td>{{post.MaxVmThroughputMBs}}</td>
                        <td>{{post.SAPHANA}}</td>
                        <td>{{post.SAPS2T}}</td>
                        <td>{{post.SAPS3T}}</td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <th colspan="1" rowspan="1">Name</th>
                        <th colspan="1" rowspan="1">Price / Hour</th>
                        <th colspan="1" rowspan="1">Price / Month</th>
                        <th colspan="1" rowspan="1">Currency</th>
                        <th colspan="1" rowspan="1">Tier</th>
                        <th colspan="1" rowspan="1">Region</th>
                        <th colspan="1" rowspan="1">Contract</th>
                        <th colspan="1" rowspan="1">OS</th>
                        <th colspan="1" rowspan="1">ACU</th>
                        <th colspan="1" rowspan="1">SSD</th>
                        <th colspan="1" rowspan="1">Cores</th>
                        <th colspan="1" rowspan="1">Memory</th>
                        <th colspan="1" rowspan="1">Burstable</th>
                        <th colspan="1" rowspan="1">Isolated</th>
                        <th colspan="1" rowspan="1">Infiniband</th>
                        <th colspan="1" rowspan="1">GPU</th>
                        <th colspan="1" rowspan="1">SGX</th>
                        <th colspan="1" rowspan="1">HyperThreaded</th>
                        <th colspan="1" rowspan="1">Max. Nics</th>
                        <th colspan="1" rowspan="1">Bandwidth</th>
                        <th colspan="1" rowspan="1">Max. Disks</th>
                        <th colspan="1" rowspan="1">Max. IOPS</th>
                        <th colspan="1" rowspan="1">Max. Throughput</th>
                        <th colspan="1" rowspan="1">HANA Support</th>
                        <th colspan="1" rowspan="1">SAPS 2-Tier</th>
                        <th colspan="1" rowspan="1">SAPS 3-Tier</th>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>

            </div>
            <!-- /.box-body -->
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
  import $ from 'jquery'
  // Require needed datatables modules
  import 'datatables.net'
  import 'datatables.net-bs'
  // Axios needed for API Call
  import axios from 'axios'
  // Config
  import config from '../../config'

  export default {
    name: 'VmChooser',
    mounted() {
      this.$appInsights.trackPageView('VmChooser')
      this.$nextTick(() => {
        $('#example1').DataTable({
          ordering: false,
          searching: false,
          paging: false,
          buttons: [
            'copy', 'excel', 'pdf'
          ]
        })
      })
      this.getMetaDataRegions()
    },
    data() {
      return {
        posts: [],
        errors: [],
        loading: '',
        response: '',
        cores: '',
        memory: '',
        acu: '',
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
        maxresults: '10',
        os: 'linux',
        regions: [],
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
      checkCreds() {
        const { maxresults, cores, memory, acu, capacity, iops, throughput, temp, type, nics, bandwidth, tier, hyperthreaded, burstable, isolated, constrained, contract, peakcpu, peakmemory, region, currency, os, saphana, saps2t, saps3t, gpu, infiniband, sgx } = this
        var vmchooserurl = config.apiGetVmSize +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&acu=' + acu +
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
          '&saphana=' + saphana +
          '&saps2t=' + saps2t +
          '&saps3t=' + saps3t
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.posts = response.data
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
