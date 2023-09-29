<template>
  <div>
    <!-- 面包屑导航 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>实名管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 搜索筛选 -->
    <el-form :inline="true" :model="filterSearch" class="user-search">
      <el-form-item>
        <el-input size="small" style="width:300px;" v-model="filterSearch.account" placeholder="请输入用户名或姓名搜索"></el-input>
      </el-form-item>

      <el-form-item label="审核状态：">
        <el-select size="small" v-model="filterSearch.auditStatus" placeholder="请选择">
          <el-option v-for="type in auditStatusList" :label="type.key" :value="type.value" :key="type.value"></el-option>
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
      <el-table-column prop="id"     width="60"     label="编号" show-overflow-tooltip></el-table-column>
      <el-table-column prop="member.id"    width="80"      label="会员ID" show-overflow-tooltip></el-table-column>
      <el-table-column prop="member.username"    width="120"      label="用户名称" show-overflow-tooltip></el-table-column>
<!--      <el-table-column prop="member.mobilePhone"       label="手机号码" show-overflow-tooltip></el-table-column>-->
<!--      <el-table-column prop="member.email"             label="邮箱地址" show-overflow-tooltip></el-table-column>-->
<!--      <el-table-column prop="member.superPartner" label="会员等级" align="center" width="60">-->
<!--        <template slot-scope="scope">-->
<!--          <el-tag v-if="scope.row.member.superPartner == '0'" type="info">普通用户</el-tag>-->
<!--          <el-tag v-if="scope.row.member.superPartner == '1'" type="success">超级代理商</el-tag>-->
<!--        </template>-->
<!--      </el-table-column>-->
      <el-table-column prop="realName"    label="真名" width="60"  show-overflow-tooltip></el-table-column>
      <el-table-column prop="idCard"    label="身份证号码" width="160"  show-overflow-tooltip></el-table-column>
      <el-table-column prop="realNameStatus" label="实名状态" align="center" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.auditStatus == 0" type="info">待审核</el-tag>
          <el-tag v-if="scope.row.auditStatus == 1" type="primary">审核失败</el-tag>
          <el-tag v-if="scope.row.auditStatus == 2" type="success">审核成功</el-tag>
        </template>
      </el-table-column>

      <el-table-column label="认证时间" width="160">
        <template slot-scope="scope">
          <div>{{scope.row.member.applicationTime|timestampToTime}}</div>
        </template>
      </el-table-column>
<!--      <el-table-column label="注册时间">-->
<!--        <template slot-scope="scope">-->
<!--          <div>{{scope.row.registrationTime|timestampToTime}}</div>-->
<!--        </template>-->
<!--      </el-table-column>-->
      <el-table-column
        fixed="right"
        label="操作"
        width="260">
        <template slot-scope="scope">
<!--          <el-button @click="showAssets(scope.row)" type="text" size="small">查看</el-button>-->
          <el-button  @click="show(scope.row)" type="text" size="small">查看</el-button>
          <el-button v-show="scope.row.auditStatus == 0" @click="pass(scope.row)" type="text" size="small">通过</el-button>
          <el-button v-show="scope.row.auditStatus == 0" @click="noPass(scope.row)" type="text" size="small">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页组件 -->
    <Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>

<!--    <el-dialog title="用户资产信息" :visible.sync="dialogAssetsVisible">-->
<!--      <el-table :data="assetsData">-->
<!--        <el-table-column property="unit" label="币种" width="150"></el-table-column>-->
<!--        <el-table-column property="balance" label="可用余额" width="200"></el-table-column>-->
<!--        <el-table-column property="frozenBalance" label="冻结余额"></el-table-column>-->
<!--        <el-table-column property="address" label="钱包地址"></el-table-column>-->
<!--      </el-table>-->
<!--    </el-dialog>-->
        <el-dialog title="用户实名信息" :visible.sync="dialogAssetsVisible">
