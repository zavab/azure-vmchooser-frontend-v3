<template>
  <section class="content">
    <div class="row center-block">
      <!-- Search Box Begin -->
      <h2>Parameters</h2>
      <div class="input-group">
        <input class="form-control" placeholder="Minimum disk capacity" type="text">
        <span class="input-group-addon">GB</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Minimum amount of Input Output Operations per Second (IOPS)" type="text">
        <span class="input-group-addon">IO/s</span>
      </div>
      <br />
      <div class="input-group">
        <input class="form-control" placeholder="Minimum throughput/bandwidth" type="text">
        <span class="input-group-addon">MB/s</span>
      </div>
      <br />
      <div class="input-group">
        <select class="form-control">
          <option value="No">Standard only</option>
          <option value="Yes">Premium only</option>
          <option value="All">All options</option>
        </select>
      </div>
      <br />
      <!-- Search Box End -->
    </div>

    <div class="row center-block">
      <h2>Data tables</h2>
      <div class="col-md-12">
        <div class="box">
          <div class="box-header">
            <h3 class="box-title">Data Table With Full Features</h3>
          </div>
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
                        <th aria-label="Name: activate to sort column descending" aria-sort="ascending" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Name</th>
                        <th aria-label="Price: activate to sort column ascending" style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Price / Hour</th>
                        <th aria-label="Currency: activate to sort column ascending" style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Currency</th>
                        <th aria-label="Tier: activate to sort column ascending" style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Tier</th>
                        <th aria-label="Region: activate to sort column ascending" style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Region</th>
                        <th aria-label="Contract: activate to sort column descending" aria-sort="ascending" style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting_asc">Contract</th>
                        <th aria-label="ACU: activate to sort column ascending" style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">ACU</th>
                        <th aria-label="SSD: activate to sort column ascending" style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">SSD</th>
                        <th aria-label="Cores: activate to sort column ascending" style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Cores</th>
                        <th aria-label="Memory: activate to sort column ascending" style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Memory</th>
                        <th aria-label="Burstable: activate to sort column descending" aria-sort="ascending" style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting_asc">Burstable</th>
                        <th aria-label="Isolated: activate to sort column ascending" style="width: 207px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Isolated</th>
                        <th aria-label="HyperThreaded: activate to sort column ascending" style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">HyperThreaded</th>
                        <th aria-label="Max. NICS: activate to sort column ascending" style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Max. NICs</th>
                        <th aria-label="Bandwidth: activate to sort column ascending" style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Bandwidth</th>
                        <th aria-label="Max. Disks: activate to sort column ascending" style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Max. Disks</th>
                        <th aria-label="Max. IOPS: activate to sort column ascending" style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Max. IOPS</th>
                        <th aria-label="Max. Throughput: activate to sort column ascending" style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0" class="sorting">Max. Throughput</th>
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

  export default {
    name: 'VmChooser',
    mounted() {
      this.$nextTick(() => {
        $('#example1').DataTable({
          ordering: false,
          searching: false,
          paging: false
        })
      })
    },
    data() {
      return {
        posts: [],
        errors: []
      }
    },
    created() {
      var vmchooserurl = 'https://vmchooser.azure-api.net/dev-v2/api/GetVmSize'
      var vmchooserconfig = {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Ocp-Apim-Subscription-Key': ''
        }
      }
      axios.get(vmchooserurl, vmchooserconfig)
        .then(response => {
          this.posts = response.data
        })
        .catch(e => {
          this.errors.push(e)
        })
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
