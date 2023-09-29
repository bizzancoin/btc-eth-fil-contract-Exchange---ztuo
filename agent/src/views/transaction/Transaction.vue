<template>
  <div>
    <!-- 面包屑导航 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>交易一览</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 搜索筛选 -->
    <el-form :inline="true" :model="filterSearch" class="user-search">
      <el-form-item>
        <el-input size="small" style="width:120px;" v-model="filterSearch.memberId" placeholder="请输入会员ID"></el-input>
      </el-form-item>
      <el-form-item>
        <el-input size="small" style="width:120px;" v-model="filterSearch.minMoney" placeholder="最低交易金额"></el-input>
      </el-form-item>

      <el-form-item>
        <el-input size="small" style="width:120px;" v-model="filterSearch.maxMoney" placeholder="最高交易金额"></el-input>
      </el-form-item>

      <el-form-item>
        <el-input size="small" style="width:100px;" v-model="filterSearch.minFee" placeholder="最低手续费"></el-input>
      </el-form-item>

      <el-form-item>
        <el-input size="small" style="width:100px;" v-model="filterSearch.maxFee" placeholder="最高手续费"></el-input>
      </el-form-item>

      <el-form-item>
          <el-date-picker
            v-model="dateRange"
            size="small"
            type="daterange"
            format="yyyy-MM-dd"
            value-format="yyyy-MM-dd"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期" style="width:240px;">
          </el-date-picker>
      </el-form-item>
      <el-form-item label="交易类型：">
        <el-select size="small" v-model="filterSearch.type" placeholder="请选择" style="width:100px;">
          <el-option v-for="(item, index) in tradeTypeArr" :label="item" :value="index" :key="index"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="币种：">
        <el-select size="small" v-model="filterSearch.symbol" placeholder="请选择" style="width:100px;">
          <el-option v-for="item in coinUnitArr" :label="item.unit" :value="item.unit=='全部'?'': item.unit" :key="item.unit"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button size="small" type="primary" icon="el-icon-search" @click="search">搜索</el-button>
      </el-form-item>
      <el-form-item>
        <el-button size="small" type="info" icon="el-icon-search" @click="clearSearch">清空</el-button>
      </el-form-item>
    </el-form>
    <!--列表-->
    <el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" style="width: 100%;">
        <el-table-column align="center" type="index" width="60"></el-table-column>
        <el-table-column prop="memberId"   label="会员ID" show-overflow-tooltip></el-table-column>
        <el-table-column prop="type" label="交易类型" align="center" >
          <template slot-scope="scope">
            {{scope.row.type | tradeTypeParse}}
          </template>
      </el-table-column>
        <el-table-column prop="amount"       label="交易金额" show-overflow-tooltip></el-table-column>
        <el-table-column prop="symbol"       label="交易币种" show-overflow-tooltip></el-table-column>
        <el-table-column prop="fee"    label="交易手续费" show-overflow-tooltip></el-table-column>
        <el-table-column label="交易时间">
            <template slot-scope="scope">
                  <div>{{scope.row.createTime|timestampToTime}}</div>
            </template>
        </el-table-column>
    </el-table>
    <!-- 分页组件 -->
    <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
  </div>
</template>

<script>
import { getTransactionList, getCoinList } from '../../api/api'
import Pagination from '../../components/Pagination'
export default {
  data() {
    return {
      loading: false, //是显示加载
      editFormVisible: false, //控制编辑页面显示与隐藏
      title: '预览',
      tradeTypeArr: [ '充值', '提现', '转账', '币币交易', '法币买入', '法币卖出', '活动奖励', '推广奖励', '分红', '投票', '人工充值', '配对',
              "活动兑换", "C2C买入", "C2C卖出", "红包发出", "红包领取",
			  "提现码提现","提现码充值","永续合约手续费","永续合约盈利","永续合约亏损","预测合约失败","预测合约手续费","预测合约奖金","合约返佣","平级奖励","平台手续费收入"],
      listData: [], //用户数据
      pageNo: 1,
      pageSize: 15,
      filterSearch: {
        memberId: '',
        minMoney: "",
        maxMoney: "",
        minFee: "",
        maxFee: "",
        startTime: "",
        endTime: "",
        symbol: ""
      },
      coinUnitArr: [
      ],
      dateRange: "",
      // 分页参数
      pageparm: {
        currentPage: 1,
        pageSize: 15,
        total: 10
      }
    }
  },
  components: {
    Pagination
  },
  created() {
    this.getcoin();
    let params = {
      pageNo: 1,
      pageSize: this.pageSize,
      property: 'createTime',
      direction: 1
    };
    this.getdata(params);
  },
  filters: {
    tradeTypeParse: function(value){
      let typeArr = [ '充值', '提现', '转账', '币币交易', '法币买入', '法币卖出', '活动奖励', '推广奖励', '分红', '投票', '人工充值', '配对', "活动兑换", "C2C买入", "C2C卖出", "红包发出", "红包领取","提现码提现","提现码充值","永续合约手续费","永续合约盈利","永续合约亏损","预测合约失败","预测合约手续费","预测合约奖金","合约返佣","平级奖励","平台手续费收入" ];
      return typeArr[value];
    }
  },
  methods: {
    getcoin(){
      getCoinList(null).then(res => {
        if(res.code == 0) {
          this.coinUnitArr = res.data;
        }else{
          this.$message.error(res.message);
        }
      });
    },
    clearSearch(){
      this.filterSearch = {
        memberId: '',
        minMoney: "",
        maxMoney: "",
        minFee: "",
        maxFee: "",
        startTime: "",
        endTime: "",
        symbol: ""
      };
    },
    getdata(params) {
      this.loading = true

      getTransactionList(params).then(res => {
        if(res.code == 0) {
          this.listData = res.data.content;
          this.pageparm.currentPage = this.pageNo;
          this.pageparm.pageSize = this.pageSize;
          this.pageparm.total = res.data.totalElements;
        }else{
          this.$message.error(res.message);
        }
        this.loading = false;
      });
    },
    // 分页插件事件
    callFather(parm) {
      this.pageNo = parm.currentPage;
      this.pageSize = parm.pageSize;
      let obj =Object.assign({ pageNo: this.pageNo, pageSize: this.pageSize}, this.filterSearch);
      this.getdata(obj);
    },
    // 搜索事件
    search() {
      let reg = /\D/;
      if(reg.test(this.filterSearch.memberId)) {
        this.$message.warning('请输入正确的会员ID!');
        return;
      }
      if(this.dateRange.length > 0){
        this.filterSearch.startTime = this.dateRange[0] + " 00:00:00";
        this.filterSearch.endTime = this.dateRange[1] + " 00:00:00";
      }
      this.pageNo = 1;
      let obj =Object.assign({ pageNo: this.pageNo, pageSize: this.pageSize, property: 'createTime', direction: 1}, this.filterSearch);
      this.getdata(obj);
    }
  }
}
</script>

<style scoped>
.user-search {
  margin-top: 20px;
}
.userRole {
  width: 100%;
}
</style>

 
 

 