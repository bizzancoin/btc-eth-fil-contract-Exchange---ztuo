import axios from 'axios';
import { loginreq, req } from './axiosFun';

// ======================通用接口=======================

// 登录接口
export const login = (params) => { return loginreq("post", "/agent/login", params) };

// 退出接口
export const loginout = () => { return req("post", "/agent/loginout").then(res => res.data) };

// 获取邀请用户列表
export const getMemberList = (params) => { return req("post", "/agent/member/page-query", params) };

// 获取充值列表
export const getDepositList = (params) => { return req("post", "/agent/deposit/page-query", params) };

// 获取充值列表
export const getWithdrawList = (params) => { return req("post", "/agent/withdraw/page-query", params) };

// 获取支持币种列表
export const getCoinList = (params) => { return req("post", "/agent/coin/all-name-and-unit", params) };

// 获取充值列表
export const getTransactionList = (params) => { return req("post", "/agent/transactions/page-query", params) };

// 获取交易返佣列表
export const getTransactionRebateList = (params) => { return req("post", "/agent/transactionRebates/page-query", params) };

// 获取充值列表
export const getMemberAssetsList = (params) => { return req("post", "/agent/member/assets-list", params) };

//查询推荐比例
export const getTransactionRebateSet = (params) => { return req("post", "/agent/transactionRebateSet/query", params) };
//清除比例缓存
export const clearTransactionRebateSet = (params) => { return req("post", "/agent/transactionRebateSet/clear", params) };
//设置比例
export const transactionRebateSet = (params) => { return req("post", "/agent/transactionRebateSet/set", params) };
//实名认证
export const memberRealNameList = (params) =>{ return req("post","/agent/member/member-application/page-query", params)};
//POST获取 "会员实名审核详情页"
export const memberRealNameDetail = (params) =>{ return req("post",'/agent/member/member-application/detail', params)};

//POST获取 "会员实名审核通过"
export const memberCheckPass = (params) =>{ return req("patch",`/agent/member/member-application/${params}/pass`)};

//POST获取 "会员实名审核不通过"
export const memberCheckNotPass = (params) =>{ return req("patch",`/agent/member/member-application/${params}/no-pass` )};

//POST获取 "永续合约"=>"委托管理"=>"查询委托"
export const queryEntrustList = (params) =>{ return req("post",'/agent/swap/order/page-query', params)};
//POST获取 "永续合约"=>"交易对管理"=>"获取交易对列表"
export const queryContractCoinList = (params) =>{ return req("post",'/agent/swap/order/coin/page-query', params)};
//POST获取 "永续合约"=>"委托管理"=>"撤销委托"
export const cancelEntrustOrder = (params) =>{ return req("post",'/agent/swap/order/cancel', params)};
