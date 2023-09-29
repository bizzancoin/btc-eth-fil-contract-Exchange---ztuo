<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        订单管理
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div class="searchWrapper" style="float:left;">
              <div style="float: left" class="clearfix">
                <div class="poptip">选择交易对：</div>
                <Select  v-model="searchForm.symbol" style="width:120px">
                    <Option v-for="item in coinList" :value="item.symbol" :key="item.symbol">{{ item.symbol }}</Option>
                </Select>
              </div>
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
     <Modal
             class="auditModel"
             v-model="detailModel"
             title="修改数据"
             @on-ok="setOptionOrderDetail">
         <ul>
             <li><span><i>*</i>用户ID：</span>
                 <p>
                     <Input v-model="detailRank.memberId" disabled></Input>
                     <span>{{ }}</span>
                 </p>
             </li>
             <li><span><i>*</i>交易对：</span>
                 <p>
                     <Input v-model="detailRank.symbol" disabled></Input>
                     <span>{{ }}</span>
                 </p>
             </li>
             <li><span><i>*</i>期数：</span>
                 <p>
                     <Input v-model="detailRank.optionNo"></Input>
                     <RadioGroup v-model="detailRank.optionNoChange">
                         <Radio label="1"><em>保持</em></Radio>
                         <Radio label="2"><em>下一期</em></Radio>
                     </RadioGroup>
                 </p>
             </li>
             <li><span><i>*</i>方向：</span>
                 <p>
                     <Input v-model="detailRank.direction"></Input>
                     <RadioGroup v-model="detailRank.directionChange">
                         <Radio label="1"><em>保持</em></Radio>
                         <Radio label="2"><em>反方向</em></Radio>
                     </RadioGroup>
                 </p>
             </li>
         </ul>
     </Modal>
 </div>
</template>


 <script>
import dtime from 'time-formater'
import { querySecondCoinList, querySecondOrderList, setOptionOrder,setClosePresetPrice } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      searchForm: {
        symbol: null,
        memberId: null,
        betAmount: null,
        rewardAmount: null,
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
          title: "交易对",
          width: 100,
          key: "symbol",
          render: (h, params) => {
            const row = params.row;
            return h("div", {
                style:{
                  textAlign: "left"
                }
              }, [
                h("span", {style:{fontWeight:"bold"}}, row.symbol)
              ]);
          }
        },
        {
          title: '开仓价格',
          width: 90,
          key:"openPrice"
        },
        {
          title: '平仓价格',
          width: 90,
          key:"closePrice"
        },
        {
          title: "方向",
          key: "status",
          render: (h, params) => {
            const row = params.row;
            var txt = "投注中";
            var color = "#42b983";
            if(row.direction == "BUY") {
              txt = "看涨";
              color = "#42b983";
            }else{
              txt = "看跌";
              color = "#FF0000";
            }
            
            return h("span", {
              style:{
                  color:color
                }
            }, txt);
          }
        },
        {
          title: "开奖结果",
          key: "result",
          render: (h, params) => {
            const row = params.row;
            var txt = "-";
            var color = "#999";
            if(row.result == "WAIT") {
              txt = "待开始";
              color = "#999";
            }
            if(row.result == "WIN") {
              txt = "胜利";
              color = "#42b983";
            }
            if(row.result == "LOSE") {
              txt = "失败";
              color = "#FF0000";
            }
            if(row.result == "TIED") {
              txt = "平局";
              color = "#999";
            }
            if(row.result == "CANCELED") {
              txt = "撤销";
              color = "#FF0000";
            }
            return h("span", {
              style:{
                  color:color
                }
            }, txt);
          }
        },
        {
          title: '投注额',
          key:"betAmount"
        },
        {
          title: '周期赔率',
          key:"cycleRate"
        },
        {
          title: '周期时长（秒）',
          key:"cycleLength"
        },
        {
          title: '开仓手续费',
          key:"fee"
        },
        {
          title: '盈利数量',
          key:"winAmount"
        },
        {
          title: "是否包赔",
          key: "type",
          render: (h, params) => {
            const row = params.row;
            var txt = "不包";
            if(row.type == "NO") txt = "不包";
            if(row.type == "YES") txt = "包赔";

            return h("span", {}, txt);
          }
        },
        {
          title: "状态",
          key: "status",
          render: (h, params) => {
            const row = params.row;
            var txt = "待开奖";
            if(row.status == "ENTRUST") txt = "委托中";
            if(row.status == "OPEN") txt = "持仓中";
            if(row.status == "CLOSE") txt = "完成";
            if(row.status == "CANCELED") txt = "撤销";

            return h("span", {}, txt);
          }
        },
        {
          title: '预设价格',
          key:"preClosePrice",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.preClosePrice)
            ]);
          }
        },
        {
          title: "操作",
          width:240,
          key: "id",
          align: 'center',
          fixed: 'right',
          render: (h, params) => {
            return h("div", [
              params.row.status == "OPEN" ? h(
                  "Button",
                  {
                    props: {type: "error",size: "small"},
                    style: {marginRight: "5px"},
                    on: {
                      click: () => {
                        this.preClosePrice = 0;
                        this.$Modal.confirm({
                          render: (h) => {
                            return h('Input', {
                              props: {
                                value: this.preClosePrice,
                                autofocus: true,
                                type: 'number',
                                placeholder: '请输预设收盘价格'
                              },
                              on: {
                                input: (val) => {
                                  this.preClosePrice = val;
                                }
                              }
                            })
                          },
                          onOk: () => {
                            let subData = {
                              id: params.row.id,
                              preClosePrice: this.preClosePrice
                            }

                            this.$Loading.start();
                            setClosePresetPrice(subData).then(res => {
                              if(!res.code) {
                                this.$Notice.success({
                                  title: "操作成功！",
                                  desc: res.message,
                                  duration: 10
                                });
                                params.row.preClosePrice=this.preClosePrice;
                              }else{
                                this.$Notice.error({
                                  title: "操作失败！",
                                  desc: res.message,
                                  duration: 10
                                });
                              }

                              this.$Loading.finish();
                            });
                          }
                        })
                      }
                    }
                  },
                  "预设价格"
              ):""
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
      querySecondCoinList({ pageNo: pageIndex, pageSize: 50}).then( res => {
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
      querySecondOrderList(this.searchForm).then(res => {
        this.optionOrderList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){

    },
    changePage(pageIndex) {
      this.currentPageIdx = pageIndex;
      this.refreshdata(pageIndex);
    },
      setOptionOrderDetail() {
          let params = {
           memberId : this.detailRank.memberId,
          optionNo : this.detailRank.optionNo,
          optionNoChange : this.detailRank.optionNoChange,
          directionChange : this.detailRank.directionChange
          };
          setOptionOrder(params).then(res => {
              if (!res.code) {
                  this.$Message.success("修改成功！");
                  this.refreshPageManual();
              } else {
                  this.$Message.error(res.message);
              }
          })
      },
    search() {
      this.refreshdata(1);
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