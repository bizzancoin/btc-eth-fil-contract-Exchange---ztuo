import axios from 'axios';

const URL_ROOT = "https://api.pepsicoin.xyz";

// 登录请求方法
const loginreq = (method, url, params) => {
    return axios({
        method: method,
        url: URL_ROOT + url,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: params,
        traditional: true,
        transformRequest: [
            function(data) {
                let ret = ''
                for (let it in data) {
                    ret +=
                        encodeURIComponent(it) +
                        '=' +
                        encodeURIComponent(data[it]) +
                        '&'
                }
                return ret
            }
        ]
    }).then(res => res.data);
};
// 通用公用方法
const req = (method, url, params) => {
    return axios({
        method: method,
        url: URL_ROOT + url,
        headers: {
            'x-auth-token': localStorage.getItem('TOKEN')
        },
        data: params,
        traditional: true,
        transformRequest: [
            function(data) {
                let ret = ''
                for (let it in data) {
                    ret +=
                        encodeURIComponent(it) +
                        '=' +
                        encodeURIComponent(data[it]) +
                        '&'
                }
                return ret
            }
        ]
    }).then(res => res.data);
};

export {
    loginreq,
    req
}