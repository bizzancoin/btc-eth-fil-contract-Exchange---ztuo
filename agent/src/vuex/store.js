import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);
// 登录验证
export default new Vuex.Store({
    state: {
        member: null
    },
    mutations: {
        // 登录
        login(state, member) {
            state.member = member;
            localStorage.setItem("MEMBER", JSON.stringify(member));
        },
        // 退出
        logout(state, member) {
            state.member = null;
            localStorage.setItem("MEMBER", "");
        },
        setMember(state, member) {
            state.member = member;
            localStorage.setItem('MEMBER', JSON.stringify(member));
        },
        recoveryMember(state) {
            state.member = JSON.parse(localStorage.getItem('MEMBER'));
        }
    },
    getters: {
        member(state) {
            return state.member;
        },
        isLogin(state) {
            return state.member != null;
        }
    }
})