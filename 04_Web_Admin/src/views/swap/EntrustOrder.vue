<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        委托管理
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
                <div class="poptip">委托分类：</div>
                <Select  v-model="searchForm.entrustType" style="width:80px">
                    <Option value="0" key="0">开仓</Option>
                    <Option value="1" key="1">平仓</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">委托方向：</div>
                <Select  v-model="searchForm.direction" style="width:80px">
                    <Option value="0" key="0">多单</Option>
                    <Option value="1" key="1">空单</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">委托类型：</div>
                <Select  v-model="searchForm.type" style="width:100px">
                    <Option value="0" key="0">市价委托</Option>
                    <Option value="1" key="1">限价委托</Option>
                    <Option value="2" key="2">计划委托</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">是否爆仓单：</div>
                <Select  v-model="searchForm.isBlast" style="width:80px">
                    <Option value="0" key="0">否</Option>
                    <Option value="1" key="1">是</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">是否计划委托：</div>
                <Select  v-model="searchForm.isFromSpot" style="width:80px">
                    <Option value="0" key="0">否</Option>
                    <Option value="1" key="1">是</Option>
                </Select>
              </div>
              <div style="float: left;margin-left: 15px;" class="clearfix">
                <div class="poptip">委托状态：</div>
                <Select  v-model="searchForm.status" style="width:100px">
                    <Option value="0" key="0">委托中</Option>
                    <Option value="1" key="1">已撤销</Option>
                    <Option value="2" key="2">委托失败</Option>
                    <Option value="3" key="3">委托成功</Option>
                </Select>
              </div><br/>
              <div class="poptip" style="margin-left: 0px;">
                  <Input placeholder="用户ID" v-model="searchForm.memberId" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="用户手机号" v-model="searchForm.phone" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="用户邮箱" v-model="searchForm.email" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="合约收益大于" v-model="searchForm.profitAndLoss" /></Input>
              </div>
              <div class="poptip" style="margin-left: 15px;">
                  <Input placeholder="委托量大于" v-model="searchForm.volume" /></Input>
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
        :data="entrustOrderList"
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
import { queryEntrustList, cancelEntrustOrder, queryContractCoinList } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      searchForm: {
        status: null,
        type: null,
        direction: null,
        entrustType: null,
        memberId: null,
        contractId: null,
        volume: null,
        startTime: null,
        endTime: null,
        isFromSpot: null,
        isBlast: null,
        profitAndLoss: null,
        phone: null,
        email: null,
        pageNo: 1,
        pageSize: 10
      },
      btnType: 1,
      entrustOrderList: [],
      columns: [
        {
          title: '用户ID',
          key:"memberId"
        },
        {
          title: '合约',
          key:"symbol"
        },
        {
          title: "类型",
          key: "status",
          render: (h, params) => {
            const row = params.row;
            if(row.direction == "BUY" && row.entrustType == "OPEN") {
              return h("span", {style:{background:"#42b983",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "买入开多");
            }else if(row.direction == "SELL" && row.entrustType == "OPEN"){
              return h("span", {style:{background:"#FF0000",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "卖出开空");
            }else if(row.direction == "BUY" && row.entrustType == "CLOSE"){
              return h("span", {style:{background:"#42b983",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "买入平空");
            }else if(row.direction == "SELL" && row.entrustType == "CLOSE"){
              return h("span", {style:{background:"#FF0000",color:"#FFF",padding:"3px 5px",borderRadius:"5px"}}, "卖出平多");
            }else{

            }
          }
        },
        {
          title: "委托类型",
          key: "type",
          render: (h, params) => {
            if(params.row.isFromSpot == 1) {
              return h("span", {}, "计划委托");
            }
            if(params.row.type == "LIMIT_PRICE") {
              return h("span", {}, "限价委托");
            }else if(params.row.type == "MARKET_PRICE"){
              return h("span", {},  "市价委托");
            }else{
              return h("span", {}, "计划委托");
            }
          }
        },
        {
          title: '委托张数',
          key:"volume"
        },
        {
          title: '触发价',
          key:"triggerPrice"
        },
        {
          title: '委托价',
          key:"entrustPrice"
        },
        {
          title: '成交价',
          key:"tradedPrice"
        },
        {
          title: '成交张数',
          key:"tradedVolume"
        },
        {
          title: '开仓手续费',
          key:"openFee",
          render: (h, params) => {
              if(params.row.status == "ENTRUST_CANCEL") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_FAILURE") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_SUCCESS" && params.row.entrustType == "OPEN") {
                return h("span", {}, params.row.openFee);
              }else{
                return h("span", {}, "-");
              }
            }
        },
        {
          title: '平仓手续费',
          key:"closeFee",
          render: (h, params) => {
              if(params.row.status == "ENTRUST_CANCEL") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_FAILURE") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_SUCCESS" && params.row.entrustType == "CLOSE") {
                return h("span", {}, params.row.closeFee);
              }else{
                return h("span", {}, "-");
              }
            }
        },
        {
          title: '平仓盈亏',
          key:"profitAndLoss",
          render: (h, params) => {
              if(params.row.status == "ENTRUST_CANCEL") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_FAILURE") {
                return h("span", {}, "-");
              } else if(params.row.status == "ENTRUST_SUCCESS" && params.row.entrustType == "CLOSE") {
                if(params.row.profitAndLoss > 0) {
                  return h("span", {style:{color:"#42b983",padding:"3px 5px",borderRadius:"5px"}}, params.row.profitAndLoss.toFixed(2));
                }else if(params.row.profitAndLoss < 0) {
                  return h("span", {style:{color:"#FF0000",padding:"3px 5px",borderRadius:"5px"}}, params.row.profitAndLoss.toFixed(2));
                }else{
                  return h("span", {style:{color:"#AFAFAF",padding:"3px 5px",borderRadius:"5px"}}, params.row.profitAndLoss.toFixed(2));
                }
              }else{
                return h("span", {}, "-");
              }
            }
        },
        {
          title: '状态',
          key:"status",
          render: (h, params) => {
              if(params.row.isBlast == 1){
                return h("span", {}, "爆仓");
              }
              if(params.row.status == "ENTRUST_CANCEL") {
                return h("span", {}, "撤销");
              } else if(params.row.status == "ENTRUST_FAILURE") {
                return h("span", {}, "委托失败");
              } else if(params.row.status == "ENTRUST_SUCCESS") {
                return h("span", {}, "委托成功");
              }else{
                return h("span", {}, "委托中");
              }
            }
        },
        {
          title: "挂单时间",
          width: 100,
          render: (h, obj) => {
            let formatTime = dtime(obj.row.createTime).format('YYYY-MM-DD HH:mm:ss')
            return h('span',{},formatTime)
          }
        },
        {
          title: "操作",
          width:100,
          key: "id",
          align: 'center',
          fixed: 'right',
          render: (h, params) => {
            return h("div", [
              h(
                "Button",
                {
                  props: {type: "error",size: "small"},
                  style: {marginRight: "5px"},
                  on: {
                    click: () => {
                      let subData = {
                        contractId: params.row.id
                      }

                      this.$Loading.start();
                      initContractWallet(subData).then(res => {
                        if(!res.code) {
                          this.$Notice.success({
                                  title: "撤销成功",
                                  desc: res.message,
                                  duration: 10
                              });
                        }else{
                          this.$Notice.error({
                                  title: "撤销失败",
                                  desc: res.message,
                                  duration: 10
                              });
                        }

                        this.$Loading.finish();
                      });
                    }
                  }
                },
                "强制撤销"
              )
            ]);
          }
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
      this.ifLoading = true;
      this.searchForm.pageNo = pageIndex;
      queryEntrustList(this.searchForm).then(res => {
        this.entrustOrderList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){

    },
    changePage(pageIndex) {
      this.searchForm.pageNo = pageIndex;
      this.currentPage = pageIndex;
      this.ifLoading = true;
      queryEntrustList(this.searchForm).then(res => {
        this.entrustOrderList = res.data.content;
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
        status: null,
        type: null,
        direction: null,
        entrustType: null,
        memberId: null,
        contractId: null,
        volume: null,
        startTime: null,
        endTime: null,
        isFromSpot: null,
        isBlast: null,
        profitAndLoss: null,
        phone: null,
        email: null,
        pageNo: 1,
        pageSize: 10
      };
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