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
                <option value="No">Standard only</option>
                <option value="Yes">Premium only</option>
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
                <option value="linux">Linux</option>
                <option value="windows">Windows</option>
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
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Currency</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Tier</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Region</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Contract</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">ACU</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SSD</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Cores</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Memory</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Burstable</th>
                        <th style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Isolated</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">HyperThreaded</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. NICs</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Bandwidth</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. Disks</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. IOPS</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Max. Throughput</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">OS</th>
                      </tr>
                    </thead>
                    <tbody v-if="posts && posts.length">
                      <tr v-for="post of posts" role="row">
                        <td class="sorting_1">{{post.Name}}</td>
                        <td>{{post.Price}}</td>
                        <td>{{post.Currency}}</td>
                        <td>{{post.Tier}}</td>
                        <td>{{post.Region}}</td>
                        <td>{{post.Contract}}</td>
                        <td>{{post.ACU}}</td>
                        <td>{{post.SSD}}</td>
                        <td>{{post.Cores}}</td>
                        <td>{{post.Memory}}</td>
                        <td>{{post.Burstable}}</td>
                        <td>{{post.Isolated}}</td>
                        <td>{{post.Hyperthreaded}}</td>
                        <td>{{post.MaxNics}}</td>
                        <td>{{post.Bandwidth}}</td>
                        <td>{{post.MaxDataDiskCount}}</td>
                        <td>{{post.MaxVmIops}}</td>
                        <td>{{post.MaxVmThroughputMBs}}</td>
                        <td>{{post.OperatingSystem}}</td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <th colspan="1" rowspan="1">Name</th>
                        <th colspan="1" rowspan="1">Price / Hour</th>
                        <th colspan="1" rowspan="1">Currency</th>
                        <th colspan="1" rowspan="1">Tier</th>
                        <th colspan="1" rowspan="1">Region</th>
                        <th colspan="1" rowspan="1">Contract</th>
                        <th colspan="1" rowspan="1">ACU</th>
                        <th colspan="1" rowspan="1">SSD</th>
                        <th colspan="1" rowspan="1">Cores</th>
                        <th colspan="1" rowspan="1">Memory</th>
                        <th colspan="1" rowspan="1">Burstable</th>
                        <th colspan="1" rowspan="1">Isolated</th>
                        <th colspan="1" rowspan="1">HyperThreaded</th>
                        <th colspan="1" rowspan="1">Max. Nics</th>
                        <th colspan="1" rowspan="1">Bandwidth</th>
                        <th colspan="1" rowspan="1">Max. Disks</th>
                        <th colspan="1" rowspan="1">Max. IOPS</th>
                        <th colspan="1" rowspan="1">Max. Throughput</th>
                        <th colspan="1" rowspan="1">OS</th>
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
        type: '',
        nics: '',
        bandwidth: '',
        tier: 'standard',
        hyperthreaded: '',
        burstable: '',
        isolated: '',
        contract: '',
        peakcpu: '',
        peakmemory: '',
        region: 'europe-west',
        currency: 'EUR',
        maxresults: '10',
        os: 'linux'
      }
    },
    methods: {
      checkCreds() {
        const { maxresults, cores, memory, acu, capacity, iops, throughput, type, nics, bandwidth, tier, hyperthreaded, burstable, isolated, contract, peakcpu, peakmemory, region, currency, os } = this
        var vmchooserurl = config.apiGetVmSize + '?maxresults=' + maxresults + '&cores=' + cores + '&memory=' + memory + '&acu=' + acu + '&ssd=' + type + '&throughput=' + throughput + '&iops=' + iops + '&data=' + capacity + '&nics=' + nics + '&bandwidth=' + bandwidth + '&tier=' + tier + '&ht=' + hyperthreaded + '&burstable=' + burstable + '&isolated=' + isolated + '&contract=' + contract + '&avgcpupeak=' + peakcpu + '&avgmempeak=' + peakmemory + '&region=' + region + '&currency=' + currency + '&os=' + os
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
