<template>
  <div>
    <!-- 面包屑导航 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>用户一览</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 搜索筛选 -->
    <el-form :inline="true" :model="filterSearch" class="user-search">
      <el-form-item>
        <el-input size="small" style="width:300px;" v-model="filterSearch.account" placeholder="请输入用户名、邮箱、手机号、姓名搜索"></el-input>
      </el-form-item>

      <el-form-item label="用户状态：">
        <el-select size="small" v-model="filterSearch.commonStatus" placeholder="请选择">
          <el-option v-for="type in userStatusList" :label="type.key" :value="type.value" :key="type.value"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="注册时间：">
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
	      <el-table-column prop="username"          label="用户名称" show-overflow-tooltip></el-table-column>
	      <el-table-column prop="mobilePhone"       label="手机号码" show-overflow-tooltip></el-table-column>
	      <el-table-column prop="email"             label="邮箱地址" show-overflow-tooltip></el-table-column>
	      <el-table-column prop="superPartner" label="会员等级" align="center" >
		      <template slot-scope="scope">
		        <el-tag v-if="scope.row.superPartner == '0'" type="info">普通用户</el-tag>
		        <el-tag v-if="scope.row.superPartner == '1'" type="success">超级代理商</el-tag>
		      </template>
		  </el-table-column>
		  <el-table-column prop="transactionStatus" label="交易状态" align="center" >
		      <template slot-scope="scope">
		        <el-tag v-if="scope.row.transactionStatus == 0" type="error">禁止交易</el-tag>
		        <el-tag v-if="scope.row.transactionStatus == 1" type="success">可交易</el-tag>
		      </template>
		  </el-table-column>
		  <el-table-column prop="status" label="状态" align="center" >
		      <template slot-scope="scope">
		        <el-tag v-if="scope.row.status == 0" type="success">正常</el-tag>
		        <el-tag v-if="scope.row.status == 1" type="error">禁用</el-tag>
		      </template>
		  </el-table-column>
		  <el-table-column prop="realNameStatus" label="实名状态" align="center" >
		      <template slot-scope="scope">
		        <el-tag v-if="scope.row.realNameStatus == 0" type="info">未认证</el-tag>
		        <el-tag v-if="scope.row.realNameStatus == 1" type="primary">审核中</el-tag>
		        <el-tag v-if="scope.row.realNameStatus == 2" type="success">已认证</el-tag>
		      </template>
		  </el-table-column>
	      <el-table-column prop="realName"    label="真名"   show-overflow-tooltip></el-table-column>
	      <el-table-column label="认证时间">
		        <template slot-scope="scope">
		          	  <div>{{scope.row.applicationTime|timestampToTime}}</div>
		        </template>
	      </el-table-column>
	      <el-table-column label="注册时间">
		        <template slot-scope="scope">
		          	  <div>{{scope.row.registrationTime|timestampToTime}}</div>
		        </template>
	      </el-table-column>
	      <el-table-column
		      fixed="right"
		      label="操作"
		      width="50">
		      <template slot-scope="scope">
		        <el-button @click="showAssets(scope.row)" type="text" size="small">查看</el-button>
		      </template>
		 </el-table-column>
    </el-table>
    <!-- 分页组件 -->
    <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>

    <el-dialog title="用户资产信息" :visible.sync="dialogAssetsVisible">
	  <el-table :data="assetsData">
	    <el-table-column property="coin.unit" label="币种" width="150"></el-table-column>
	    <el-table-column property="balance" label="可用余额" width="200"></el-table-column>
	    <el-table-column property="frozenBalance" label="冻结余额"></el-table-column>
	    <el-table-column property="address" label="钱包地址"></el-table-column>
	  </el-table>
	</el-dialog>
  </div>
</template>

<script>
import { getMemberList, getMemberAssetsList } from '../../api/api'
import Pagination from '../../components/Pagination'
export default {
  data() {
    return {
      loading: false, //是显示加载
      dialogAssetsVisible: false,
      editFormVisible: false, //控制编辑页面显示与隐藏
      dateRange: "",
      title: '预览',
      userStatusList: [
        { key: '正常', value: 0 },
        { key: '非法', value: 1 },
        { key: '全部', value: "" }
      ],
      listData: [], //用户数据
      pageNo: 1,
      pageSize: 10,
      filterSearch: {
		account: '',
		commonStatus: ''
	  },
      // 分页参数
      pageparm: {
        currentPage: 1,
        pageSize: 10,
        total: 10
      },
      assetsData: []
    }
  },
  components: {
    Pagination
  },
  created() {
    this.getdata(this.filterSearch)
  },
  methods: {
    getdata(params) {
      this.loading = true;

      getMemberList(params).then(res => {
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
    clearSearch(){
      this.filterSearch = {
		account: '',
		commonStatus: ''
	  };
    },
    showAssets(member){
		this.loading = true;
		let params = {
			memberId: member.id
		};
		getMemberAssetsList(params).then(res => {
	      	if(res.code == 0) {
	      		this.assetsData = res.data;
            this.dialogAssetsVisible = true;
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
      let obj =Object.assign({ pageNo: this.pageNo, pageSize: this.pageSize, property: 'registrationTime', direction: 1 }, this.filterSearch);
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




