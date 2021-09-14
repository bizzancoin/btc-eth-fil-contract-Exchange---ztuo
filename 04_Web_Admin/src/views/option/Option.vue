<template>
 <div>
   <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        期权合约每期管理
        <Button type="primary" size="small" @click="refreshData">
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
                  <Input placeholder="合约期数" v-model="searchForm.optionNo" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="最低看涨人数" v-model="searchForm.totalBuyCount" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="最低看跌人数" v-model="searchForm.totalSellCount" /></Input>
              </div>
              <div class="poptip">
                  <Input placeholder="最低合约收益" v-model="searchForm.totalPl" /></Input>
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
        :data="optionList"
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
import { queryOptionCoinList, queryOptionList,setPresetPrice } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      pageNum: 1,
      currentPage: 1,
      optionList: [],
      coinList: [],
      searchForm: {
        symbol: null,
        optionNo: null,
        totalBuyCount: null,
        totalSellCount: null,
        totalPl: null,
        pageNo: 1,
        pageSize: 10
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
          title: '期数',
          key:"optionNo",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, "第 " + row.optionNo + " 期")
              ]);
          }
        },
        {
          title: '买涨奖池/人数',
          key:"totalBuy",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.totalBuy + "/" + row.totalBuyCount)
              ]);
          }
        },
        {
          title: '买跌奖池/人数',
          key:"totalSell",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.totalSell + "/" + row.totalSellCount)
              ]);
          }
        },
        {
          title: '开盘时间',
          key:"openTime",
          render: (h, params) => {
            const row = params.row;
            var start = dtime(row.openTime).format('YYYY-MM-DD HH:mm');
            if(row.openTime == null){
              start = "-";
            }
            return h("div", {}, [
                h("span", {style:{}}, start)
              ]);
          }
        },
        {
          title: '开盘价格',
          key:"openPrice",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.openPrice)
              ]);
          }
        },
        {
          title: '收盘时间',
          key:"closeTime",
          render: (h, params) => {
            const row = params.row;
            var start = dtime(row.closeTime).format('YYYY-MM-DD HH:mm');
            if(row.closeTime == null){
              start = "-";
            }
            return h("div", {}, [
                h("span", {style:{}}, start)
              ]);
          }
        },
        {
          title: '收盘价格',
          key:"closePrice",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.closePrice)
              ]);
          }
        },
		{
		  title: '预设价格',
		  key:"presetPrice",
		  render: (h, params) => {
		    const row = params.row;
		    return h("div", {}, [
		        h("span", {style:{}}, row.presetPrice)
		      ]);
		  }
		},
        {
          title: '盈利',
          key:"totalPl",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
                h("span", {style:{}}, row.totalPl)
              ]);
          }
        },
        {
          title: "状态",
          key: "status",
          render: (h, params) => {
            const row = params.row;
            var txt = "投注中";
            if(row.status == "OPENING") txt = "开奖中";
            if(row.status == "CLOSED") txt = "已开奖";
            
            return h("span", {}, txt);
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
              txt = "-";
              color = "#999";
            }
            if(row.result == "WIN") {
              txt = "涨";
              color = "#42b983";
            }
            if(row.result == "LOSE") {
              txt = "跌";
              color = "#FF0000";
            }
            if(row.result == "TIED") {
              txt = "平";
              color = "#999";
            }
            return h("span", {
              style:{
                  color:color
                }
            }, txt);
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
		      params.row.status == "OPENING" ? h(
		        "Button",
		        {
		          props: {type: "error",size: "small"},
		          style: {marginRight: "5px"},
		          on: {
		            click: () => {
		              this.presetPrice = "";
		              this.$Modal.confirm({
		                  render: (h) => {
		                      return h('Input', {
		                          props: {
		                              value: this.presetPrice,
		                              autofocus: true,
									  type: 'number',
		                              placeholder: '请输预设价格'
		                          },
		                          on: {
		                              input: (val) => {
		                                  this.presetPrice = val;
		                              }
		                          }
		                      })
		                  },
		                onOk: () => { 
						  let subData = {
							id: params.row.id,
							presetPrice: this.presetPrice
						  }
						  
						  this.$Loading.start();
						  setPresetPrice(subData).then(res => {
							if(!res.code) {
							  this.$Notice.success({
									  title: "操作成功！",
									  desc: res.message,
									  duration: 10
								  });
							params.row.presetPrice=this.presetPrice;
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
      ]
    };
  },
  methods: {
    selected(){

    },
    getCoinList(pageIndex) {
      queryOptionCoinList({ pageNo: pageIndex, pageSize: 50}).then( res => {
        this.coinList = res.data.content;
        this.ifLoading = false;
      });
    },
    addCoinClick(){

    },
    changePage(pageIndex) {
      this.searchForm.pageNo = pageIndex;
      this.refreshData(this.searchForm);
    },
    refreshData(form) {
      queryOptionList(form).then( res => {
        this.optionList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    search() {
      this.searchForm.pageNo = 1;
      this.refreshData(this.searchForm);
    }
  },
  created() {
    this.getCoinList(1);
    this.refreshData(this.searchForm);
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