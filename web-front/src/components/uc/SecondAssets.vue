<template>
  <div class="nav-rights">
    <div class="nav-right col-xs-12 col-md-10 padding-right-clear" v-if="xsShow">
      <div class="bill_box rightarea padding-right-clear" style="padding-left: 5px;">
        <div class="shaow">
          <div class="money_table" style="text-align: left;">
            <div style="width: 100%;">
              <Input style="" class="search" search :placeholder="$t('common.searchplaceholder')" @on-change="seachInputChange" v-model="searchKey"/>

              <Button type="primary" @click="onTransferClick" style="padding: 2px 15px;height: 30px; margin-bottom: 10px; letter-spacing:2px;color:#f0ac19;background-color:transparent;border:1px solid #f0ac19;">{{$t('uc.finance.swap.transfor')}}</Button>
            </div>
            <Table :no-data-text="$t('common.nodata')" :columns="tableColumnsMoney" :data="tableMoneyShow" :loading="loading" :disabled-hover="true"></Table>
          </div>
        </div>
      </div>
    </div>
    <div class="nav-right col-xs-12 col-md-10 padding-right-clear" v-else>
      <div class="bill_box rightarea padding-right-clear">
        <div class="shaow">
          <div class="money_table">
            <div style="width: 100%;height: 50px;">
<!--              <div style="float:left;letter-spacing:1px;padding-top: 5px;">-->
<!--                <span style="font-size:12px;color:#828ea1;">{{$t('uc.finance.swap.totalassets')}}</span>-->
<!--                <span style="font-size: 18px;color:#D8E1EB;">${{totalUSDT}}</span>-->
<!--                <span style="font-size:10px;color:#828ea1;margin-left: 5px;"> ≈ ¥{{totalCny}}</span>-->
<!--              </div>-->
              <Input style="float:right;" class="search" search :placeholder="$t('common.searchplaceholder')" @on-change="seachInputChange" v-model="searchKey"/>

              <Button type="primary" @click="onTransferClick" style="padding: 6px 15px;margin-right:30px;letter-spacing:2px;color:#f0ac19;background-color:transparent;border:1px solid #f0ac19;float:right;">{{$t('uc.finance.swap.transfor')}}</Button>
            </div>
            <Table :no-data-text="$t('common.nodata')" :columns="tableColumnsMoney" :data="tableMoneyShow" :loading="loading" :disabled-hover="true"></Table>
          </div>
        </div>
      </div>
    </div>


    <Modal v-model="transferModal" :title="$t('uc.finance.swap.transfor')">

      <div style="width: 100%; min-height: 32px;margin-top: 15px;">
        <div style="width: 45%;display: inline-flex;height:32px;line-height: 32px;float:left;">
          <Select v-model="walletOne" style="width: 450px;" :placeholder="$t('uc.finance.swap.currencyaccount')">
            <Option v-for="item in walletOneList" :value="item" :key="item">{{ item }}</Option>
          </Select>
        </div>

        <div v-if="transferDirection == 1" @click="changeTo(2)" style="width: 10%;float: left;text-align: center;font-size:18px;height: 30px; line-height:30px;font-weight: bold;color:"> <Tooltip :content="$t('uc.finance.swap.clickchange')"><Icon style="font-weight:bold;color:#19be6b;" type="md-arrow-forward" /></Tooltip> </div>

        <div v-if="transferDirection == 2" @click="changeTo(1)" style="width: 10%;float: left;text-align: center;font-size:18px;height: 30px; line-height:30px;font-weight: bold;color:"> <Tooltip :content="$t('uc.finance.swap.clickchange')"><Icon style="font-weight:bold;color:#19be6b;" type="md-arrow-back" /></Tooltip> </div>

        <div style="width: 45%;display: inline-flex;height:32px;line-height: 32px;float: right;">
          <Select v-model="walletTwo" style="width: 450px;" :placeholder="$t('uc.finance.second.secondaccount')" @on-change="onChangeTwo">
            <Option v-for="item in tradeCoins" :value="item" :key="item">{{ item }}{{$t("uc.finance.second.swap")}}</Option>
          </Select>
        </div>
      </div>
      <div style="width: 100%; min-height: 20px;margin-top: 0px;font-size: 10px;color:rgb(97, 104, 138);">
        <div style="width: 50%;height:20px;line-height: 20px;float:left;text-align: left;">
          {{$t('uc.finance.swap.avaamount')}}：{{assetsWallet.balance | fixed2}}
        </div>
        <div style="width: 50%;height:20px;line-height: 20px;float: right;text-align: right;">
          {{$t('uc.finance.swap.avaamount')}}：{{swapWallet.balance | fixed2}}
        </div>
      </div>
      <p style="margin-top: 25px;">{{$t('uc.finance.swap.inputtransferamount')}}:
        <InputNumber v-if="xsShow" style="width: 60%;margin-left:10px;" type="text" v-model="transferAmount" :placeholder="$t('uc.finance.swap.inputtransferamount')"></InputNumber>
        <InputNumber v-else style="width: 330px;margin-left:15px;" type="text" v-model="transferAmount" :placeholder="$t('uc.finance.swap.inputtransferamount')"></InputNumber>
        <span v-if="xsShow" class="trans-all-btn" style="margin-left:10px;" @click="onTransAll">{{$t('uc.finance.swap.all')}}</span>
        <span v-else class="trans-all-btn" @click="onTransAll">{{$t('uc.finance.swap.all')}}</span>
      </p>

      <div slot="footer">
        <Button size="large" @click="transferModal = false">{{$t("common.close")}}</Button>
        <Button type="primary" size="large" @click="confirmOk">{{$t("uc.finance.swap.oktransfer")}}</Button>
      </div>
    </Modal>
  </div>
