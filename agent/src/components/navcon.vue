
<template>
  <el-menu class="el-menu-demo" mode="horizontal" background-color="#172636" text-color="#fff" active-text-color="#fff">
    <el-button class="buttonimg">
      <img class="showimg" :src="collapsed?imgsq:imgshow" @click="toggle(collapsed)">
    </el-button>
    <el-submenu index="5" class="submenu">
      <!-- <template slot="title">{{user.userRealName}}</template> -->
      <template slot="title">超级代理商（{{user.username}}）</template>
      <el-menu-item @click="exit()" index="5-2">退出</el-menu-item>
    </el-submenu>
  </el-menu>
</template>
<script>
import { loginout } from '../api/api'
export default {
  name: 'navcon',
  data() {
    return {
      collapsed: true,
      imgshow: require('../assets/img/show.png'),
      imgsq: require('../assets/img/sq.png'),
      user: {}
    }
  },
  // 创建完毕状态(里面是操作)
  created() {
    this.user = JSON.parse(localStorage.getItem('MEMBER'))
  },
  methods: {
    // 退出登录
    exit() {
      this.$confirm('退出登录, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
          loginout().then(res => {
              if (res.code == 0) {
                //如果请求成功就让他2秒跳转路由
                setTimeout(() => {
                  this.$store.commit('logout', 'false');
                  this.$store.commit("setMember", null);
                  this.$router.push({ path: '/login' });
                  this.$message({
                    type: 'success',
                    message: '已退出登录!'
                  })
                }, 1000)
              } else {
                this.$message.error(res.msg)
                this.logining = false
                return false
              }
            }).catch(err => {
              this.logining = false;
              this.$store.commit('logout', 'false');
              this.$store.commit("setMember", null);
              this.$router.push({ path: '/login' });
            });
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消'
          })
        })
    },
    // 切换显示
    toggle(showtype) {
      this.collapsed = !showtype
      this.$root.Bus.$emit('toggle', this.collapsed)
    }
  }
}
</script>
<style scoped>
.el-menu-vertical-demo:not(.el-menu--collapse) {
  border: none;
}
.submenu {
  float: right;
}
.buttonimg {
  height: 60px;
  background-color: transparent;
  border: none;
}
.showimg {
  width: 26px;
  height: 26px;
  position: absolute;
  top: 17px;
  left: 17px;
}
.showimg:active {
  border: none;
}
</style>