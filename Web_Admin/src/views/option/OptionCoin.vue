<template>
 <div>
	 <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
			<p slot="title">
			  期权合约交易对
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
      <p style="font-size:11px;">注意1：因实时合约行情取自火币，因此，新建交易对时，请确认该交易对在火币上存在该交易对</p>
      <p style="font-size:11px;">注意2：【初始买涨奖池金额】/【初始买跌奖池金额】即当没有用户参与时，平台指定奖池一定的初始奖池数量</p>

      <Modal
          class="auditModel"
          v-model="coinModal"
          title="新增/修改交易对"
          @on-ok="submit">
          <ul>
            <li><span><i>*</i>交易对：</span>
              <p>
                <Input v-model="optionCoin.symbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>合约名称：</span>
              <p>
                <Input v-model="optionCoin.name"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>币种：</span>
              <p>
                <Input v-model="optionCoin.coinSymbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>基础量价币种：</span>
              <p>
                <Input v-model="optionCoin.baseSymbol" :disabled="!isAdd"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>排序：</span>
              <p>
                <Input v-model="optionCoin.sort"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>交易币小数精度：</span>
              <p>
                <Input v-model="optionCoin.coinScale"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>基币小数精度：</span>
              <p>
                <Input v-model="optionCoin.baseCoinScale"></Input>
                <span>{{ }}</span>
              </p>
            </li>
            <li><span><i>*</i>启用：</span>
              <p>
                <RadioGroup v-model="optionCoin.enable">
                  <Radio label="1"><em>启用</em></Radio>
                  <Radio label="2"><em>禁止</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>显示：</span>
              <p>
                <RadioGroup v-model="optionCoin.visible">
                  <Radio label="1"><em>是</em></Radio>
                  <Radio label="2"><em>否</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>平局处理：</span>
              <p>
                <RadioGroup v-model="optionCoin.tiedType">
                  <Radio label="1"><em>退回资金</em></Radio>
                  <Radio label="2"><em>平台通吃</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>允许看涨：</span>
              <p>
                <RadioGroup v-model="optionCoin.enableBuy">
                  <Radio label="1"><em>是</em></Radio>
                  <Radio label="0"><em>否</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li><span><i>*</i>允许看跌：</span>
              <p>
                <RadioGroup v-model="optionCoin.enableSell">
                  <Radio label="1"><em>是</em></Radio>
                  <Radio label="0"><em>否</em></Radio>
                </RadioGroup>
              </p>
            </li>
            <li>
                <span><i>*</i>允许投注金额：</span>
                <p> <Input v-model="optionCoin.amount"></Input> </p>
            </li>
            <li>
                <span><i>*</i>开仓手续费：</span>
                <p> <Input v-model="optionCoin.feePercent"></Input> </p>
            </li>
            <li>
                <span><i>*</i>赢家抽水费：</span>
                <p> <Input v-model="optionCoin.winFeePercent"></Input> </p>
            </li>
			<li>
			    <span><i>*</i>赔率：</span>
			    <p> <Input v-model="optionCoin.oods"></Input> </p>
			</li>
            <!-- <li>
                <span><i>*</i>初始买涨奖池金额：</span>
                <p> <Input v-model="optionCoin.initBuyReward"></Input> </p>
            </li>
            <li>
                <span><i>*</i>初始买跌奖池金额：</span>
                <p> <Input v-model="optionCoin.initSellReward"></Input> </p>
            </li> -->
            <li>
                <span><i>*</i>投注时间周期(秒)：</span>
                <p> <Input v-model="optionCoin.openTimeGap"></Input> </p>
            </li>
            <li>
                <span><i>*</i>开奖时间周期(秒)：</span>
                <p> <Input v-model="optionCoin.closeTimeGap"></Input> </p>
            </li>
          </ul>
      </Modal>
    </Card>
 </div>
</template>


 <script>
