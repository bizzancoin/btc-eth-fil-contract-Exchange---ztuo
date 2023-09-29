// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
// 引入element UI
import ElementUI from 'element-ui';

import 'element-ui/lib/theme-chalk/index.css';

import fullscreen from 'vue-fullscreen'

import App from './App';
// 引入路由
import router from './router';
// 引入状态管理
import store from './vuex/store';
// 引入icon
import './assets/icon/iconfont.css'
// 
import vueResource from 'vue-resource';

// 引入echarts
import echarts from 'echarts'
Vue.prototype.$echarts = echarts

import axios from 'axios';

Vue.prototype.$axios = axios;

Vue.config.productionTip = false;

// 使用element UI
Vue.use(ElementUI);
Vue.use(vueResource);
Vue.use(fullscreen);

// 过滤器
import * as custom from './utils/util'

Object.keys(custom).forEach(key => {
    Vue.filter(key, custom[key])
});

axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

// 请求拦截
axios.interceptors.request.use(function (config) {
    let xToken = localStorage.getItem('TOKEN');
    if(xToken) config.headers.common['x-auth-token'] = localStorage.getItem('TOKEN');

    return config;
}, function (error) {
    return Promise.reject(error);
});

//响应拦截
axios.interceptors.response.use(function (response) {
    // var xToken = response.headers.get('x-auth-token');
    // if (xToken != null && xToken != '') {
    //     localStorage.setItem('TOKEN', xToken);
    // }
    if (response.data.code == '4000' || response.data.code == '3000') {
        store.commit('setMember', null);
        router.push('/login');
        return false;
    }
    return response;
}, function (error) {
    return Promise.reject(error);
});

Vue.http.options.credentials = true;
Vue.http.options.emulateJSON = true;
Vue.http.options.headers = {
    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    'Content-Type': 'application/json;charset=utf-8'
};

new Vue({
    el: '#app',
    router,
    store,
    components: { App },
    template: '<App/>',
    data: {
        Bus: new Vue()
    }
})