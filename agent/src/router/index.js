// 导入组件
import Vue from 'vue';
import Router from 'vue-router';
// 登录
import login from '@/views/login';

// 登录
import index from '@/views/index';

// 数据概览
import statistics from '@/views/charts/statistics';

// 用户一览
import User from '@/views/user/User';
// 实名
import Authenticate from '@/views/user/Authenticate';

// 充值一览
import Recharge from '@/views/recharge/Recharge';

// 提现一览
import Withdraw from '@/views/withdraw/Withdraw';

// 交易一览
import Transaction from '@/views/transaction/Transaction';
import EntrustOrder from '@/views/transaction/EntrustOrder';

// 交易返佣一览
import TransactionRebate from '@/views/transactionRebate/TransactionRebate';

// 系统
import Settings from '@/views/settings/Settings';

// 交易返佣设置
import TransactionRebateSet from '@/views/transactionRebate/TransactionRebateSet';

// 启用路由
Vue.use(Router);

// 导出路由
export default new Router({
    routes: [{
        path: '/',
        name: '',
        component: login,
        hidden: true,
        meta: {
            requireAuth: false
        }
    }, {
        path: '/login',
        name: '登录',
        component: login,
        hidden: true,
        meta: {
            requireAuth: false
        }
    }, {
        path: '/index',
        name: '首页',
        component: index,
        iconCls: 'el-icon-tickets',
        children: [{
            path: '/charts/statistics',
            name: '数据概况',
            component: statistics,
            meta: {
                requireAuth: true
            }
        }, {
            path: '/user/User',
            name: '用户一览',
            component: User,
            meta: {
                requireAuth: true
            }
        }, {
          path: '/user/Authenticate',
          name: '实名认证',
          component: Authenticate,
          meta: {
            requireAuth: true
          }
        }, {
            path: '/recharge/Recharge',
            name: '充值一览',
            component: Recharge,
            meta: {
                requireAuth: true
            }
        }, {
            path: '/withdraw/Withdraw',
            name: '提现一览',
            component: Withdraw,
            meta: {
                requireAuth: true
            }
        }, {
            path: '/transaction/Transaction',
            name: '交易流水',
            component: Transaction,
            meta: {
                requireAuth: true
            }
        }, {
          path: '/transaction/EntrustOrder',
          name: '委托管理',
          component: EntrustOrder,
          meta: {
            requireAuth: true
          }
        }, {
          path: '/transactionRebate/TransactionRebate',
          name: '交易返佣',
          component: TransactionRebate,
          meta: {
            requireAuth: true
          }
        },{
          path: '/transactionRebate/TransactionRebateSet',
          name: '交易返佣设置',
          component: TransactionRebateSet,
          meta: {
            requireAuth: true
          }
        },{
            path: '/settings/Settings',
            name: '系统设置',
            component: Settings,
            meta: {
                requireAuth: true
            }
        }]
    }]
})
