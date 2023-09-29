<template>
  <div>
    <!-- 面包屑导航 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>充值一览</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 搜索筛选 -->
    <el-form :inline="true" :model="filterSearch" class="user-search">
      <el-form-item>
        <el-input size="small" style="width:300px;" v-model="filterSearch.address" placeholder="请输入充币地址"></el-input>
      </el-form-item>

      <el-form-item label="充值币种：">
        <el-select size="small" v-model="filterSearch.unit" placeholder="请选择">
          <el-option v-for="item in coinUnitArr" :label="item.unit" :value="item.unit=='全部'?'': item.unit" :key="item.unit"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="充值时间：">
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
        <el-table-column prop="username"   label="会员昵称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="unit"       label="充币币种" show-overflow-tooltip></el-table-column>
        <el-table-column prop="address"    label="充币地址" show-overflow-tooltip></el-table-column>
        <el-table-column prop="amount"     label="充币数量" show-overflow-tooltip></el-table-column>
        <el-table-column label="到账时间">
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
import { getDepositList, getCoinList } from '../../api/api'
import Pagination from '../../components/Pagination'
export default {
  data() {
    return {
      loading: false, //是显示加载
      editFormVisible: false, //控制编辑页面显示与隐藏
      title: '预览',
      dateRange: "",
      coinUnitArr: [
      ],
      listData: [], //用户数据
      pageNo: 1,
      pageSize: 10,
      filterSearch: {
        address: '',
        unit: ''
      },
      // 分页参数
      pageparm: {
        currentPage: 1,
        pageSize: 10,
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
        address: '',
        unit: ''
      };
    },
    getdata(params) {
      this.loading = true

      getDepositList(params).then(res => {
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
      let obj =Object.assign({ pageNo: this.pageNo, pageSize: this.pageSize, property: 'createTime', direction: 1 }, this.filterSearch);
      this.getdata(obj);
    },
    // 搜索事件
    search() {
      this.getdata(this.filterSearch)
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

 
 

 