<!--          <el-table :data="authData">-->
<!--            <el-table-column property="idCard" label="正面" width="150" height="200"></el-table-column>-->
<!--            <el-table-column label="手持">-->
<!--              　<template slot-scope="scope">-->
<!--              　　　　<img :src="scope.row.identityCardImgInHand" width="40" height="40" class="head_pic"/>-->
<!--              　　</template>-->
<!--            </el-table-column>-->
<!--            <el-table-column property="identityCardImgReverse" label="北面"></el-table-column>-->
<!--&lt;!&ndash;            <el-table-column property="address" label="钱包地址"></el-table-column>&ndash;&gt;-->
<!--          </el-table>-->
          <img :src="authData.identityCardImgFront" width="300" height="300">
          <img :src="authData.identityCardImgInHand" width="300" height="300">
          <img :src="authData.identityCardImgReverse" width="300" height="300">
        </el-dialog>
  </div>
</template>

<script>
import { memberRealNameList ,memberRealNameDetail,memberCheckPass,memberCheckNotPass} from '../../api/api'
import Pagination from '../../components/Pagination'
export default {
  data() {
    return {
      loading: false, //是显示加载
      dialogAssetsVisible: false,
      editFormVisible: false, //控制编辑页面显示与隐藏
      dateRange: "",
      title: '预览',
      auditStatusList: [
        { key: '待审核', value: 0 },
        { key: '审核失败', value: 1 },
        { key: '审核成功', value: 2 },
        { key: '全部', value: "" }
      ],
      listData: [], //用户数据
      pageNo: 1,
      pageSize: 10,
      filterSearch: {
        account: "",
        auditStatus: ""
      },
      // 分页参数
      pageparm: {
        currentPage: 1,
        pageSize: 10,
        total: 10
      },
      authData: {
        id:""
      }
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
      // alert(1);
      // console.log(params);
      this.loading = true;
      // alert(2);
      memberRealNameList(params).then(res => {
        // alert(3);
        if (res.code == 0) {
          // alert(4);
          this.listData = res.data.content;
          this.pageparm.currentPage = this.pageNo;
          this.pageparm.pageSize = this.pageSize;
          this.pageparm.total = res.data.totalElements;
        } else {
          this.$message.error(res.message);
        }
        this.loading = false;
      });
      // alert(5);
    },
    clearSearch() {
      this.filterSearch = {
        account: "",
        auditStatus: ""
      };
    },
    show(member){
      this.loading = true;
        let params = {
          id: member.id
        };
      memberRealNameDetail(params).then(res => {
        if(res.code == 0) {
                this.authData = res.data;
                this.dialogAssetsVisible = true;
              }else{
                this.$message.error(res.message);
              }
        this.loading = false;
      });
    },
    noPass(member) {
      memberCheckNotPass(member.id).then(res => {
        if (!res.code) {
          this.$message.success(res.message);
          this.getdata(this.filterSearch)
        } else {
          this.$message.error("失败");
        }
      });
    },
    pass (member) {
      // if(this.tabSwitch) {
        memberCheckPass(member.id)
          .then(res => {
            if (res.code === 0) {
              this.$message.success(res.message);
              this.getdata(this.filterSearch)
            }else{
              this.$message.error("失败");
            }
          })
      // } else {
      //   let callBack = memberCheckNotPass({ memberID: this.queryID, rejectReason: `rejectReason=${this.rejectReason}`});
      //   if (!!callBack) {
      //     callBack.then(res => {
      //       if (res.code === 0) {
      //         MemberRealNameDetail ({id: this.queryID})
      //           .then( res => {
      //             this.status = res.data.auditStatus;
      //           })
      //       }
      //     })
      //   }
      // }
    },
    // showAssets(member){
    //   this.loading = true;
    //   let params = {
    //     memberId: member.id
    //   };
    //   getMemberAssetsList(params).then(res => {
    //     if(res.code == 0) {
    //       this.assetsData = res.data;
    //     }else{
    //       this.$message.error(res.message);
    //     }
    //     this.loading = false;
    //   });
    // },
    // // 分页插件事件
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




