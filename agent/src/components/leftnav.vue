<template>
  <el-menu default-active="2" :collapse="collapsed" collapse-transition router :default-active="$route.path" class="el-menu-vertical-demo" background-color="#172636" text-color="#fff" active-text-color="#ffd04b">
    <div class="logobox">
      <img class="logoimg" src="../assets/img/logo.png" alt="">
    </div>
    <el-submenu v-for="menu in allmenu" :key="menu.menuid" :index="menu.menuname">
      <template slot="title">
        <i :class="menu.icon"></i>
        <span>{{menu.menuname}}</span>
      </template>
      <el-menu-item-group>
        <el-menu-item v-for="chmenu in menu.menus" :index="'/'+chmenu.url" :key="chmenu.menuid">
          <i :class="chmenu.icon"></i>
          <span>{{chmenu.menuname}}</span>
        </el-menu-item>
      </el-menu-item-group>
    </el-submenu>
  </el-menu>
</template>
<script>
import { menu } from '../api/api'
export default {
  name: 'leftnav',
  data() {
    return {
      collapsed: false,
      allmenu: []
    }
  },

  created() {
    let res = {
      success: true,
      data: [
        // {
        //   menuid: 1,
        //   icon: 'el-icon-s-data',
        //   menuname: '数据概况',
        //   hasThird: null,
        //   url: null,
        //   menus: [
        //     {
        //       menuid: 2,
        //       icon: 'el-icon-s-data',
        //       menuname: '数据概况',
        //       hasThird: 'N',
        //       url: 'charts/statistics',
        //       menus: null
        //     }
        //   ]
        // },
        {
          menuid: 33,
          icon: 'el-icon-user-solid',
          menuname: '用户管理',
          hasThird: null,
          url: null,
          menus: [
            {
              menuid: 34,
              icon: 'el-icon-s-custom',
              menuname: '用户一览',
              hasThird: 'N',
              url: 'user/User',
              menus: null
            },
            {
              menuid: 120,
              icon: 'el-icon-s-custom',
              menuname: '实名认证',
              hasThird: 'N',
              url: 'user/Authenticate',
              menus: null
            }
          ]
        },
        {
          menuid: 71,
          icon: 'el-icon-coin',
          menuname: '充提流水',
          hasThird: null,
          url: null,
          menus: [
            {
              menuid: 72,
              icon: 'el-icon-sold-out',
              menuname: '充值一览',
              hasThird: 'N',
              url: 'recharge/Recharge',
              menus: null
            },
            {
              menuid: 174,
              icon: 'el-icon-sell',
              menuname: '提现一览',
              hasThird: 'N',
              url: 'withdraw/Withdraw',
              menus: null
            }
          ]
        },
        {
          menuid: 128,
          icon: 'el-icon-finished',
          menuname: '资金流水',
          hasThird: null,
          url: null,
          menus: [
            {
              menuid: 129,
              icon: 'el-icon-document',
              menuname: '资金流水',
              hasThird: 'N',
              url: 'transaction/Transaction',
              menus: null
            },
            {
              menuid: 160,
              icon: 'el-icon-document',
              menuname: '委托一览',
              hasThird: 'N',
              url: 'transaction/EntrustOrder',
              menus: null
            }
          ]
        },
        {
            menuid: 130,
            icon: 'el-icon-finished',
            menuname: '合约交易返佣',
            hasThird: null,
            url: null,
            menus: [
                {
                    menuid: 131,
                    icon: 'el-icon-document',
                    menuname: '返佣一览',
                    hasThird: 'N',
                    url: 'transactionRebate/TransactionRebate',
                    menus: null
                },
				{
				    menuid: 132,
				    icon: 'el-icon-document',
				    menuname: '返佣设置',
				    hasThird: 'N',
				    url: 'transactionRebate/TransactionRebateSet',
				    menus: null
				}
            ]
        },
        // {
        //   menuid: 150,
        //   icon: 'el-icon-setting',
        //   menuname: '设置',
        //   hasThird: null,
        //   url: null,
        //   menus: [
        //     {
        //       menuid: 159,
        //       icon: 'el-icon-user',
        //       menuname: '我的账户',
        //       hasThird: 'N',
        //       url: 'settings/Settings',
        //       menus: null
        //     }
        //   ]
        // }
      ],
      msg: 'success'
    }
          this.allmenu = res.data

    // menu(localStorage.getItem('logintoken'))
    //   .then(res => {
    //     console.log(JSON.stringify(res))
    //     if (res.success) {
    //       this.allmenu = res.data
    //     } else {
    //       this.$message.error(res.msg)
    //       return false
    //     }
    //   })
    //   .catch(err => {
    //     this.$message.error('菜单加载失败，请稍后再试！')
    //   })
    // 监听
    this.$root.Bus.$on('toggle', value => {
      this.collapsed = !value
    })
  }
}
</script>
<style>
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 200px;
  min-height: 400px;
}
.el-menu-vertical-demo:not(.el-menu--collapse) {
  border: none;
  text-align: left;
}
.el-menu-item-group__title {
  padding: 0px;
}
.el-menu-bg {
  background-color: #1f2d3d !important;
}
.el-menu {
  border: none;
}
.logobox {
  height: 40px;
  line-height: 40px;
  color: #9d9d9d;
  font-size: 20px;
  text-align: center;
  padding: 10px 0px;
}
.logoimg {
  height: 40px;
}
</style>