import dtime from 'time-formater'
import { queryOptionCoinList, addOptionCoin, alterOptionCoin } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      coinModal: false,
      isAdd: true,
      optionCoin: {
        symbol: "",
        name: "",
        coinSymbol: "",
        baseSymbol: "",
        sort: 0,
		oods: 0,
        coinScale: 4,
        baseCoinScale: 4,
        enable: "1",
        visible: "1",
        tiedType: "1",
        enableBuy: "1",
        enableSell: "1",
        amount: "10,20,50,100,200,500,1000,2000",
        feePercent: 0,
        winFeePercent: 0.001,
        initBuyReward: 0,
        initSellReward: 0,
        openTimeGap: 300,
        closeTimeGap: 300
      },
      columns: [
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
          title: '当前期数',
          key:"maxOptionNo",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, "第 " + row.maxOptionNo + " 期")
              ]);
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
          title: "看涨",
          width:65,
          key: "enableBuy",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableBuy == 1 ? "是" : "否";
            if(row.enableBuy == 1) {
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
          title: "看跌",
          width:65,
          key: "enableSell",
          render: (h, params) => {
            const row = params.row;
            const txt = row.enableSell == 1 ? "是" : "否";
            if(row.enableSell == 1) {
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
          title: "平局处理",
          width: 90,
          key: "tiedType",
          render: (h, params) => {
            const row = params.row;
            const txt = row.tiedType == 1 ? "退回投注" : "平台通吃";
            return h("div", {
                style:{
                  textAlign: "center"
                }
              }, [
                h("span", {style:{fontSize:"10px"}}, txt)
              ]);
          }
        },
        {
          title: "允许投注金额",
          key: "amount",
          width: 220,
          render: (h, params) => {
            const row = params.row;
            return h("div", {
                style:{
                  textAlign: "left"
                }
              }, [
                h("span", {style:{fontWeight:"bold"}}, row.amount)
              ]);
          }
        },
        {
          title: '开仓手续费',
          key:"feePercent",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.feePercent * 1000 + "‰")
              ]);
          }
        },
        {
          title: '赢家抽水',
          key:"winFeePercent",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.winFeePercent * 1000 + "‰")
              ]);
          }
        },
        {
          title: '赔率',
          key:"oods"
        },
        // {
        //   title: '初始买跌奖池',
        //   key:"initSellReward"
        // },
        {
          title: '盈利',
          key:"totalProfit"
        },
        {
          title: '下注时间',
          key:"openTimeGap",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{fontWeight:"bold"}}, row.openTimeGap + "秒")
              ]);
          }
        },
        {
          title: '开奖时间',
          key:"closeTimeGap",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{fontWeight:"bold"}}, row.closeTimeGap + "秒")
              ]);
          }
        },
        {
          title: "操作",
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
                      this.optionCoin = {
                        symbol: params.row.symbol,
                        name: params.row.name,
                        coinSymbol: params.row.coinSymbol,
                        baseSymbol: params.row.baseSymbol,
                        sort: params.row.sort,
						oods: params.row.oods,
                        coinScale: params.row.coinScale,
                        baseCoinScale: params.row.baseCoinScale,
                        enable: params.row.enable+"",
                        visible: params.row.visible+"",
                        tiedType: params.row.tiedType+"",
                        enableBuy: params.row.enableBuy+"",
                        enableSell: params.row.enableSell+"",
                        amount: params.row.amount,
                        feePercent: params.row.feePercent,
                        winFeePercent: params.row.winFeePercent,
                        initBuyReward: params.row.initBuyReward,
                        initSellReward: params.row.initSellReward,
                        openTimeGap: params.row.openTimeGap,
                        closeTimeGap: params.row.closeTimeGap
                      };
                      this.coinModal = true;
                    }
                  }
                },
                "修改"
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
      queryOptionCoinList({ pageNo: pageIndex, pageSize: 50}).then( res => {
        this.coinList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    addCoinClick(){
      this.isAdd = true;
      this.optionCoin = {
        symbol: "",
        name: "",
        coinSymbol: "",
        baseSymbol: "",
        sort: 0,
		oods: 0,
        coinScale: 4,
        baseCoinScale: 4,
        enable: "1",
        visible: "1",
        tiedType: "1",
        enableBuy: "1",
        enableSell: "1",
        amount: "10,20,50,100,200,500,1000,2000",
        feePercent: 0,
        winFeePercent: 0.001,
        initBuyReward: 0,
        initSellReward: 0,
        openTimeGap: 300,
        closeTimeGap: 300
      };
      this.coinModal = true;
    },
    submit(){
      if(this.isAdd) {
        addOptionCoin(this.optionCoin).then(res => {
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
        alterOptionCoin(this.optionCoin).then(res => {
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