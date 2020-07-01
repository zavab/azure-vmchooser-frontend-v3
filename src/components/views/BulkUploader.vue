<template>
  <div style="width: 100%;">
    <!--
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Does VMchooser make your job easier?</h4>
      Give me a shout-out on <a href="https://twitter.com/kvaes/" target="_blank">Twitter</a>  or in your win-wire!
    </div>
    -->
    <div class="alert alert-success alert-dismissible" v-if="settings">
      <h4><i class="icon fa fa-check"></i> Global Settings Override (Currently only works for RV Tools)</h4>
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
    <div style="padding: 4px;">
      <div style="float: right;">
        <a href="/vmchooser.csv">Sample CSV File</a>
        <input @keyup="onQuickFilterChanged" type="text" id="quickFilterInput"
               placeholder="Type text to filter..." />
        <button @click="showSettings">Settings</button>
        <button @click="exportToCsv">Export to CSV</button>
      </div>
      <div>
        <b>Virtual Machines</b>
        {{rowCount}}
      </div>
      <div>
        <b>Compute</b>
        ({{summaryComputeCountDone}}/{{summaryComputeCountTotal}})
        <b> - OS Disks</b>
        ({{summaryStorageOsCountDone}}/{{summaryStorageOsCountTotal}})
        <b> - Data Disks</b>
        ({{summaryStorageDataCountDone}}/{{summaryStorageDataCountTotal}})
        <b> - Backup</b>
        ({{summaryBackupCountDone}}/{{summaryBackupCountTotal}})
        <b> - Optimizer</b>
        ({{summaryOptimizerCountDone}}/{{summaryOptimizerCountTotal}})
      </div>
    </div>
    <div style="clear: both;"></div>
    <div v-if="showGrid">
      <div style="clear: both;"></div>
      <ag-grid-vue style="width: 100%; height: 600px" class="ag-theme-balham"
                   :gridOptions="gridOptions"
                   :columnDefs="columnDefs"
                   :rowData="rowData"
                   :enableColResize="true"
                   :enableSorting="true"
                   :enableFilter="true"
                   :suppressRowClickSelection="true"
                   rowSelection="multiple"
                   :modelUpdated="onModelUpdated"
                   :rowValueChanged="onRowValueChanged"
                   :rowSelected="onRowSelected"
                   :selectionChanged="onSelectionChanged"
                   :beforeFilterChanged="onBeforeFilterChanged"
                   :afterFilterChanged="onAfterFilterChanged"
                   :filterModified="onFilterModified"
                   :beforeSortChanged="onBeforeSortChanged"
                   :afterSortChanged="onAfterSortChanged"
                   :virtualRowRemoved="onVirtualRowRemoved"
                   :rowClicked="onRowClicked"
                   :gridReady="onReady"
                   :columnEverythingChanged="onColumnEvent"
                   :columnRowGroupChanged="onColumnEvent"
                   :columnValueChanged="onColumnEvent"
                   :columnMoved="onColumnEvent"
                   :columnVisible="onColumnEvent"
                   :columnGroupOpened="onColumnEvent"
                   :columnResized="onColumnEvent"
                   :columnPinnedCountChanged="onColumnEvent">
      </ag-grid-vue>
    </div>
    <div style="clear: both;"></div>
    <div class="row center-block">
      <form enctype="multipart/form-data" novalidate v-if="isInitial || isSaving">
        <div class="dropbox">
          <input id="files" type="file" multiple :name="uploadFieldName" :disabled="isSaving" @change="filesChange($event.target.name, $event.target.files); fileCount = $event.target.files.length" accept=".csv,.xlsx" class="input-file">
          <p v-if="isInitial">
            Drag your file(s) here to begin<br> or click to browse
          </p>
          <p v-if="isSaving">
            Uploading {{ fileCount }} files...
          </p>
        </div>
      </form>

    </div>
  </div>
