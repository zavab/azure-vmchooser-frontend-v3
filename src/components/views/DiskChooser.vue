<template>
  <section class="content">
    <div class="row center-block">
      <h2>Parameters</h2>
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
        <select class="form-control" v-model="type">
          <option value="No">Standard only</option>
          <option value="Yes">Premium only</option>
          <option value="All">All options</option>
        </select>
      </div>
      <br />
      <div class="input-group">
        <form @submit.prevent="checkCreds">
          <button type="submit" v-bind:class="'btn btn-primary btn-lg ' + loading">Crunch!</button>
        </form>
      </div>
      <!-- errors -->
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div class="row center-block" v-if="description && description.length">
      <div class="col-md-12">
        <div class="box">
          <div class="box-header">
            <h3 class="box-title">Disk Configuration</h3>
          </div>
          <div class="box-body no-padding table-responsive">
            <table class="table table-striped">
              <tbody>
                <tr>
                  <td>Monthly price for entire configuration</td>
                  <td>{{price}} {{currency}}</td>
                </tr>
                <tr>
                  <td>Description</td>
                  <td>{{description}}</td>
                </tr>
                <tr>
                  <td>Disk Type</td>
                  <td>{{disktype}}</td>
                </tr>
                <tr>
                  <td>Disk Used</td>
                  <td>{{diskcount}}</td>
                </tr>
                <tr>
                  <td>Capacity per Disk</td>
                  <td>{{diskcapacity}} GB</td>
                </tr>
                <tr>
                  <td>Capacity for entire config</td>
                  <td>{{configcapacity}} GB</td>
                </tr>
                <tr>
                  <td>IOPS per Disk</td>
                  <td>{{diskiops}}</td>
                </tr>
                <tr>
                  <td>IOPS for entire config</td>
                  <td>{{configiops}}</td>
                </tr>
                <tr>
                  <td>Throughput per Disk</td>
                  <td>{{diskthroughput}} MB/s</td>
                </tr>
                <tr>
                  <td>Throughput for entire config</td>
                  <td>{{configthroughput}} MB/s</td>
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
  import $ from 'jquery'
  // Require needed datatables modules
  import 'datatables.net'
  import 'datatables.net-bs'
  // Axios needed for API Call
  import axios from 'axios'

  export default {
    name: 'DiskChooser',
    mounted () {
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
        errors: [],
        response: '',
        loading: '',
        capacity: '',
        iops: '',
        throughput: '',
        type: '',
        currency: '',
        price: '',
        diskcount: '',
        maxdisks: '16',
        tshirtsize: '',
        disktype: '',
        diskcapacity: '',
        diskiops: '',
        diskthroughput: '',
        configcapacity: '',
        configiops: '',
        configthroughput: '',
        description: ''
      }
    },
    methods: {
      checkCreds() {
        const { capacity, iops, throughput, type } = this
        var vmchooserurl = 'https://vmchooser.azure-api.net/dev-v1/api/getDiskSize?ssd=' + type + '&throughput=' + throughput + '&iops=' + iops + '&data=' + capacity + '&maxdisks=' + this.maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.currency = response.data['Currency']
            this.price = response.data['Price / Month - for all disks'].toFixed(2)
            this.diskcount = response.data['Number of Disks']
            this.tshirtsize = response.data['Disk T-Shirt Size']
            this.disktype = response.data['Disk Type']
            this.diskcapacity = response.data['Capacity (GB) - per disk']
            this.diskiops = response.data['IOPS (IO/s) - per disk']
            this.diskthroughput = response.data['Througput (MB/s) - per disk']
            this.configcapacity = response.data['Capacity (GB) - for all disks']
            this.configiops = response.data['IOPS (IO/s) - for all disks']
            this.configthroughput = response.data['Througput (MB/s) - for all disks']
            this.description = response.data['Description']
            if (!this.price) {
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
