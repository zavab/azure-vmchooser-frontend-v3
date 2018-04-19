import DashView from './components/Dash.vue'
import NotFoundView from './components/404.vue'

// Import Views - Dash
import DashboardView from './components/views/Dashboard.vue'
import VmChooserView from './components/views/VmChooser.vue'
import DiskChooserView from './components/views/DiskChooser.vue'
import BulkUploaderView from './components/views/BulkUploader.vue'

// Routes
const routes = [
  {
    path: '/',
    component: DashView,
    children: [
      {
        path: 'dashboard',
        alias: '',
        component: DashboardView,
        name: 'Dashboard',
        meta: {description: '"Where do you want to go today?"'}
      }, {
        path: 'vmchooser',
        component: VmChooserView,
        name: 'VmChooser',
        meta: { description: 'Let VmChooser find the best t-shirt size match for you!' }
      }, {
        path: 'diskchooser',
        component: DiskChooserView,
        name: 'DiskChooser',
        meta: { description: 'Let DiskChooser find the most efficient disk configuration/layout for you!' }
      }, {
        path: 'bulkuploader',
        component: BulkUploaderView,
        name: 'BulkUploader',
        meta: { description: 'When finding one VM is not enough...' }
      }
    ]
  }, {
    // not found handler
    path: '*',
    component: NotFoundView
  }
]

export default routes
