<template>
  <div style="width: 100%;">
    <div style="padding: 4px;">
      <div style="float: right;">
        <input @keyup="onQuickFilterChanged" type="text" id="quickFilterInput"
               placeholder="Type text to filter..." />
        <button @click="exportToCsv">Export to CSV</button>
      </div>
      <div>
        <b>Virtual Machines</b>
        {{rowCount}}
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
                   :toolPanelSuppressGroups="true"
                   :toolPanelSuppressValues="true"
                   rowSelection="multiple"
                   :modelUpdated="onModelUpdated"
                   :cellClicked="onCellClicked"
                   :cellDoubleClicked="onCellDoubleClicked"
                   :cellContextMenu="onCellContextMenu"
                   :cellValueChanged="onCellValueChanged"
                   :rowValueChanged="onRowValueChanged"
                   :cellFocused="onCellFocused"
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
  </div>
</template>
<script>
  import { AgGridVue } from 'ag-grid-vue'
  import Papa from 'papaparse'
  import axios from 'axios'

  import '../../../node_modules/ag-grid/dist/styles/ag-grid.css'
  import '../../../node_modules/ag-grid/dist/styles/ag-theme-balham.css'

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

  export default {
    data() {
      return {
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
      exportToCsv() {
        this.gridOptions.api.exportDataAsCsv()
      },
      filesChange(fieldName, fileList) {
        const that = this
        if (!fileList.length) return
        for (var i = 0; i < fileList.length; i++) {
          // console.log(fileList[i])
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
      },
      updateRowData(newResults) {
        var tempData = []
        for (var i = 0; i < newResults.data.length; i++) {
          var tempRow = newResults.data[i]
          if (tempRow['VM Name']) {
            this.getVmSize(
              i,
              tempRow['Region'],
              tempRow['Cores'],
              tempRow['Memory (GB)'],
              tempRow['SSD [Yes/No]'],
              tempRow['NICs'],
              tempRow['Max Disk Size (TB)'],
              tempRow['IOPS'],
              tempRow['Throughput (MB/s)'],
              tempRow['Min Temp Disk Size (GB)'],
              tempRow['Peak CPU Usage (%)'],
              tempRow['Peak Memory Usage (%)'],
              tempRow['Currency'],
              tempRow['Contract'],
              tempRow['Burstable']
            )
            tempData.push({
              name: tempRow['VM Name'],
              region: tempRow['Region'],
              cores: tempRow['Cores'],
              memory: tempRow['Memory (GB)'],
              contract: tempRow['Contract'],
              currency: tempRow['Currency'],
              ssd: tempRow['SSD [Yes/No]'],
              nics: tempRow['NICs'],
              maxdatadisksize: tempRow['Max Disk Size (TB)'] * 1024,
              temp: tempRow['Min Temp Disk Size (GB)'],
              iops: tempRow['IOPS'],
              throughput: tempRow['Throughput (MB/s)'],
              peakcpu: tempRow['Peak CPU Usage (%)'],
              peakmemory: tempRow['Peak Memory Usage (%)'],
              burstable: tempRow['Burstable']
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
            suppressSorting: true,
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
                width: 100,
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'SSD',
                field: 'ssd',
                width: 50,
                editable: true
              },
              {
                headerName: 'NICs',
                field: 'nics',
                width: 50,
                columnGroupShow: 'open',
                editable: true,
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Max. Data Disks Capacity (in GB)',
                field: 'maxdatadisksize',
                width: 150,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. IOPS',
                field: 'iops',
                width: 150,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. Throughput (MB/s)',
                field: 'throughput',
                width: 150,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Min. Temp disk (GB)',
                field: 'temp',
                width: 150,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Peak CPU in 95pct (%)',
                field: 'peakcpu',
                width: 75,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Peak Memory in 95pct (%)',
                field: 'peakmemory',
                width: 75,
                editable: true,
                columnGroupShow: 'open',
                filter: 'agNumberColumnFilter'
              },
              {
                headerName: 'Currency',
                field: 'currency',
                width: 75,
                editable: true
              },
              {
                headerName: 'Contract',
                field: 'contract',
                width: 75,
                editable: true
              },
              {
                headerName: 'Burstable',
                field: 'burstable',
                width: 75,
                columnGroupShow: 'closed',
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
                filter: 'text'
              },
              {
                headerName: 'Price per Hour',
                field: 'compute_price_hour',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Price per Day',
                field: 'compute_price_day',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Price per Month (730 hours)',
                field: 'compute_price_month',
                width: 150,
                filter: 'text'
              },
              {
                headerName: 'Cores',
                field: 'compute_cores',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Memory (GB)',
                field: 'compute_memory',
                width: 100,
                filter: 'text'
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
                width: 100,
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
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Max. # Data Disks',
                field: 'compute_data_maxdisks',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Max. Data Capacity (GB)',
                field: 'compute_data_maxcapacity',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Max. Data IOPS',
                field: 'compute_data_maxiops',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Max. Data Throughput',
                field: 'compute_data_maxthroughput',
                width: 100,
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
                width: 100,
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
                headerName: 'OS Disk Price (per Month)',
                field: 'storage_os_price',
                width: 100,
                filter: 'text'
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
                headerName: 'Data Disk Size',
                field: 'storage_data_size',
                width: 100,
                filter: 'text'
              },
              {
                headerName: 'Data Disk Price (per Month)',
                field: 'storage_data_price',
                width: 100,
                filter: 'text'
              }
            ]
          }
        ]
      },
      getVmSize(index, region, cores, memory, ssd, nics, capacity, iops, throughput, temp, peakcpu, peakmemory, currency, contract, burstable) {
        var maxresults = '1'
        var vmchooserurl = 'https://vmchooser.azure-api.net/dev-v2/api/GetVmSize?maxresults=' + maxresults + '&cores=' + cores + '&memory=' + memory + '&ssd=' + ssd + '&throughput=' + throughput + '&iops=' + iops + '&data=' + capacity + '&nics=' + nics + '&burstable=' + burstable + '&contract=' + contract + '&avgcpupeak=' + peakcpu + '&avgmempeak=' + peakmemory + '&region=' + region + '&currency=' + currency
        var vmchooserconfig = {
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Ocp-Apim-Subscription-Key': ''
          }
        }
        axios.post(vmchooserurl, '', vmchooserconfig)
          .then(response => {
            // console.log(response.data)
            var rowNode = this.gridOptions.api.getRowNode(index)
            rowNode.setDataValue('compute_name', response.data[0].Name)
            rowNode.setDataValue('compute_price_hour', response.data[0].Price)
            rowNode.setDataValue('compute_price_day', response.data[0].Price * 24)
            rowNode.setDataValue('compute_price_month', response.data[0].Price * 730)
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
          })
          .catch(e => {
            console.log('Error : ' + e)
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
        console.log('onModelUpdated')
        this.calculateRowCount()
      },

      onReady() {
        console.log('onReady')
        this.calculateRowCount()
      },

      onCellClicked(event) {
        console.log('onCellClicked: ' + event.rowIndex + ' ' + event.colDef.field)
      },

      onCellValueChanged(event) {
        console.log('onCellValueChanged: ' + event.oldValue + ' to ' + event.newValue)
      },

      onRowValueChanged(event) {
        console.log('onRowValueChanged')
        console.log(event.columnApi.columnController.primaryHeaderRowCount)
        if (event.columnApi.columnController.primaryHeaderRowCount < 7) {
          console.log(event)
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
            event.data.burstable
          )
          // console.log(event)
          // console.log(event.data.region)
          // console.log(event.data.cores)
          // console.log(event.data.memory)
          // console.log(event.data.ssd)
          // console.log(event.rowIndex)
        }
      },

      onCellDoubleClicked(event) {
        console.log('onCellDoubleClicked: ' + event.rowIndex + ' ' + event.colDef.field)
      },

      onCellContextMenu(event) {
        console.log('onCellContextMenu: ' + event.rowIndex + ' ' + event.colDef.field)
      },

      onCellFocused(event) {
        console.log('onCellFocused: (' + event.rowIndex + ',' + event.colIndex + ')')
      },

      // taking out, as when we 'select all', it prints to much to the console!!
      onRowSelected(event) {
        //                console.log('onRowSelected: ' + event.node.data.name);
      },

      onSelectionChanged() {
        console.log('selectionChanged')
      },

      onBeforeFilterChanged() {
        console.log('beforeFilterChanged')
      },

      onAfterFilterChanged() {
        console.log('afterFilterChanged')
      },

      onFilterModified() {
        console.log('onFilterModified')
      },

      onBeforeSortChanged() {
        console.log('onBeforeSortChanged')
      },

      onAfterSortChanged() {
        console.log('onAfterSortChanged')
      },

      onVirtualRowRemoved(event) {
        // because this event gets fired LOTS of times, we don't print it to the
        // console. if you want to see it, just uncomment out this line
        // console.log('onVirtualRowRemoved: ' + event.rowIndex);
      },

      onRowClicked(event) {
        console.log('onRowClicked: ' + event.node.data.name)
      },

      onQuickFilterChanged(event) {
        this.gridOptions.api.setQuickFilter(event.target.value)
      },

      // here we use one generic event to handle all the column type events.
      // the method just prints the event name
      onColumnEvent(event) {
        console.log('onColumnEvent: ' + event)
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
