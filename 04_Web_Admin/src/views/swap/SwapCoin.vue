<template>
 <div>
	 <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
			<p slot="title">
			  永续合约管理
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
			</p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div style="float: right" class="clearfix">
            <Button type="primary"@click="addCoinClick">添加交易对</Button>
          </div>
        </Col>
      </Row>
      <Table
        border
        :columns="columns"
        :data="coinList"
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

      <Modal
          class="auditModel"
          v-model="coinModal"
          title="新增/修改交易对"
          @on-ok="submit">
          <ul>
            <li><span><i>*</i>交易对：</span>
              <p>
                <Input v-model="contractCoin.symbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>启用：</span>
              <p>
                <RadioGroup v-model="contractCoin.enable">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="2"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>显示：</span>
              <p>
                <RadioGroup v-model="contractCoin.visible">
                  <Radio label="1"><em>显示</em></Radio>
                  <Radio label="2"><em>隐藏</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>合约名称：</span>
              <p>
                <Input v-model="contractCoin.name"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>币种：</span>
              <p>
                <Input v-model="contractCoin.coinSymbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>基础量价币种：</span>
              <p>
                <Input v-model="contractCoin.baseSymbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>合约面值：</span>
              <p>
                <Input v-model="contractCoin.shareNumber" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
                <p style="color:#FF0000;text-align: right;">新建币种后，不可更改，会影响合约盈亏计算</p>
              </p>
            </li>
            <li><span><i>*</i>杠杆倍数类型：</span>
              <p>
                <RadioGroup v-model="contractCoin.leverageType">
                  <Radio label="1"><em>离散倍数</em></Radio>
                  <Radio label="2"><em>连续倍数</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>杠杆倍数：</span>
              <p>
                <Input v-model="contractCoin.leverage"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>维持保证金率：</span>
              <p>
                <Input v-model="contractCoin.maintenanceMarginRate"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>允许开多：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableOpenBuy">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="0"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>允许开空：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableOpenSell">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="0"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>市价开多：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableMarketBuy">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="0"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>市价开空：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableMarketSell">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="0"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>计划委托：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableTriggerEntrust">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="0"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>可交易：</span>
              <p>
                <RadioGroup v-model="contractCoin.enableTriggerEntrust">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="2"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>开仓手续费率：</span>
              <p>
                <Input v-model="contractCoin.openFee"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>平仓手续费率：</span>
              <p>
                <Input v-model="contractCoin.closeFee"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>资金费率结算周期（小时）：</span>
              <p>
                <Input v-model="contractCoin.intervalHour"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>资金费率：</span>
              <p>
                <Input v-model="contractCoin.feePercent"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>最小张数：</span>
              <p>
                <Input v-model="contractCoin.minShare"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>最大张数：</span>
              <p>
                <Input v-model="contractCoin.maxShare"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>滑点类型：</span>
              <p>
                <RadioGroup v-model="contractCoin.spreadType">
                  <Radio label="1"><em>百分比</em></Radio>
                  <Radio label="2"><em>固定值</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>滑点：</span>
              <p>
                <Input v-model="contractCoin.spread"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>基币小数精度：</span>
              <p>
                <Input v-model="contractCoin.baseCoinScale"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>币种小数精度：</span>
              <p>
                <Input v-model="contractCoin.coinScale"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>Taker费率：</span>
              <p>
                <Input v-model="contractCoin.takerFee"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>Maker费率：</span>
              <p>
                <Input v-model="contractCoin.makerFee"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>合约类型：</span>
              <p>
                <RadioGroup v-model="contractCoin.type">
                  <Radio label="0"><em>USDT本位</em></Radio>
                  <Radio label="1" disabled><em>币本位</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>排序：</span>
              <p>
                <Input v-model="contractCoin.sort"></Input>
                <span>{{ }}</span>
              </p>
            </li>
          </ul>
      </Modal>
    </Card>
 </div>
</template>


 <script>
import dtime from 'time-formater'
import { queryContractCoinList, addContractCoin, alterContractCoin, initContractWallet, poke } from '@/service/getData'

