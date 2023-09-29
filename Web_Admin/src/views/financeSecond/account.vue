<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        理财账户
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div class="searchWrapper" style="float:left;">
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="用户ID" v-model="searchForm.memberId" /></Input>
              </div>
              <div class="btns">
                  <Button type="info" @click="search">搜索</Button>
              </div>
          </div>
        </Col>
      </Row>
      <Table
        border
        :columns="columns"
        :data="optionOrderList"
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
import { queryAccounts} from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      searchForm: {
        memberId: null,
        pageNo: 1,
        pageSize: 10
      },
        //弹窗信息
        detailModel: false,
        detailRank: {
            memberId: "",
            symbol: null,
            optionNo: null,
            optionNoChange: "1",
            direction: null,
            directionChange: "1",
        },
      optionOrderList: [],
      columns: [
        {
          title: '用户ID',
          key:"memberId"
        },
        {
          title: "币种",
          width: 100,
          key: "coin_symbol",
          render: (h, params) => {
            const row = params.row;
            return h("div", {
                style:{
                  textAlign: "left"
                }
              }, [
                h("span", {style:{fontWeight:"bold"}}, row.coinSymbol)
              ]);
          }
        },
        {
          title: '余额',
          key:"num",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.num)
              ]);
          }
        },
        {
          title: "收益",
          key: "earnNum",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.earnNum)
            ]);
          }
        },
        {
          title: '创建时间',
          key:"createTime"
        },
        {
          title: '更新时间',
          key:"updateTime"
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
      this.searchForm.pageNo = pageIndex;
      queryAccounts(this.searchForm).then(res => {
        this.optionOrderList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){

    },
    changePage() {},
    search() {
      this.refreshdata(1);
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