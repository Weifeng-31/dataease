<template>
  <div :class="{'has-logo':showLogo}" :style="{'--active-bg': activeBg, '--theme':$store.state.settings.theme , '--left-menu-hovor': variables.leftMenuHovor}">
    <logo v-if="showLogo" :collapse="isCollapse" />
    <el-menu
      :default-active="activeMenu"
      :collapse="isCollapse"
      :unique-opened="false"
      :collapse-transition="false"
      mode="vertical"
    >
      <sidebar-item v-for="route in routes" :key="route.path" :item="route" :base-path="route.path" />
    </el-menu>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/styles/variables.scss'
import { getThemeCluster } from '@/utils/style'
export default {
  components: { SidebarItem, Logo },

  computed: {

    ...mapGetters([
      'sidebar'
    ]),
    routes() {
      // return this.$router.options.routes
      return this.$store.state.permission.currentRoutes.children
    },
    activeMenu() {
      const route = this.$route
      const { meta, path } = route
      // if set path, the sidebar will highlight the path you set
      if (meta.activeMenu) {
        return meta.activeMenu
      }
      return path
    },
    showLogo() {
      return this.$store.state.settings.sidebarLogo
    },
    variables() {
      return variables
    },
    isCollapse() {
      return false
    },
    activeBg() {
      const theme = this.$store.state.settings.theme
      const styleCluster = getThemeCluster(theme.replace('#', ''))
      if (styleCluster.length > 2) {
        const len = styleCluster.length
        const val = styleCluster[len - 2]
        return val
      }
      return ''
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar-container {
    >>>li.el-menu-item.is-active {
        background-color: var(--active-bg) !important;
    }
    >>>li.el-submenu.is-active:not(&:hover){
         background-color: var(--active-bg) ;
    }

    >>>li.el-submenu__title {
      &:hover {
        background-color: var(--left-menu-hovor) !important;
      }
    }

    >>>.el-submenu.is-active .el-submenu__title {
      color: var(--theme) !important;
    }

    .is-active > .el-submenu__title {
      color: var(--theme) !important;
    }
}
</style>
