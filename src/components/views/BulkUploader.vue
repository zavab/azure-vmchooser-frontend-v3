<template>
  <section class="content">
    <div class="row center-block">
      <h2>Bulk Uploader</h2>

      <form enctype="multipart/form-data" novalidate v-if="isInitial || isSaving">
        <div class="dropbox">
          <input id="files" type="file" multiple :name="uploadFieldName" :disabled="isSaving" @change="filesChange($event.target.name, $event.target.files); fileCount = $event.target.files.length"
                 accept="image/*" class="input-file">
          <p v-if="isInitial">
            Drag your file(s) here to begin<br> or click to browse
          </p>
          <p v-if="isSaving">
            Uploading {{ fileCount }} files...
          </p>
        </div>
      </form>

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
  // import $ from 'jquery'

  const STATUS_INITIAL = 0
  const STATUS_SAVING = 1
  const STATUS_SUCCESS = 2
  const STATUS_FAILED = 3

  export default {
    name: 'BulkUploader',
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
        uploadedFiles: [],
        uploadError: null,
        currentStatus: null,
        uploadFieldName: 'inputcsv'
      }
    },
    computed: {
      isInitial() {
        return this.currentStatus === STATUS_INITIAL
      },
      isSaving() {
        return this.currentStatus === STATUS_SAVING
      },
      isSuccess() {
        return this.currentStatus === STATUS_SUCCESS
      },
      isFailed() {
        return this.currentStatus === STATUS_FAILED
      }
    },
    methods: {
      reset() {
        // reset form to initial state
        this.currentStatus = STATUS_INITIAL
        this.uploadedFiles = []
        this.uploadError = null
      },
      filesChange(fieldName, fileList) {
        if (!fileList.length) return

        Array
          .from(Array(fileList.length).keys())
          .map(x => {
            console.log(fieldName + ' - ' + fileList[x] + ' - ' + fileList[x].name)
          })
      }
    },
    mounted() {
      this.reset()
    }
  }
</script>


<!-- SASS styling -->
<style lang="scss">
  .dropbox {
    outline: 2px dashed grey; /* the dash box */
    outline-offset: -10px;
    background: lightcyan;
    color: dimgray;
    padding: 10px 10px;
    min-height: 200px; /* minimum height */
    position: relative;
    cursor: pointer;
  }

  .input-file {
    opacity: 0; /* invisible but it's there! */
    width: 100%;
    height: 200px;
    position: absolute;
    cursor: pointer;
  }

  .dropbox:hover {
    background: lightblue; /* when mouse over to the drop zone, change color */
  }

  .dropbox p {
    font-size: 1.2em;
    text-align: center;
    padding: 50px 0;
  }
</style>