</template>
<script>
export default {
  components: {},
  data() {
    return {
      xsShow: false,//手机显示
      activeWidth: window.innerWidth,
      loginmsg: this.$t("common.logintip"),
      loading: true,
      ordKeyword: "",
      tableMoney: [],
      tradeCoins:[],
      tableMoneyShow: [],
      searchKey: "",
      transferModal: false,
      transferDirection: 1,
      walletOne: null,
      walletTwo: "USDT",
      transferAmount: 0,
      predictAmount: 0,
      walletTwoList: [],
      walletOneList: [this.$t('uc.finance.swap.currencyaccount')],
      assetsWallet: {
        id: 0,
        balance: 0
      },
      swapWallet: {
        id: 0,
        balance: 0
      },
    };
  },
  methods: {
    seachInputChange(){
      this.tableMoneyShow = this.tableMoney.filter(item => item["symbol"].indexOf(this.searchKey) == 0);
    },
    getTradeCoins(){
      var that = this;
      let params = {};
      this.$http.post(this.host + "/second/order/coins", params).then(response => {
        var resp = response.body;
        if (resp.code == 0) {
          this.tradeCoins = resp.data;
        } else {
          this.$Notice.error({
            title: that.$t("exchange.tip"),
            desc: resp.message
          });
        }
      });
    },
    getMoney() {
      //获取
      this.$http.post(this.host + "/second/wallet/list").then(response => {
        var resp = response.body;
        if (resp.code == 0) {
          this.tableMoney = resp.data;
          // for (let i = 0; i < this.tableMoney.length; i++) {
          //   this.tableMoney[i]["symbol"] = this.tableMoney[i].contractCoin.symbol;
          //   // 如果是全仓并且收益小于0
          //   // if(this.tableMoney[i].usdtTotalProfitAndLoss < 0 && this.tableMoney[i].usdtPattern == "CROSSED") {
          //   //   this.tableMoney[i]["avaBalance"] = this.tableMoney[i].usdtBalance + usdtTotalProfitAndLoss;
          //   // }else{
          //   //   this.tableMoney[i]["avaBalance"] = this.tableMoney[i].usdtBalance;
          //   // }
          //
          //   if(this.swapWallet.id == this.tableMoney[i].id) {
          //     this.swapWallet = this.tableMoney[i];
          //   }
          // }
          this.loading = false;
          this.tableMoneyShow = this.tableMoney;
          this.onChangeTwo();
        } else {
          this.$Message.error(this.loginmsg);
        }
      });
    },
    getAssets() {
      //获取
      this.$http.post(this.host + "/uc/asset/wallet/"+this.walletTwo).then(response => {
        var resp = response.body;
        if (resp.code == 0) {
          this.assetsWallet = resp.data;
        } else {
          this.$Message.error(this.loginmsg);
        }
      });
    },
    onTransferClick() {
      this.transferModal = true;
    },
    changeTo(val) {
      this.transferDirection = val;
      this.transferAmount = 0.00;
    },
    confirmOk() {
      if(this.walletTwo == null || this.walletTwo == "") {
        this.$Message.error(this.$t('uc.finance.swap.pleaseselectwallet'));
        return;
      }
      if(this.transferAmount <= 0 || this.transferAmount == "" || this.transferAmount == undefined) {
        this.$Message.error(this.$t('uc.finance.swap.pleaseinputamount'));
        return;
      }
      let params = {
        unit: this.walletTwo,
        from: this.transferDirection == 1 ? 0 : 2,
        to: this.transferDirection == 1 ? 2 : 0,
        amount: this.transferAmount
      };

      this.$http.post(this.host + "/second/wallet/trans", params).then(response => {
        var resp = response.body;
        if (resp.code == 0) {
          console.log(resp.data);
          this.getMoney();
          this.onChangeTwo();
        } else {
          this.$Message.error(this.loginmsg);
        }
      });

      this.transferModal = false;
    },
    onChangeTwo(){
      console.log(this.walletTwo);
      this.getAssets();
      this.swapWallet= {
        id: 0,
        balance: 0
      };
      for (let i = 0; i < this.tableMoney.length; i++) {
        if(this.tableMoney[i].coin.unit == this.walletTwo) {
          this.swapWallet = this.tableMoney[i];
        }
      }
    },
    onTransAll() {
      if(this.transferDirection == 1) {
        this.transferAmount = new Number(this.assetsWallet.balance).toFixed(4) == 0? 0:this.assetsWallet.balance;
      }else{
        this.transferAmount = this.swapWallet.balance;
      }
    }
  },
  created() {
    this.getMoney();
    this.getTradeCoins();
  },
  watch: {
      activeWidth: {

        handler(val, oldVal) {
          if (val <= 416) {
            this.xsShow = true;
          } else {
            this.xsShow = false;
          }
        },
        deep: true,//true 深度监听
        immediate: true,
      }
    },
  filters:{
    fixed2: function(value){
      return value.toFixed(2);
    }
  },
  computed: {
    // totalUSDT() {
    //   let usdtTotal = 0;
    //   for (let i = 0; i < this.tableMoney.length; i++) {
    //     usdtTotal +=  this.tableMoney[i].usdtBalance + this.tableMoney[i].usdtFrozenBalance + this.tableMoney[i].usdtBuyPrincipalAmount + this.tableMoney[i].usdtSellPrincipalAmount + this.tableMoney[i].usdtTotalProfitAndLoss;
    //   }
    //   return usdtTotal.toFixed(2);
    // },
    // totalCny(){
    //   let cnyTotal = 0;
    //   for (let i = 0; i < this.tableMoney.length; i++) {
    //     var sumV =  this.tableMoney[i].usdtBalance + this.tableMoney[i].usdtFrozenBalance + this.tableMoney[i].usdtBuyPrincipalAmount + this.tableMoney[i].usdtSellPrincipalAmount + this.tableMoney[i].usdtTotalProfitAndLoss;
    //
    //     cnyTotal += sumV * this.tableMoney[i].contractCoin.usdtRate;
    //   }
    //
    //   return cnyTotal.toFixed(2);
    // },
    tableColumnsMoney() {
      let self = this;
      let columns = [];
      columns.push({
        title: this.$t("uc.finance.swap.swaptype"),
        align: "center",
        render(h, params) {
          return h(
              "span",
              {
                attrs: {
                  title: params.row.coin.unit
                }
              },
              params.row.coin.unit + " " + self.$t("uc.finance.second.swap"),
          );
        }
      });
      columns.push({
        title: this.$t("uc.finance.swap.avabalance"),
        key: "usdtBalance",
        align: "center",
        render(h, params) {
          return h(
              "span",
              {
                attrs: {
                  title: params.row.balance
                }
              },
              self.toFloor(params.row.balance.toFixed(4) || "0")
          );
        }
      });
      columns.push({
        title: this.$t("uc.finance.swap.frozenbalance"),
        align: "center",
        render(h, params) {
          return h(
              "span",
              {
                attrs: {
                  title: params.row.frozenBalance
                }
              },
              self.toFloor(params.row.frozenBalance.toFixed(4) || "0")
          );
        }
      });
      return columns;
    }
  }
};
</script>
<style lang="scss">
.nav-right {
  .rightarea.bill_box {
    .shaow {
      padding: 5px;
    }
    .money_table {
      .search{
        width: 200px;
        margin-bottom: 10px;
      }
      .ivu-table-wrapper {
        .ivu-table-header{
          background: #27313e;
          th{
            color: #fff;
          }
        }
        .ivu-table-body {
          td {
            color: #fff;
            .ivu-table-cell {
              padding: 10px 10px;
              p .ivu-btn {
                background: transparent;
                height: 25px;
                padding: 0 0px;
                border-radius: 0;
                span {
                  display: inline-block;
                  line-height: 20px;
                  font-size: 12px;
                  padding: 0 15px;
                  letter-spacing: 1px;
                }
              }
              p .ivu-btn.ivu-btn-info {
                border: 1px solid #f0ac19;
                span {
                  color: #f0ac19;
                }
              }
              p .ivu-btn.ivu-btn-error {
                border: 1px solid #f15057;
                span {
                  color: #f15057;

                }
              }
              p .ivu-btn.ivu-btn-primary {
                border: 1px solid #00b275;
                border: 1px solid #00b275;
                span {
                  color: #00b275;
                }
              }
              p .ivu-btn.ivu-btn-default {
                border: 1px solid #2c384f;
                background: #222c3e;
                span {
                  color: #54637a;
                }
              }
            }
          }
        }
      }
    }
  }
}
</style>

<style scoped lang="scss">
.nav-right {
  height: auto;
  overflow: hidden;
  padding: 0 0 0 15px;
  .rightarea.bill_box {
    padding-left: 15px;
    width: 100%;
    height: auto;
    overflow: hidden;
  }
}

.demo-spin-icon-load{
  animation: ani-demo-spin 1s linear infinite;
}
@media screen and (max-width:768px){
  .search{
    display: none;
  }
}
.trans-all-btn{
  display:inline-block;margin-left: 20px;font-weight: bold;color:#f0ac19;background-color:transparent;
  &:hover{
    cursor: pointer;
  }
}
</style>