</template>
<script>
  import { AgGridVue } from 'ag-grid-vue'
  import Papa from 'papaparse'
  import axios from 'axios'
  import rateLimit from 'axios-rate-limit'
  import config from '../../config'

  import XLSX from 'xlsx'

  import '../../../node_modules/ag-grid-community/dist/styles/ag-grid.css'
  import '../../../node_modules/ag-grid-community/dist/styles/ag-theme-balham.css'

  const http = rateLimit(axios.create(), { maxRequests: 10, perMilliseconds: 1000 })

  const STATUS_INITIAL = 0
  const STATUS_SAVING = 1
  const STATUS_SUCCESS = 2
  const STATUS_FAILED = 3

  const COUNTRY_CODES = {
    'europe-north': 'ie',
    'europe-west': 'nl',
    'canada-central': 'ca',
    'canada-east': 'ca',
    'United Kingdom': 'gb',
    'france-south': 'fr',
    'france-central': 'fr',
    'germany-central': 'de',
    'germany-northeast': 'de',
    'japan-east': 'jp',
    'japan-west': 'jp',
    'australia-east': 'au',
    'australia-central': 'au',
    'australia-central-2': 'au',
    'australia-southeast': 'au',
    'brazil-south': 'br',
    'asia-pacific-southeast': 'sg',
    'asia-pacific-east': 'cn',
    'korea-central': 'kr',
    'korea-south': 'kr',
    'west-india': 'in',
    'central-india': 'in',
    'south-india': 'in',
    'united-kingdom-south': 'gb',
    'united-kingdom-west': 'gb',
    'us-central': 'us',
    'us-east': 'us',
    'us-east-2': 'us',
    'usgov-arizona': 'us',
    'usgov-iowa': 'us',
    'usgov-texas': 'us',
    'usgov-virginia': 'us',
    'us-north-central': 'us',
    'us-south-central': 'us',
    'us-west': 'us',
    'us-west-2': 'us',
    'us-west-central': 'us'
  }

  function priceComparator(price1, price2) {
    price1 = price1.toLocaleString()
    price2 = price2.toLocaleString()
    return price1 - price2
  }

  export default {
    data() {
      return {
        settings: false,
        burstable: 'All',
        os: 'linux',
        contract: 'ri3y',
        region: 'europe-west',
        currency: 'EUR',
        gridOptions: null,
        columnDefs: null,
        rowData: null,
        showGrid: false,
        showToolPanel: false,
        rowCount: null,
        loading: '',
        response: '',
        uploadedFiles: [],
        uploadError: null,
        currentStatus: null,
        uploadFieldName: 'inputcsv',
        summaryCompute: 0,
        summaryOsDisks: 0,
        summaryDataDisks: 0,
        summaryComputeCountDone: 0,
        summaryComputeCountTotal: 0,
        summaryStorageOsCountDone: 0,
        summaryStorageOsCountTotal: 0,
        summaryStorageDataCountDone: 0,
        summaryStorageDataCountTotal: 0,
        summaryBackupCountDone: 0,
        summaryBackupCountTotal: 0,
        summaryOptimizerCountDone: 0,
        summaryOptimizerCountTotal: 0,
        regions: [],
        AzureMigrateProperties: []
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
    components: {
      'ag-grid-vue': AgGridVue
    },
    methods: {
      reset() {
        // reset form to initial state
        this.currentStatus = STATUS_INITIAL
        this.uploadedFiles = []
        this.uploadError = null
        this.posts = []
      },
      resetCounters() {
        this.summaryComputeCountDone = 0
        this.summaryComputeCountTotal = 0
        this.summaryStorageDataCountDone = 0
        this.summaryStorageDataCountTotal = 0
        this.summaryStorageOsCountDone = 0
        this.summaryStorageOsCountTotal = 0
        this.rowCount = 0
      },
      showSettings() {
        if (this.settings) {
          console.log('hide settings')
          this.settings = false
        } else {
          console.log('show settings')
          this.settings = true
        }
      },
      exportToCsv() {
        this.gridOptions.api.exportDataAsCsv()
      },
      getAzureMigrateProperties(search) {
        const that = this
        var json = that.AzureMigrateProperties
        for (var i in json) {
          if (json[i].myproperty.toUpperCase() === search.toUpperCase()) {
            return (json[i].myvalue)
          }
        }
        return null
      },
      setAzureMigrateProperties(properties) {
        const that = this
        var results = []
        var number = 0
        var character = 'A'
        for (var key in properties) {
          // var cell = properties[i]
          number = key.replace(/^\D+/g, '')
          var index = parseInt(number)
          character = key.replace(/[^A-Za-z]+/g, '')
          if (character.length < 3 && typeof results[index] === 'undefined') {
            results[index] = []
          }
          if (character.toUpperCase() === 'A') {
            results[index].myproperty = properties[key].v
          }
          if (character.toUpperCase() === 'B') {
            results[index].myvalue = properties[key].v
          }
        }
        that.AzureMigrateProperties = results
      },
      getAzureRegionSlug(name) {
        var regions = this.regions
        for (var key in regions) {
          if (regions[key].Name.toUpperCase() === name.toUpperCase()) {
            return (regions[key].Slug)
          }
        }
        return null
      },
      getAzureRegions() {
        var vmchooserurl = config.apiGetRegions
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            this.regions = response.data
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      parseRvTools(workbook) {
        // Initialize Results
        var results = []
        // Read Worksheets
        var worksheet = workbook.Sheets['vInfo']
        console.log(worksheet)
        // Sheet to JSON
        var json = XLSX.utils.sheet_to_json(worksheet)
        for (var i = 0; i < json.length; i++) {
          results[i] = []
          results[i]['VM Name'] = json[i]['VM']
          results[i]['Region'] = this.region
          results[i]['Cores'] = json[i]['CPUs']
          results[i]['Memory (GB)'] = Math.ceil((json[i]['Memory'] / 1024), 0)
          results[i]['SSD [Yes/No]'] = 'All'
          results[i]['Max Disk Size (TB)'] = json[i]['Provisioned MB'] / 1024 / 1024
          results[i]['IOPS'] = 1
          results[i]['Throughput (MB/s)'] = 1
          results[i]['Min Temp Disk Size (GB)'] = 1
          results[i]['Peak CPU Usage (%)'] = 100
          results[i]['Peak Memory Usage (%)'] = 100
          results[i]['Currency'] = this.currency
          results[i]['Contract'] = this.contract
          results[i]['Burstable'] = 'All'
          results[i]['OS'] = this.os
          results[i]['NICs'] = json[i]['NICs']
          results[i]['OSDISK'] = 1
          results[i]['OVERRIDEDISKTYPE'] = 'All'
        }
        console.log(results)
        return results
      },
      parseAzureMigrate(workbook) {
        // Initialize Results
        var results = []
        // Read Worksheets
        var worksheet = workbook.Sheets['All_Assessed_Machines']
        var assessmentproperties = workbook.Sheets['Assessment_Properties']
        // Parse Properties
        this.setAzureMigrateProperties(assessmentproperties)
        var currency = this.getAzureMigrateProperties('Currency')
        var contract = this.getAzureMigrateProperties('Offer')
        var contractmatches = contract.match(/\b(\w)/g)
        contract = contractmatches.join('').toLowerCase()
        var region = this.getAzureMigrateProperties('Target Location')
        region = this.getAzureRegionSlug(region)
        var HUB = this.getAzureMigrateProperties('Hybrid use benefit')
        var os = 'linux'
        if (HUB.toUpperCase() !== 'YES') {
          os = 'Windows'
        }
        console.log(currency + '/' + contract + '/' + region + '/' + os)
        // Sheet to JSON
        var json = XLSX.utils.sheet_to_json(worksheet)
        for (var i = 0; i < json.length; i++) {
          results[i] = []
          results[i]['VM Name'] = json[i]['Machine']
          results[i]['Region'] = region
          results[i]['Cores'] = json[i]['Cores']
          results[i]['Memory (GB)'] = Math.ceil((json[i]['Memory(MB)'] / 1024), 0)
          results[i]['SSD [Yes/No]'] = 'All'
          results[i]['Max Disk Size (TB)'] = json[i]['Storage(GB)'] / 1024
          results[i]['IOPS'] = json[i]['Disk read(ops/sec)'] + json[i]['Disk write(ops/sec)']
          results[i]['Throughput (MB/s)'] = json[i]['Disk read(MBPS)'] + json[i]['Disk write(MBPS)']
          results[i]['Min Temp Disk Size (GB)'] = 1
          results[i]['Peak CPU Usage (%)'] = json[i]['CPU usage(%)']
          results[i]['Peak Memory Usage (%)'] = json[i]['Memory usage(%)']
          results[i]['Currency'] = currency
          results[i]['Contract'] = contract
          results[i]['Burstable'] = 'All'
          results[i]['OS'] = os
          results[i]['NICs'] = json[i]['Network adapters']
          results[i]['OSDISK'] = 1
          results[i]['OVERRIDEDISKTYPE'] = 'All'
        }
        return results
      },
      parseExcel(file) {
        const that = this
        var reader = new FileReader()
        reader.onload = function (e) {
          // pre-process data
          var binary = ''
          var bytes = new Uint8Array(e.target.result)
          var length = bytes.byteLength
          for (var i = 0; i < length; i++) {
            binary += String.fromCharCode(bytes[i])
          }
          // Read Workbook
          var workbook = XLSX.read(binary, { type: 'binary' })
          var results = []
          // Azure Migrate Excel
          if (workbook.Sheets['All_Assessed_Machines'] != null) {
            that.$appInsights.trackPageView('BulkUploader - XLSX - Azure Migrate')
            results.data = that.parseAzureMigrate(workbook)
            that.updateRowData(results)
          }
          // RV Tools Excel
          if (workbook.Sheets['vInfo'] != null) {
            that.$appInsights.trackPageView('BulkUploader - XLSX - RV Tools')
            results.data = that.parseRvTools(workbook)
            that.updateRowData(results)
          }
        }
        reader.readAsArrayBuffer(file)
      },
      filesChange(fieldName, fileList) {
        const that = this
        if (!fileList.length) return
        for (var i = 0; i < fileList.length; i++) {
          var filename = fileList[i].name
          var extension = filename.split('.').pop()
          if (extension.toLowerCase() === 'xlsx') {
            this.parseExcel(fileList[i])
          }
          if (extension.toLowerCase() === 'csv') {
            this.$appInsights.trackPageView('BulkUploader - CSV')
            Papa.parse(fileList[i], {
              header: true,
              dynamicTyping: true,
              complete: function (results) {
                // console.log('results', results)
                that.updateRowData(results)
              },
              error: function (errors) {
                console.log('error', errors)
              }
            })
          }
        }
      },
      getSummary() {
        var compute = 0
        var storageos = 0
        var storagedata = 0
        for (var i = 0; i < this.rowData.length; i++) {
          var tmpRow = this.rowData[i]
          compute = compute + parseFloat(tmpRow.compute_price_month)
          storageos = storageos + parseFloat(tmpRow.storage_os_price)
          storagedata = storagedata + parseFloat(tmpRow.storage_data_price)
          console.log(i + ':' + compute + ' - ' + storageos + ' - ' + storagedata)
        }
        this.summaryCompute = parseFloat(compute).toFixed(2)
        this.summaryOsDisks = parseFloat(storageos).toFixed(2)
        this.summaryDataDisks = parseFloat(storagedata).toFixed(2)
      },
      checkMemory(memory) {
        var fixedmemory = memory
        if (memory > 1000 && memory % 1024 === 0) {
          // fixedmemory = (memory / 1024)
          alert('Could it be that you entered the memory in MB instead of GB? If you meant to match for TB of memory, ignore this message. If not, please adapt your input file as memory needs to be specified in GB (and not in MB).')
        }
        return fixedmemory
      },
      updateRowData(newResults) {
        this.resetCounters()
        var tempData = []
        for (var i = 0; i < newResults.data.length; i++) {
          var tempRow = newResults.data[i]
          if (tempRow['Cores'] === undefined || tempRow['Cores'] === null) {
            tempRow['Cores'] = '0'
          }
          if (tempRow['NICs'] === undefined || tempRow['NICs'] === null) {
            tempRow['NICs'] = '1'
          }
          if (tempRow['IOPS'] === undefined || tempRow['IOPS'] === null) {
            tempRow['IOPS'] = '1'
          }
          if (tempRow['Throughput (MB/s)'] === undefined || tempRow['Throughput (MB/s)'] === null) {
            tempRow['Throughput (MB/s)'] = '1'
          }
          if (tempRow['Min Temp Disk Size (GB)'] === undefined || tempRow['Min Temp Disk Size (GB)'] === null) {
            tempRow['Min Temp Disk Size (GB)'] = '1'
          }
          if (tempRow['Peak CPU Usage (%)'] === undefined || tempRow['Peak CPU Usage (%)'] === null) {
            tempRow['Peak CPU Usage (%)'] = '100'
          }
          if (tempRow['Peak Memory Usage (%)'] === undefined || tempRow['Peak Memory Usage (%)'] === null) {
            tempRow['SAPPeak Memory Usage (%)S2T'] = '100'
          }
          if (tempRow['OS'] === undefined || tempRow['OS'] === null) {
            tempRow['OS'] = 'linux'
          }
          if (tempRow['SAPHANA'] === undefined || tempRow['SAPHANA'] === null || tempRow['SAPHANA'].toLowerCase !== 'yes') {
            tempRow['SAPHANA'] = 'All'
          }
          if (tempRow['SAPS2T'] === undefined || tempRow['SAPS2T'] === null) {
            tempRow['SAPS2T'] = '-127'
          }
          if (tempRow['SAPS3T'] === undefined || tempRow['SAPS3T'] === null) {
            tempRow['SAPS3T'] = '-127'
          }
          if (tempRow['SISLA'] === undefined || tempRow['SISLA'] === null) {
            tempRow['SISLA'] = 'No'
          }
          if (tempRow['ACU'] === undefined || tempRow['ACU'] === null) {
            tempRow['ACU'] = '-127'
          }
          if (tempRow['DBU'] === undefined || tempRow['DBU'] === null) {
            tempRow['DBU'] = '-127'
          }
          if (tempRow['SSD [Yes/No]'] !== undefined) {
            tempRow['SSD'] = tempRow['SSD [Yes/No]']
          }
          if (tempRow['OSDISK'] === undefined || tempRow['OSDISK'] === null) {
            tempRow['OSDISK'] = '100'
          }
          if (tempRow['INFINIBAND'] === undefined || tempRow['INFINIBAND'] === null) {
            tempRow['INFINIBAND'] = 'All'
          }
          if (tempRow['GPU'] === undefined || tempRow['GPU'] === null) {
            tempRow['GPU'] = 'All'
          }
          // GB overrides TB for data field
          if (tempRow['Data Disk Size (GB)'] !== undefined) {
            tempRow['Max Disk Size (TB)'] = tempRow['Data Disk Size (GB)'] / 1024
          } else {
            if (tempRow['Max Disk Size (TB)'] === undefined || tempRow['Max Disk Size (TB)'] === null) {
              tempRow['Max Disk Size (TB)'] = '0'
            }
          }
          // Backup Related
          if (tempRow['RETENTIONPOINTS'] === undefined || tempRow['RETENTIONPOINTS'] === null) {
            tempRow['RETENTIONPOINTS'] = '0'
          }
          if (tempRow['CHURN'] === undefined || tempRow['CHURN'] === null) {
            tempRow['CHURN'] = '2'
          }
          if (tempRow['COMPRESSION'] === undefined || tempRow['COMPRESSION'] === null) {
            tempRow['COMPRESSION'] = '30'
          }
          if (tempRow['RESILIENCY'] === undefined || tempRow['RESILIENCY'] === null) {
            tempRow['RESILIENCY'] = 'lrs'
          }
          if (tempRow['SKU'] === undefined || tempRow['SKU'] === null) {
            tempRow['SKU'] = 'Unknown'
          }
          if (tempRow['AROMASTER'] === undefined || tempRow['AROMASTER'] === null) {
            tempRow['AROMASTER'] = 'All'
          }
          if (tempRow['AROWORKER'] === undefined || tempRow['AROWORKER'] === null) {
            tempRow['AROWORKER'] = 'All'
          }
          if (tempRow['VM Name']) {
            this.getVmSize(
              i,
              tempRow['Region'],
              tempRow['Cores'],
              this.checkMemory(tempRow['Memory (GB)']),
              tempRow['SSD'],
              tempRow['NICs'],
              tempRow['Max Disk Size (TB)'] * 1024,
              tempRow['IOPS'],
              tempRow['Throughput (MB/s)'],
              tempRow['Min Temp Disk Size (GB)'],
              tempRow['Peak CPU Usage (%)'],
              tempRow['Peak Memory Usage (%)'],
              tempRow['Currency'],
              tempRow['Contract'],
              tempRow['Burstable'],
              tempRow['OS'],
              tempRow['SAPHANA'],
              tempRow['SAPS2T'],
              tempRow['SAPS3T'],
              tempRow['SISLA'],
              tempRow['OVERRIDEDISKTYPE'],
              tempRow['OSDISK'],
              tempRow['GPU'],
              tempRow['INFINIBAND'],
              tempRow['RETENTIONPOINTS'],
              tempRow['CHURN'],
              tempRow['COMPRESSION'],
              tempRow['RESILIENCY'],
              tempRow['ACU'],
              tempRow['DBU'],
              tempRow['AROMASTER'],
              tempRow['AROWORKER']
            )
            tempData.push({
              name: tempRow['VM Name'],
              region: tempRow['Region'],
              cores: tempRow['Cores'],
              memory: this.checkMemory(tempRow['Memory (GB)']),
              contract: tempRow['Contract'],
              currency: tempRow['Currency'],
              ssd: tempRow['SSD'],
              nics: tempRow['NICs'],
              maxdatadisksize: tempRow['Max Disk Size (TB)'] * 1024,
              temp: tempRow['Min Temp Disk Size (GB)'],
              iops: tempRow['IOPS'],
              throughput: tempRow['Throughput (MB/s)'],
              peakcpu: tempRow['Peak CPU Usage (%)'],
              peakmemory: tempRow['Peak Memory Usage (%)'],
              burstable: tempRow['Burstable'],
              os: tempRow['OS'],
              saphana: tempRow['SAPHANA'],
              saps2t: tempRow['SAPS2T'],
              saps3t: tempRow['SAPS3T'],
              sisla: tempRow['SISLA'],
              overridedisktype: tempRow['OVERRIDEDISKTYPE'],
              osdisk: tempRow['OSDISK'],
              gpu: tempRow['GPU'],
              infiniband: tempRow['INFINIBAND'],
              retentionpoints: tempRow['RETENTIONPOINTS'],
              churn: tempRow['CHURN'],
              compression: tempRow['COMPRESSION'],
              resiliency: tempRow['RESILIENCY'],
              acu: tempRow['ACU'],
              dbu: tempRow['DBU'],
              aromaster: tempRow['AROMASTER'],
              aroworker: tempRow['AROWORKER']
            })
          }
        }
        this.rowData = tempData
      },
      createRowData() {
        const rowData = []

        this.rowData = rowData
      },
      createColumnDefs() {
        this.columnDefs = [
          {
            headerName: '#',
            width: 30,
            checkboxSelection: true,
            suppressMenu: true,
            pinned: true
          },
          {
            headerName: 'Input',
            children: [
              {
                headerName: 'Name',
                field: 'name',
                width: 150,
                editable: true
              },
              {
                headerName: 'Region',
                field: 'region',
                width: 150,
                cellRenderer: countryCellRenderer,
                filterParams: {
                  cellRenderer: countryCellRenderer,
                  cellHeight: 20
                },
                editable: true
              },
              {
                headerName: 'Cores',
                field: 'cores',
                width: 100,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Memory (GB)',
                field: 'memory',
                width: 150,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'SSD',
                field: 'ssd',
                width: 150,
                editable: true
              },
              {
                headerName: 'ACU',
                field: 'acu',
                width: 150,
                editable: true
              },
              {
                headerName: 'DBU',
                field: 'dbu',
                width: 150,
                editable: true
              },
              {
                headerName: 'AROMASTER',
                field: 'aromaster',
                width: 150,
                editable: true
              },
              {
                headerName: 'AROWORKER',
                field: 'aroworker',
                width: 150,
                editable: true
              },
              {
                headerName: 'NICs',
                field: 'nics',
                width: 150,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. Data Disks Capacity (in GB)',
                field: 'maxdatadisksize',
                width: 250,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. IOPS',
                field: 'iops',
                width: 150,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. Throughput (MB/s)',
                field: 'throughput',
                width: 200,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. Temp disk (GB)',
                field: 'temp',
                width: 200,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Peak CPU in 95pct (%)',
                field: 'peakcpu',
                width: 200,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Peak Memory in 95pct (%)',
                field: 'peakmemory',
                width: 200,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Currency',
                field: 'currency',
                width: 150,
                editable: true
              },
              {
                headerName: 'Contract',
                field: 'contract',
                width: 150,
                editable: true
              },
              {
                headerName: 'Operating System',
                field: 'os',
                width: 150,
                editable: true
              },
              {
                headerName: 'Burstable',
                field: 'burstable',
                width: 150,
                editable: true
              },
              {
                headerName: 'SAP HANA',
                field: 'saphana',
                width: 150,
                editable: true
              },
              {
                headerName: 'SAPS 2-Tier',
                field: 'saps2t',
                width: 150,
                editable: true
              },
              {
                headerName: 'SAPS 3-Tier',
                field: 'saps3t',
                width: 150,
                editable: true
              },
              {
                headerName: 'Single Instance SLA',
                field: 'sisla',
                width: 150,
                editable: true
              },
              {
                headerName: 'Override Disk Type',
                field: 'overridedisktype',
                width: 150,
                editable: true
              },
              {
                headerName: 'OS Disk Size',
                field: 'osdisk',
                width: 150,
                editable: true
              },
              {
                headerName: 'GPU',
                field: 'gpu',
                width: 150,
                editable: true
              },
              {
                headerName: 'Infiniband',
                field: 'infiniband',
                width: 150,
                editable: true
              },
              {
                headerName: 'Retention Points (#)',
                field: 'retentionpoints',
                width: 150,
                editable: true
              },
              {
                headerName: 'Churn (Daily/%)',
                field: 'churn',
                width: 150,
                editable: true
              },
              {
                headerName: 'Compression (%)',
                field: 'compression',
                width: 150,
                editable: true
              },
              {
                headerName: 'Resiliency',
                field: 'resiliency',
                width: 150,
                editable: true
              }
            ]
          },
          {
            headerName: 'Compute',
            children: [
              {
                headerName: 'VM Size Name',
                field: 'compute_name',
                width: 150,
                filter: 'number'
              },
              {
                headerName: 'Price per Hour',
                field: 'compute_price_hour',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Price per Day',
                field: 'compute_price_day',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Price per Month (730 hours)',
                field: 'compute_price_month',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'SKU',
                field: 'compute_sku',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Cores',
                field: 'compute_cores',
                width: 100,
                filter: 'number'
              },
              {
                headerName: 'Memory (GB)',
                field: 'compute_memory',
                width: 150,
                filter: 'number'
              },
              {
                headerName: 'ACU',
                field: 'compute_acu',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Tier',
                field: 'compute_tier',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Hyperthreaded',
                field: 'compute_hyperthreaded',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Burstable',
                field: 'compute_burstable',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Isolated',
                field: 'compute_isolated',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'SSD Capable',
                field: 'compute_data_ssdcapable',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Max. # Data Disks',
                field: 'compute_data_maxdisks',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Max. Data Capacity (GB)',
                field: 'compute_data_maxcapacity',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'Max. Data IOPS',
                field: 'compute_data_maxiops',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Max. Data Throughput',
                field: 'compute_data_maxthroughput',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'Max. NICs',
                field: 'compute_net_maxnics',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Max. Bandwidth (Mbps)',
                field: 'compute_net_maxbandwidth',
                width: 200,
                filter: 'text'
              }
            ]
          },
          {
            headerName: 'Storage - Operating System Disk',
            children: [
              {
                headerName: 'OS Disk Type',
                field: 'storage_os_type',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'OS Disk Size',
                field: 'storage_os_size',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'OS Disk Capacity (in GB)',
                field: 'storage_os_capacity',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'OS Disk Price (per Month)',
                field: 'storage_os_price',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              }
            ]
          },
          {
            headerName: 'Storage - Data Disks',
            children: [
              {
                headerName: 'Data Disk Type',
                field: 'storage_data_type',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Config Description',
                field: 'storage_data_config_description',
                width: 300,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Size',
                field: 'storage_data_disk_size',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Data Disk IOPS',
                field: 'storage_data_disk_iops',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Capacity (in GB)',
                field: 'storage_data_disk_capacity',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Throughput (in MB/s)',
                field: 'storage_data_disk_throughput',
                width: 250,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Count per Config',
                field: 'storage_data_config_diskcount',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'Data Disk IOPS per Config',
                field: 'storage_data_config_iops',
                width: 200,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Capacity (in GB) per Config',
                field: 'storage_data_config_capacity',
                width: 250,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Throughput (in MB/s) per Config',
                field: 'storage_data_config_throughput',
                width: 300,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Price (per Month)',
                field: 'storage_data_price',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              }
            ]
          },
          {
            headerName: 'Backup',
            children: [
              {
                headerName: 'Total Backup Cost (per Month)',
                field: 'backup_cost_total',
                width: 200,
                filter: 'number'
              },
              {
                headerName: 'Instance Backup Cost (per Month)',
                field: 'backup_cost_instance',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Storage Backup Cost (per Month)',
                field: 'backup_cost_storage',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Total Backup Size (in GB)',
                field: 'backup_size_total',
                width: 200,
                filter: 'number',
                comparator: priceComparator
              }
            ]
          },
          {
            headerName: 'VM Optimizer - Contract Variants (price per hour)',
            children: [
              {
                headerName: 'VM Size',
                field: 'contract_vmsize',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Linux - PAYG',
                field: 'contract_lnx_payg',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Linux - RI1Y',
                field: 'contract_lnx_ri1y',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Linux - RI3Y',
                field: 'contract_lnx_ri3y',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - PAYG',
                field: 'contract_win_payg',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - RI1Y',
                field: 'contract_win_ri1y',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - RI3Y',
                field: 'contract_win_ri3y',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              }
            ]
          },
          {
            headerName: 'VM Optimizer - Contract Variants (price per month)',
            children: [
              {
                headerName: 'Linux - PAYG - Month',
                field: 'contract_lnx_payg_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Linux - RI1Y - Month',
                field: 'contract_lnx_ri1y_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Linux - RI3Y - Month',
                field: 'contract_lnx_ri3y_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - PAYG - Month',
                field: 'contract_win_payg_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - RI1Y - Month',
                field: 'contract_win_ri1y_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              },
              {
                headerName: 'Windows - RI3Y - Month',
                field: 'contract_win_ri3y_month',
                width: 150,
                filter: 'number',
                comparator: priceComparator
              }
            ]
          }
        ]
      },
      fixNumberFormatting(input) {
        return input.toLocaleString()
      },
      getBackup(index, region, currency, retentionpoints, churn, compression, size, resiliency) {
        var vmchooserurl = config.apiGetBackup +
          '?region=' + region +
          '&currency=' + currency +
          '&daily=' + retentionpoints +
          '&weekly=' + 0 +
          '&monthly=' + 0 +
          '&yearly=' + 0 +
          '&churn=' + churn +
          '&compression=' + compression +
          '&size=' + size +
          '&resiliency=' + resiliency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        this.summaryBackupCountTotal = this.summaryBackupCountTotal + 1
        http.post(vmchooserurl, '', vmchooserconfig)
          /*
              {
                "CostInstance": "16.866",
                "SizeTotal": "1324.000",
                "CostStorage": "26.7967008000"
              }
          */
          .then(response => {
            this.costinstance = response.data['CostInstance']
            this.coststorage = response.data['CostStorage']
            this.sizetotal = response.data['SizeTotal']
            var costtotal = this.fixNumberFormatting(parseFloat(this.costinstance) + parseFloat(this.coststorage))
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('backup_cost_total', costtotal)
            rowNode.setDataValue('backup_cost_instance', response.data['CostInstance'])
            rowNode.setDataValue('backup_cost_storage', response.data['CostStorage'])
            rowNode.setDataValue('backup_size_total', response.data['SizeTotal'])
            this.summaryBackupCountDone = this.summaryBackupCountDone + 1
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      getDataDiskConfig(index, ssdclass, ssdtype, currency, maxdisks, throughput, iops, capacity) {
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssdclass +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&throughput=' + throughput +
          '&iops=' + iops +
          '&data=' + capacity +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        this.summaryStorageDataCountTotal = this.summaryStorageDataCountTotal + 1
        http.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('storage_data_type', response.data.DiskType)
            rowNode.setDataValue('storage_data_config_description', response.data.DiskConfigDescription)
            rowNode.setDataValue('storage_data_disk_size', response.data.DiskSize)
            rowNode.setDataValue('storage_data_disk_capacity', response.data.DiskCapacity)
            rowNode.setDataValue('storage_data_disk_iops', response.data.DiskIops)
            rowNode.setDataValue('storage_data_disk_throughput', response.data.DiskThroughput)
            rowNode.setDataValue('storage_data_config_diskcount', response.data.DiskCount)
            rowNode.setDataValue('storage_data_config_capacity', response.data.DiskConfigCapacity)
            rowNode.setDataValue('storage_data_config_iops', response.data.DiskConfigIops)
            rowNode.setDataValue('storage_data_config_throughput', response.data.DiskConfigThroughput)
            rowNode.setDataValue('storage_data_price', this.fixNumberFormatting(response.data.DiskPrice))
            this.summaryStorageDataCountDone = this.summaryStorageDataCountDone + 1
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
      getOsDisk(index, ssdclass, ssdtype, currency, osdisk) {
        var maxdisks = '1'
        var vmchooserurl = config.apiGetDiskConfig +
          '?ssd=' + ssdclass +
          '&disktype=' + ssdtype +
          '&currency=' + currency +
          '&data=' + osdisk +
          '&maxdisks=' + maxdisks
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        this.summaryStorageOsCountTotal = this.summaryStorageOsCountTotal + 1
        http.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('storage_os_type', response.data.DiskType)
            rowNode.setDataValue('storage_os_size', response.data.DiskSize)
            rowNode.setDataValue('storage_os_capacity', response.data.DiskConfigCapacity)
            rowNode.setDataValue('storage_os_price', this.fixNumberFormatting(response.data.DiskPrice))
            this.summaryStorageOsCountDone = this.summaryStorageOsCountDone + 1
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
      getVmSize(index, region, cores, memory, ssd, nics, capacity, iops, throughput, temp, peakcpu, peakmemory, currency, contract, burstable, os, saphana, saps2t, saps3t, sisla, overridedisktype, osdisk, gpu, infiniband, retentionpoints, churn, compression, resiliency, acu, dbu, aromaster, aroworker) {
        // console.log('Disk (' + index + '): ' + capacity)
        // Initialize
        var ssdtype = overridedisktype
        if (ssdtype === undefined) {
          ssdtype = 'All'
          console.log('ssdtype was undefined')
        }

        // SISLA or "single instance sla"
        sisla = sisla.toLowerCase()
        if (sisla === 'yes') {
          ssd = 'Yes'
          ssdtype = 'premiumssd'
        }

        var maxresults = '1'
        var vmchooserurl = config.apiGetVmSize +
          '?maxresults=' + maxresults +
          '&cores=' + cores +
          '&memory=' + memory +
          '&ssd=' + ssd +
          '&acu=' + acu +
          '&dbu=' + dbu +
          '&throughput=' + throughput +
          '&iops=' + iops +
          '&data=' + capacity +
          '&nics=' + nics +
          '&burstable=' + burstable +
          '&gpu=' + gpu +
          '&infiniband=' + infiniband +
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

        this.summaryComputeCountTotal = this.summaryComputeCountTotal + 1
        http.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('compute_name', response.data[0].Name)
            rowNode.setDataValue('compute_price_hour', this.fixNumberFormatting(response.data[0].Price))
            rowNode.setDataValue('compute_price_day', this.fixNumberFormatting(response.data[0].Price * 24))
            rowNode.setDataValue('compute_price_month', this.fixNumberFormatting(response.data[0].Price * 730))
            rowNode.setDataValue('compute_sku', response.data[0].SKU)
            rowNode.setDataValue('compute_cores', response.data[0].Cores)
            rowNode.setDataValue('compute_memory', response.data[0].Memory)
            rowNode.setDataValue('compute_acu', response.data[0].ACU)
            rowNode.setDataValue('compute_tier', response.data[0].Tier)
            rowNode.setDataValue('compute_hyperthreaded', response.data[0].Hyperthreaded)
            rowNode.setDataValue('compute_burstable', response.data[0].Burstable)
            rowNode.setDataValue('compute_isolated', response.data[0].Isolated)
            rowNode.setDataValue('compute_data_ssdcapable', response.data[0].SSD)
            rowNode.setDataValue('compute_data_maxdisks', response.data[0].MaxDataDiskCount)
            rowNode.setDataValue('compute_data_maxcapacity', response.data[0].MaxDataDiskSizeGB)
            rowNode.setDataValue('compute_data_maxiops', response.data[0].MaxVmIops)
            rowNode.setDataValue('compute_data_maxthroughput', response.data[0].MaxVmThroughputMBs)
            rowNode.setDataValue('compute_net_maxnics', response.data[0].MaxDataDiskCount)
            rowNode.setDataValue('compute_net_maxbandwidth', response.data[0].Bandwidth)
            this.summaryComputeCountDone = this.summaryComputeCountDone + 1
            /*
            ACU: 210
            Bandwidth: 6000
            Burstable: "No"
            Contract: "ri3y"
            Cores: 8
            Currency: "JPY"
            Hyperthreaded: "No"
            Isolated: "No"
            MaxDataDiskCount: 32
            MaxDataDiskIops: 240000
            MaxDataDiskSizeGB: 131072
            MaxDataDiskThroughputMBs: 8000
            MaxNics: 8
            MaxVmIops: 25600
            MaxVmThroughputMBs: 384
            Memory: 16
            Name: "f8s"
            OfferName: "linux-f8s-standard"
            Price: 22.65522
            Region: "europe-west"
            SSD: "Yes"
            Tier: "standard"
            price_AUD: 0.282901507
            price_CAD: 0.270063549
            price_CHF: 0.200587541
            price_DKK: 1.397827074
            price_EUR: 0.187305363
            price_GBP: 0.16554058199
            price_IDR: 3034.0226
            price_INR: 14.6806380875
            price_JPY: 22.65522
            price_SEK: 1.748272232
            price_USD: 0.22211
            */
            // Initialize the values with 0 for the summary
            rowNode.setDataValue('storage_os_price', 0)
            rowNode.setDataValue('storage_data_price', 0)

            // Get os price
            this.getOsDisk(index, ssd, ssdtype, currency, osdisk)
            if (capacity > osdisk) {
              this.getDataDiskConfig(index, ssd, ssdtype, currency, response.data[0].MaxDataDiskCount, throughput, iops, capacity)
            }
            if (retentionpoints > 0) {
              this.getBackup(index, region, currency, retentionpoints, churn, compression, capacity, resiliency)
            }
            this.getVmOptimizerOptions(index, response.data[0].Name, 'standard', region, currency)
          })
          .catch(e => {
            console.log('Error : ' + e)
          })
      },
      getVmOptimizerOptions(index, vmsize, tier, region, currency) {
        var vmchooserurl = config.apiCalcVmOptimizations + '?vmsize=' + vmsize + '&tier=' + tier + '&region=' + region + '&currency=' + currency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': config.apiKey
          }
        }
        this.summaryOptimizerCountTotal = this.summaryOptimizerCountTotal + 1
        http.post(vmchooserurl, '', vmchooserconfig)
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
            // console.log(response.data)
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('contract_vmsize', vmsize)
            rowNode.setDataValue('contract_lnx_payg', this.fixNumberFormatting(response.data.Price_Linux_PAYG))
            rowNode.setDataValue('contract_lnx_ri1y', this.fixNumberFormatting(response.data.Price_Linux_RI1Y))
            rowNode.setDataValue('contract_lnx_ri3y', this.fixNumberFormatting(response.data.Price_Linux_RI3Y))
            rowNode.setDataValue('contract_win_payg', this.fixNumberFormatting(response.data.Price_Windows_PAYG))
            rowNode.setDataValue('contract_win_ri1y', this.fixNumberFormatting(response.data.Price_Windows_RI1Y))
            rowNode.setDataValue('contract_win_ri3y', this.fixNumberFormatting(response.data.Price_Windows_RI3Y))
            var month = 730
            rowNode.setDataValue('contract_lnx_payg_month', this.fixNumberFormatting(response.data.Price_Linux_PAYG * month))
            rowNode.setDataValue('contract_lnx_ri1y_month', this.fixNumberFormatting(response.data.Price_Linux_RI1Y * month))
            rowNode.setDataValue('contract_lnx_ri3y_month', this.fixNumberFormatting(response.data.Price_Linux_RI3Y * month))
            rowNode.setDataValue('contract_win_payg_month', this.fixNumberFormatting(response.data.Price_Windows_PAYG * month))
            rowNode.setDataValue('contract_win_ri1y_month', this.fixNumberFormatting(response.data.Price_Windows_RI1Y * month))
            rowNode.setDataValue('contract_win_ri3y_month', this.fixNumberFormatting(response.data.Price_Windows_RI3Y * month))
            this.summaryOptimizerCountDone = this.summaryOptimizerCountDone + 1
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      pad(num, totalStringSize) {
        let asString = num + ''
        while (asString.length < totalStringSize) asString = '0' + asString
        return asString
      },
      calculateRowCount() {
        if (this.gridOptions.api && this.rowData) {
          let model = this.gridOptions.api.getModel()
          let totalRows = this.rowData.length
          let processedRows = model.getRowCount()
          this.rowCount = processedRows.toLocaleString() + ' / ' + totalRows.toLocaleString()
        }
      },

      onModelUpdated() {
        // console.log('onModelUpdated')
        this.calculateRowCount()
      },

      onReady() {
        // console.log('onReady')
        this.calculateRowCount()
      },

      onRowValueChanged(event) {
        // console.log('onRowValueChanged')
        console.log(event.columnApi.columnController.primaryHeaderRowCount)
        if (event.columnApi.columnController.primaryHeaderRowCount < 7) {
          // console.log(event)
          this.getVmSize(
            event.rowIndex,
            event.data.region,
            event.data.cores,
            event.data.memory,
            event.data.ssd,
            event.data.nics,
            event.data.maxdatadisksize,
            event.data.iops,
            event.data.throughput,
            event.data.temp,
            event.data.peakcpu,
            event.data.peakmemory,
            event.data.currency,
            event.data.contract,
            event.data.burstable,
            event.data.os,
            event.data.saphana,
            event.data.saps2t,
            event.data.saps3t,
            event.data.sisla,
            event.data.overridedisktype,
            event.data.osdisk,
            event.data.gpu,
            event.data.infiniband,
            event.data.retentionpoints,
            event.data.churn,
            event.data.compression,
            event.data.resiliency,
            event.data.acu,
            event.data.dbu
          )
          // console.log(event)
          // console.log(event.data.region)
          // console.log(event.data.cores)
          // console.log(event.data.memory)
          // console.log(event.data.ssd)
          // console.log(event.rowIndex)
        }
      },

      // taking out, as when we 'select all', it prints to much to the console!!
      onRowSelected(event) {
        //                console.log('onRowSelected: ' + event.node.data.name);
      },

      onSelectionChanged() {
        // console.log('selectionChanged')
      },

      onBeforeFilterChanged() {
        // console.log('beforeFilterChanged')
      },

      onAfterFilterChanged() {
        // console.log('afterFilterChanged')
      },

      onFilterModified() {
        // console.log('onFilterModified')
      },

      onBeforeSortChanged() {
        // console.log('onBeforeSortChanged')
      },

      onAfterSortChanged() {
        // console.log('onAfterSortChanged')
      },

      onVirtualRowRemoved(event) {
        // because this event gets fired LOTS of times, we don't print it to the
        // console. if you want to see it, just uncomment out this line
        // console.log('onVirtualRowRemoved: ' + event.rowIndex);
      },

      onRowClicked(event) {
        // console.log('onRowClicked: ' + event.node.data.name)
      },

      onQuickFilterChanged(event) {
        this.gridOptions.api.setQuickFilter(event.target.value)
      },

      // here we use one generic event to handle all the column type events.
      // the method just prints the event name
      onColumnEvent(event) {
        // console.log('onColumnEvent: ' + event)
      }
    },
    beforeMount() {
      this.reset()
      this.gridOptions = {
        editType: 'fullRow'
      }
      // this.gridOptions.dateComponentFramework = DateComponent
      this.createRowData()
      this.createColumnDefs()
      this.showGrid = true
    },
    mounted() {
      this.$appInsights.trackPageView('BulkUploader')
      this.getAzureRegions()
    }
  }

  function countryCellRenderer(params) {
    let flag = "<img border='0' width='15' height='10' style='margin-bottom: 2px' src='https://flags.fmcdn.net/data/flags/mini/" + COUNTRY_CODES[params.value] + ".png'>"
    return flag + ' ' + params.value
  }

</script>
<style>

  label {
    font-weight: normal !important;
  }

  .div-percent-bar {
    display: inline-block;
    height: 100%;
    position: relative;
    z-index: 0;
  }

  .div-percent-value {
    position: absolute;
    padding-left: 4px;
    font-weight: bold;
    font-size: 13px;
    z-index: 100;
  }

  .div-outer-div {
    display: inline-block;
    height: 100%;
    width: 100%;
  }

  .ag-menu {
    z-index: 200;
  }
</style>

<!-- SASS styling -->
<style lang="scss" >
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
