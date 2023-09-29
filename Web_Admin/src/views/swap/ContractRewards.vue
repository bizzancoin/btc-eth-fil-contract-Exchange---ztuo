<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        返佣管理
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div class="searchWrapper" style="float:left;">
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">返佣分类：</div>
                <Select  v-model="searchForm.type" style="width:130px">
                    <Option value="0" key="0">开仓手续费返佣</Option>
                    <Option value="1" key="1">平仓手续费返佣</Option>
					<Option value="2" key="2">平级奖励</Option>
					<Option value="3" key="3">平台手续费收入</Option>
                </Select>
              </div>
              <div class="poptip" style="margin-left: 0px;">
                  <Input placeholder="用户ID" v-model="searchForm.memberId" /></Input>
              </div>
              <div class="poptip">
                <DatePicker
                  type="daterange"
                  placement="bottom-end"
                  @on-change="dateRange"
                  placeholder="选择时间区间">
                </DatePicker>
              </div>
              <div class="btns">
                  <Button type="info" @click="search">搜索</Button>
                  <Button type="default" @click="clearSearch">清空</Button>
              </div>
          </div>
        </Col>
      </Row>
      <Table
        border
        :columns="columns"
        :data="rewardRecordList"
        @on-selection-change="selected"
        :loading="ifLoading">
      </Table>

      <Row class="pageWrapper">
        <Page
        :total="pageNum"
        class="buttomPage"
        :current="currentPage"
        @on-change="changePage"
        show-elevator></Page>
      </Row>
      <p style="font-size:11px;">注意1：</p>
    </Card>
 </div>
</template>


 <script>
import dtime from 'time-formater'
import { queryRewardRecordList} from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      searchForm: {
        type: null,
        memberId: null,
        startTime: null,
        endTime: null,
        pageNo: 1,
        pageSize: 10
      },
      btnType: 1,
      rewardRecordList: [],
      columns: [
        {
          title: '用户ID',
          key:"memeberId",
		  render: (h, params) => {
			return h("span", params.row.member.id);
		  }
        },
		{
		  title: '用户手机号',
		  key:"memeberPhone",
		  render: (h, params) => {
			return h("span", params.row.member.mobilePhone);
		  }
		},
		{
		  title: '来源用户ID',
		  key:"fromMemberId",
		  render: (h, params) => {
		  	return h("span", params.row.fromMember.id);
		  }
		},
		{
		  title: '来源用户手机号',
		  key:"fromMemberPhone",
		  render: (h, params) => {
		  	return h("span", params.row.fromMember.mobilePhone);
		  }
		},
        {
          title: "类型",
          key: "typeStr",
          render: (h, params) => {
            const row = params.row;
            if(row.type == "0") {
            	return h("span", {style:{background:"#42b983",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "开仓手续费返佣");
            }else if(row.type == "1"){
            	return h("span", {style:{background:"#FF0000",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "平仓手续费返佣");
            }else if(row.type == "2"){
            	return h("span", {style:{background:"#562ff6",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "平级奖励");
            }else{
            	return h("span", {style:{background:"#f8a640",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "平台手续费收入");
            }
          }
        },
        {
          title: '返佣数量',
          key:"num"
        },
		{
		  title: '佣金币种',
		  key:"coinName",
		  render: (h, params) => {
		  	return h("span", params.row.coin.name);
		  }
		},
		{
		  title: '委托id',
		  key:"orderId",
		  render: (h, params) => {
		  	return h("span", params.row.contractOrderEntrust.id);
		  }
		},
        {
          title: "返佣时间",
          render: (h, obj) => {
            let formatTime = dtime(obj.row.createTime).format('YYYY-MM-DD HH:mm:ss')
            return h('span',{},formatTime)
          }
        }
      ],
      coinList: []
    };
  },
  methods: {
    selected(){

    },
    refreshPageManual(){
      this.ifLoading = true;
      this.refreshdata(this.currentPage);
    },
    refreshdata(pageIndex) {
      this.ifLoading = true;
      this.searchForm.pageNo = pageIndex;
      queryRewardRecordList(this.searchForm).then(res => {
        this.rewardRecordList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    changePage(pageIndex) {
      this.searchForm.pageNo = pageIndex;
      this.currentPage = pageIndex;
      this.ifLoading = true;
      queryRewardRecordList(this.searchForm).then(res => {
        this.rewardRecordList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    search() {
      this.refreshdata(1);
    },
    dateRange(val) {
      this.searchForm.startTime = val[0] + " 00:00:00";
      this.searchForm.endTime = val[1] + " 00:00:00";
    },
    clearSearch() {
      this.searchForm = {
        type: null,
        memberId: null,
        startTime: null,
        endTime: null,
        pageNo: 1,
        pageSize: 10
      };
    }
  },
  created() {
    this.refreshdata(1);
  }
};
</script>

<style lang="less" scoped>
  .auditModel{
    ul {
      padding-left: 20px;
      li {
        position: relative;
        margin-bottom: 18px;
        span{
          position: absolute;
          top: 0;
          left: 0;
          display: inline-block;
          width: 95px;
          text-align: right;
          i{
            font-size: 14px;
            font-weight: 700;
            color: #ec0909;
          }
        }
        p{
          padding-left: 100px;
          min-width: 300px;
          line-height: 32px;
          em{
            position: static;
            color: unset;
          }
        }
      }
    }
  }
  .setting-title{
    font-size:14px;font-weight:bold;padding-bottom:20px;
  }
.auditModel ul li>em{
    position: absolute;
    bottom: -15px;
    font-size:10px;
    margin-left: 100px;
    line-height:12px;
    font-style: normal;
    color: #ec0909;
  }
</style>