export default {
  data() {
    return {
      contractId: 0,
      triggerPrice: 0,
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      coinModal: false,
      isAdd: true,
      contractCoin: {
        symbol: "",
        baseCoinScale: 4,
        baseSymbol: "USDT",
        closeFee: 0.0001,
        coinScale: 4,
        coinSymbol: "",
        enable: "1",
        visible: "1",
        enableMarketBuy: "1",
        enableMarketSell: "1",
        enableOpenBuy: "1",
        enableOpenSell: "1",
        enableTriggerEntrust: "1",
        exchangeable: "1",
        feePercent: 0.001,
        intervalHour: 1,
        leverage: "10,20,30,40,50,60,70,80,90,100",
        leverageType: "1",
        maintenanceMarginRate: 0.005,
        makerFee: 0.0001,
        maxShare: 1000,
        minShare: 1,
        name: "",
        openFee: 0.0001,
        shareNumber: 100,
        sort: 1,
        spread: 0,
        spreadType: "1",
        takerFee: 0.0001,
        type: "0"
      },
      columns: [
        {
          title: "合约交易对",
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
          title: "合约面值",
          width:120,
          key: "shareNumber",
          render: (h, params) => {
            const row = params.row;
            const txt = row.shareNumber + " USDT/张";
            return h("span", {}, txt);
          }
        },
        {
          title: "启用",
          width:65,
          key: "enable",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enable == 1 ? "是" : "否";
            if(row.enable == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "显示",
          width:65,
          key: "visible",
          render: (h, params) => {
            const row = params.row;
            const visible = row.visible == 1 ? "是" : "否";
            if(row.visible == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, visible);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, visible);
          }
        },
        {
          title: "开多",
          width:65,
          key: "enableOpenBuy",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableOpenBuy == 1 ? "是" : "否";
            if(row.enableOpenBuy == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "开空",
          width:65,
          key: "enableOpenSell",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableOpenSell == 1 ? "是" : "否";
            if(row.enableOpenSell == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "市价开多",
          width:65,
          key: "enableMarketBuy",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableMarketBuy == 1 ? "是" : "否";
            if(row.enableMarketBuy == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "市价开空",
          width:65,
          key: "enableMarketSell",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableMarketSell == 1 ? "是" : "否";
            if(row.enableMarketSell == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "允许交易",
          width:65,
          key: "exchangeable",
          render: (h, params) => {
            const row = params.row;
            const txt = row.exchangeable == 1 ? "是" : "否";
            if(row.exchangeable == 1) {
              return h("span", {
                style:{
                  color:'#42b983'
                }
              }, txt);
            }
            return h("span", {
              style:{
                  color:'#FF0000'
                }
            }, txt);
          }
        },
        {
          title: "倍数类型",
          width:65,
          key: "leverageType",
          render: (h, params) => {
            const row = params.row;
            const txt = row.leverageType == 1 ? "离散" : "连续";
            return h("span", {}, txt);
          }
        },
        {
          title: '杠杆倍数',
          width: 140,
          key:"leverage"
        },
        {
          title: "滑点类型",
          width:85,
          key: "spreadType",
          render: (h, params) => {
            const row = params.row;
            const txt = row.spreadType == 1 ? "百分比" : "固定值";
            return h("span", {}, txt);
          }
        },
        {
          title: "滑点值",
          width:75,
          key: "spread",
          render: (h, params) => {
            const row = params.row;
            const txt = row.spreadType == 1 ? (row.spread * 100 + " %") : row.spread;
            return h("span", {}, txt);
          }
        },
        {
          title: '资金费率周期',
          width:80,
          key:"intervalHour",
          render: (h, params) => {
            const row = params.row;
            return h("span", {}, row.intervalHour + " H");
          }
        },
        {
          title: '资金费率',
          width:75,
          key:"feePercent",
          render: (h, params) => {
            const row = params.row;
            return h("span", {}, row.feePercent * 100 + " %");
          }
        },
        {
          title: '最低保证金率',
          width:75,
          key:"maintenanceMarginRate",
          render: (h, params) => {
            const row = params.row;
            return h("span", {}, row.maintenanceMarginRate * 100 + " %");
          }
        },
        {
          title: '最小张数',
          width:65,
          key:"minShare"
        },
        {
          title: '最大张数',
          width:65,
          key:"maxShare"
        },
        {
          title: '开仓手续费',
          width:75,
          key:"openFee",
          render: (h, params) => {
            const row = params.row;
            return h("span", {}, row.openFee * 100 + " %");
          }
        },
        {
          title: '平仓手续费',
          width:75,
          key:"closeFee",
          render: (h, params) => {
            const row = params.row;
            return h("span", {}, row.closeFee * 100 + " %");
          }
        },
        {
          title: '平台盈利',
          width:135,
          key:"totalProfit",
          render: (h, params) => {
            const row = params.row;
            return h("span", {style:{color:"#42b983"}}, row.totalProfit.toFixed(2));
          }
        },
        {
          title: '平台亏损',
          width:135,
          key:"totalLoss",
          render: (h, params) => {
            const row = params.row;
            return h("span", {style:{color:"#FF0000"}}, row.totalLoss.toFixed(2));
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
              h(
                "Button",
                {
                  props: {type: "info",size: "small",icon:"android-settings"},
                  style: {marginRight: "5px"},
                  on: {
                    click: () => {
                      this.isAdd = false;
                      this.contractCoin = {
                        id: params.row.id,
                        symbol: params.row.symbol,
                        baseCoinScale: params.row.baseCoinScale,
                        baseSymbol: params.row.baseSymbol,
                        closeFee: params.row.closeFee,
                        coinScale: params.row.coinScale,
                        coinSymbol: params.row.coinSymbol,
                        enable: params.row.enable + "",
                        visible: params.row.visible + "",
                        enableMarketBuy: params.row.enableMarketBuy + "",
                        enableMarketSell: params.row.enableMarketSell + "",
                        enableOpenBuy: params.row.enableOpenBuy + "",
                        enableOpenSell: params.row.enableOpenSell + "",
                        enableTriggerEntrust: params.row.enableTriggerEntrust + "",
                        exchangeable: params.row.exchangeable + "",
                        feePercent: params.row.feePercent,
                        intervalHour: params.row.intervalHour,
                        leverage: params.row.leverage,
                        leverageType: params.row.leverageType + "",
                        maintenanceMarginRate: params.row.maintenanceMarginRate,
                        makerFee: params.row.makerFee,
                        maxShare: params.row.maxShare,
                        minShare: params.row.minShare,
                        name: params.row.name,
                        openFee: params.row.openFee,
                        shareNumber: params.row.shareNumber,
                        sort: params.row.sort,
                        spread: params.row.spread,
                        spreadType: params.row.spreadType + "",
                        takerFee: params.row.takerFee,
                        type: params.row.type == "PERPETUAL" ? "0" : "1"
                      };
                      this.coinModal = true;
                    }
                  }
                },
                "修改"
              ),
              h(
                "Button",
                {
                  props: {type: "success",size: "small"},
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
                                  title: "生成成功！",
                                  desc: res.message,
                                  duration: 10
                              });
                        }else{
                          this.$Notice.error({
                                  title: "生成失败",
                                  desc: res.message,
                                  duration: 10
                              });
                        }

                        this.$Loading.finish();
                      });
                    }
                  }
                },
                "生成合约账户"
              ),
              h(
                "Button",
                {
                  props: {type: "error",size: "small"},
                  style: {marginRight: "5px"},
                  on: {
                    click: () => {
                      this.triggerPrice = "";
                      this.$Modal.confirm({
                          render: (h) => {
                              return h('Input', {
                                  props: {
                                      value: this.triggerPrice,
                                      autofocus: true,
									  type: 'number',
                                      placeholder: '请输入目标价'
                                  },
                                  on: {
                                      input: (val) => {
                                          this.triggerPrice = val;
                                      }
                                  }
                              })
                          },
                        onOk: () => { 
						  let subData = {
							contractId: params.row.id,
							price: this.triggerPrice
						  }
						  
						  this.$Loading.start();
						  poke(subData).then(res => {
							if(!res.code) {
							  this.$Notice.success({
									  title: "操作成功！",
									  desc: res.message,
									  duration: 10
								  });
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
                "戳一下"
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
    refreshPageManual(){
      this.ifLoading = true;
      this.refreshdata(this.currentPage);
    },
    refreshdata(pageIndex) {
      queryContractCoinList({ pageNo: pageIndex, pageSize: 50}).then( res => {
        this.coinList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){
      this.isAdd = true;
      this.contractCoin = {
        symbol: "",
        baseCoinScale: 4,
        baseSymbol: "USDT",
        closeFee: 0.0001,
        coinScale: 4,
        coinSymbol: "",
        enable: "1",
        visible: "1",
        enableMarketBuy: "1",
        enableMarketSell: "1",
        enableOpenBuy: "1",
        enableOpenSell: "1",
        enableTriggerEntrust: "1",
        exchangeable: "1",
        feePercent: 0.001,
        intervalHour: 1,
        leverage: "10,20,30,40,50,60,70,80,90,100",
        leverageType: "1",
        maintenanceMarginRate: 0.005,
        makerFee: 0.0001,
        maxShare: 1000,
        minShare: 1,
        name: "",
        openFee: 0.0001,
        shareNumber: 100,
        sort: 1,
        spread: 0,
        spreadType: "1",
        takerFee: 0.0001,
        type: "0"
      };
      this.coinModal = true;
    },
    submit(){
      if(this.isAdd) {
        addContractCoin(this.contractCoin).then(res => {
          if(!res.code) {
            this.$Notice.success({
                    title: "新建成功！",
                    desc: res.message,
                    duration: 10
                });
            this.coinModal = false;
            this.refreshdata(1);
          }else{
            this.$Notice.error({
                    title: "新建失败",
                    desc: res.message,
                    duration: 10
                });
          }
        });
      }else{
        alterContractCoin(this.contractCoin).then(res => {
          if(!res.code) {
            this.$Notice.success({
                    title: "修改成功！",
                    desc: res.message,
                    duration: 10
                });
            this.coinModal = false;
            this.refreshdata(1);
          }else{
            this.$Notice.error({
                    title: "修改失败",
                    desc: res.message,
                    duration: 10
                });
          }
        });
      }
    },
    changePage() {}
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
          width: 120px;
          text-align: right;
          i{
            font-size: 14px;
            font-weight: 700;
            color: #ec0909;
          }
        }
        p{
          padding-left: 120px;
          min-width: 230px;
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