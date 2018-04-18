<template>
  <section class="content">
    <div class="row center-block">
      <h2>Bulk Uploader</h2>
      <div v-if=response class="text-red"><p class="vertical-5p lead">{{response}}</p></div>
    </div>

    <div class="row center-block" v-if="posts.length">
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
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Currency</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Region</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Contract</th>
                        <th style="width: 182px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">SSD</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Min. Cores</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Min. Memory (GB)</th>
                        <th style="width: 167px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Burstable</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Min. NICs</th>
                        <th style="width: 142px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Min. IOPS</th>
                        <th style="width: 101px;" colspan="1" rowspan="1" aria-controls="example1" tabindex="0">Min. Throughput (MB/s)</th>
                      </tr>
                    </thead>
                    <tbody v-if="posts">
                      <tr v-for="post of posts" role="row" :key="post['VM Name']" v-on:click="clickList(post)">
                        <td class="sorting_1">{{post['VM Name']}}</td>
                        <td>{{post.Currency}}</td>
                        <td>{{post.Region}}</td>
                        <td>{{post.Contract}}</td>
                        <td>{{post['SSD [Yes/No]']}}</td>
                        <td>{{post.Cores}}</td>
                        <td>{{post['Memory (GB)']}}</td>
                        <td>{{post.Burstable}}</td>
                        <td>{{post.NICs}}</td>
                        <td>{{post.IOPS}}</td>
                        <td>{{post['Throughput (MB/s)']}}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

            </div>
            <!-- /.box-body -->
          </div>
        </div>
      </div>
    </div>

    <div class="row center-block">
      <form enctype="multipart/form-data" novalidate v-if="isInitial || isSaving">
        <div class="dropbox">
          <input id="files" type="file" multiple :name="uploadFieldName" :disabled="isSaving" @change="filesChange($event.target.name, $event.target.files); fileCount = $event.target.files.length" accept=".csv" class="input-file">
          <p v-if="isInitial">
            Drag your file(s) here to begin<br> or click to browse
          </p>
          <p v-if="isSaving">
            Uploading {{ fileCount }} files...
          </p>
        </div>
      </form>

    </div>

  </section>
</template>

<script>
  import Papa from 'papaparse'

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
        uploadedFiles: [],
        uploadError: null,
        currentStatus: null,
        uploadFieldName: 'inputcsv',
        gridOptions: null
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
        this.posts = []
      },
      clickList(post) {
        console.log(post)
      },
      filesChange(fieldName, fileList) {
        const that = this
        if (!fileList.length) return
        for (var i = 0; i < fileList.length; i++) {
          console.log(fileList[i])
          Papa.parse(fileList[i], {
            header: true,
            dynamicTyping: true,
            complete: function (results) {
              console.log('results', results)
              that.posts = results.data
            },
            error: function(errors) {
              console.log('error', errors)
            }
          })
        }
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
