<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        持仓管理/合约资产管理
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div class="searchWrapper" style="float:left;">
              <div style="float: left" class="clearfix">
                <div class="poptip">合约交易对：</div>
                <Select  v-model="searchForm.contractId" style="width:120px">
                    <Option v-for="item in coinList" :value="item.id" :key="item.id">{{ item.symbol }}</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">仓位模式：</div>
                <Select  v-model="searchForm.usdtPattern" style="width:80px">
                    <Option value="0" key="0">全仓</Option>
                    <Option value="1" key="1">逐仓</Option>
                </Select>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="用户ID" v-model="searchForm.memberId" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="用户手机号" v-model="searchForm.phone" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="用户邮箱" v-model="searchForm.email" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="可用余额大于" v-model="searchForm.usdtBalance" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="冻结余额大于" v-model="searchForm.usdtFrozenBalance" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="多单杠杆大于" v-model="searchForm.usdtBuyLeverage" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="多单仓位大于" v-model="searchForm.usdtBuyPosition" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="冻结多仓大于" v-model="searchForm.usdtFrozenBuyPosition" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="多单保证金大于" v-model="searchForm.usdtBuyPrincipalAmount" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="空单杠杆大于" v-model="searchForm.usdtSellLeverage" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="空单仓位大于" v-model="searchForm.usdtSellPosition" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="冻结空仓大于" v-model="searchForm.usdtFrozenSellPosition" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="空单保证金大于" v-model="searchForm.usdtSellPrincipalAmount" /></Input>
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
        :data="positionList"
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
    </Card>
 </div>
</template>

 <script>
import dtime from 'time-formater'
import { queryPositionList, cancelEntrustOrder, queryContractCoinList } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      searchForm: {
        contractId: null,
        memberId: null,
        phone: null,
        email: null,
        usdtBalance: null,
        usdtFrozenBalance: null,
        usdtPattern: null,
        usdtBuyLeverage: null,
        usdtSellLeverage: null,
        usdtBuyPosition: null,
        usdtFrozenBuyPosition: null,
        usdtBuyPrincipalAmount: null,
        usdtSellPosition: null,
        usdtFrozenSellPosition: null,
        usdtSellPrincipalAmount: null,
        pageNo: 1,
        pageSize: 20
      },
      btnType: 1,
      positionList: [],
      columns: [
        {
          title: '用户ID',
          key:"memberId"
        },
        {
          title: "合约账户",
          width: 100,
          render: (h, params) => {
            return h('span',{},params.row.contractCoin.symbol)
          }
        },
        {
          title: '可用余额',
          key:"usdtBalance",
          render: (h, params) => {
            return h("span", {},  params.row.usdtBalance.toFixed(2));
          }
        },
        {
          title: '冻结余额',
          key:"usdtFrozenBalance",
          render: (h, params) => {
            return h("span", {},  params.row.usdtFrozenBalance.toFixed(2));
          }
        },
        {
          title: "仓位模式",
          key: "usdtPattern",
          render: (h, params) => {
            if(params.row.usdtPattern == "CROSSED") {
              return h("span", {}, "全仓");
            }else if(params.row.usdtPattern == "FIXED"){
              return h("span", {},  "逐仓");
            }else{
              return h("span", {},  "--");
            }
          }
        },
        {
          title: '多仓当前盈亏',
          width: 150,
          key:"usdtBuyLeverage",
          render: (h, params) => {
            var buyPl = 0;
            var percent = 0;
            if(params.row.usdtBuyPosition > 0 || params.row.usdtFrozenBuyPosition > 0) {
              buyPl = (params.row.currentPrice / params.row.usdtBuyPrice - 1) * (params.row.usdtBuyPosition + params.row.usdtFrozenBuyPosition) * params.row.usdtShareNumber;
              percent = (buyPl / params.row.usdtBuyPrincipalAmount).toFixed(4) * 100;
            }
            var color = "#888";
            if(buyPl > 0) {
              color = "#42b983";
            }else if(buyPl < 0) {
              color = "#FF0000";
            }else{
              color = "#888";
            }
            return h("span", {style:{color:color}},  buyPl.toFixed(2) + "   |   " + percent.toFixed(2) + "%");
          }
        },
        {
          title: '多仓杠杆',
          key:"usdtBuyLeverage",
          render: (h, params) => {
            return h("span", {style:{background:"#42b983",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}},  "多" + params.row.usdtBuyLeverage + "X");
          }
        },
        {
          title: '多仓仓位',
          key:"usdtBuyPosition"
        },
        {
          title: '多仓保证金',
          key:"usdtBuyPrincipalAmount",
          render: (h, params) => {
            return h("span", {},  params.row.usdtBuyPrincipalAmount.toFixed(2));
          }
        },
        {
          title: '冻结多仓',
          key:"usdtFrozenBuyPosition"
        },
        {
          title: '空仓盈亏',
          width: 150,
          key:"usdtBuyLeverage",
          render: (h, params) => {
            var sellPl = 0;
            var percent = 0;
            if(params.row.usdtSellPosition > 0 || params.row.usdtFrozenSellPosition > 0) {
              sellPl = (1 - params.row.currentPrice / params.row.usdtSellPrice) * (params.row.usdtSellPosition + params.row.usdtFrozenSellPosition) * params.row.usdtShareNumber;
              percent = (sellPl / params.row.usdtSellPrincipalAmount).toFixed(4) * 100;
            }
            var color = "#888";
            if(sellPl > 0) {
              color = "#42b983";
            }else if(sellPl < 0) {
              color = "#FF0000";
            }else{
              color = "#888";
            }
            return h("span", {style:{color: color}},  sellPl.toFixed(2) + "   |   " + percent.toFixed(2) + "%");
          }
        },
        {
          title: '空仓杠杆',
          key:"usdtSellLeverage",
          render: (h, params) => {
            return h("span", {style:{background:"#FF0000",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}},  "空" + params.row.usdtSellLeverage + "X");
          }
        },
        {
          title: '空仓仓位',
          key:"usdtSellPosition"
        },
        {
          title: '空仓保证金',
          key:"usdtSellPrincipalAmount",
          render: (h, params) => {
            return h("span", {},  params.row.usdtSellPrincipalAmount.toFixed(2));
          }
        },
        {
          title: '冻结空仓',
          key:"usdtFrozenSellPosition"
        }
      ],
      coinList: []
    };
  },
  methods: {
    selected(){

    },
    getCoinList(pageIndex) {
      queryContractCoinList({ pageNo: pageIndex, pageSize: 50}).then( res => {
        this.coinList = res.data.content;
        this.ifLoading = false;
      });
    },
    refreshPageManual(){
      this.ifLoading = true;
      this.refreshdata(this.currentPage);
    },
    refreshdata(pageIndex) {
      this.searchForm.pageNo = pageIndex;
      queryPositionList(this.searchForm).then(res => {
        this.positionList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){

    },
    changePage() {},
    search() {
      this.refreshdata(1);
    },
    clearSearch() {
      this.searchForm = {
        contractId: null,
        memberId: null,
        phone: null,
        email: null,
        usdtBalance: null,
        usdtFrozenBalance: null,
        usdtPattern: null,
        usdtBuyLeverage: null,
        usdtSellLeverage: null,
        usdtBuyPosition: null,
        usdtFrozenBuyPosition: null,
        usdtBuyPrincipalAmount: null,
        usdtSellPosition: null,
        usdtFrozenSellPosition: null,
        usdtSellPrincipalAmount: null,
        pageNo: 1,
        pageSize: 20
      }
    }
  },
  created() {
    this.getCoinList(1);
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