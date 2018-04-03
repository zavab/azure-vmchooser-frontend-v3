<template>
  <ul class="sidebar-menu">
    <li class="header">Tools</li>
    <router-link tag="li" class="pageLink" to="/vmchooser">
      <a>
        <i class="fa fa-desktop"></i>
        <span class="page">VM T-Shirt Sizes Finder</span>
      </a>
    </router-link>
    <router-link tag="li" class="pageLink" to="/diskchooser">
      <a>
        <i class="fa fa-database"></i>
        <span class="page">Data Disk Configuration</span>
      </a>
    </router-link>
  </ul>
</template>
<script>
export default {
  name: 'SidebarMenu'
}
</script>
<style>
  /* override default */
  .sidebar-menu>li>a {
    padding: 12px 15px 12px 15px;
  }

  .sidebar-menu li.active>a>.fa-angle-left, .sidebar-menu li.active>a>.pull-right-container>.fa-angle-left {
    animation-name: rotate;
    animation-duration: .2s;
    animation-fill-mode: forwards;
  }

  @keyframes rotate {
    0% {
      transform: rotate(0deg);
    }

    100% {
      transform: rotate(-90deg);
    }
  }
</style>
