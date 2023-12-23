<template>
  <div class="nav-rights">
    <div class="nav-right">
      <div class="bill_box_order">
        <div class="order_box">
          <Tabs value="name1" @on-click="showItem">
            <TabPane :label="$t('uc.finance.finance.open')" name="name1">
              <div class="order-table">
                <Table :no-data-text="$t('common.nodata')" :columns="tableColumnsOrder" :data="tableOrder" :loading="loading" :disabled-hover="true"></Table>
                <div style="margin: 10px;overflow: hidden" class="page">
                  <div style="float: right;">
                    <Page v-if="totalPage > 0" :total="totalNum" :current="currentPage" show-total @on-change="changePage" :page-size="pageSize"></Page>
                  </div>
                </div>
              </div>
            </TabPane>
            <TabPane :label="$t('uc.finance.finance.close')" name="name2">
              <div class="order-table">
                <Table :no-data-text="$t('common.nodata')" :columns="tableColumnsOrder" :data="tableOrder" :loading="loading" :disabled-hover="true"></Table>
                <div style="margin: 10px;overflow: hidden" class="page">
                  <div style="float: right;">
                    <Page v-if="totalPage > 0" :total="totalNum" :current="currentPage" show-total @on-change="changePage" :page-size="pageSize"></Page>
                  </div>
                </div>
              </div>
            </TabPane>
          </Tabs>
        </div>

      </div>
    </div>
  </div>
</template>
<script>
export default {
  components: {},
  data() {
    return {
      ordKeyword: "",
      choseBtn: 0,
      whichItem: 1,
      tableOrder: [],
      loading: true,
      totalPage: 0,
      pageSize: 10,
      totalNum: 0,
      currentPage: 1,
      loginmsg: this.$t("common.logintip")
    };
  },
  methods: {
    // 获取历史记录信息
    handleListApproveHistory() {},
    changePage(pageNo) {
      if (pageNo > 0) pageNo = pageNo - 1;
      if (this.whichItem == 1) {
        this.getOrder(0, pageNo);
      } else if (this.whichItem == 2) {
        this.getOrder(1, pageNo);
      }
    },
    getOrder(status, pageNo) {
      this.loading = true;
      this.tableOrder = [];
      let params = {};
      params["status"] = status;
      params["pageNo"] = pageNo;
      params["pageSize"] = this.pageSize;
      this.currentPage = pageNo + 1;
      this.$http.post(this.host + "/second/finance/history", params).then(response => {
        var resp = response.body;
        if (resp.data.content.length > 0) {
          this.tableOrder = resp.data.content;
          this.totalPage = resp.data.totalPages;
          this.totalNum = resp.data.totalElements;
        }
        this.loading = false;
      });
    },
    closeOrder(id){
      this.loading = true;
      let params = {};
      params["orderId"] = id;
      this.$http.post(this.host + "/second/finance/close", params).then(response => {
        var resp = response.body;
        if (resp.code == 0) {
          this.getOrder(0,this.currentPage-1);
          this.$Message.success(this.$t("uc.finance.finance.success"));
        }else {
          this.$Message.error(this.$t("uc.finance.finance.fail"));
        }
        this.loading = false;
      });
    },
    init() {},
    showItem(name) {
      if (name == "name1") {
        this.whichItem = 1;
      } else if (name == "name2") {
        this.whichItem = 2;
      } else if (name == "name3") {
        this.whichItem = 3;
      } else if (name == "name0") {
        this.whichItem = 0;
      } else if (name == "name4") {
        this.whichItem = 4;
      }
      this.changePage(0);
    },
    strpro(str) {
      let newStr = str;
      str = str.slice(1);
      var re = /[\D\d]*/g;
      var str2 = str.replace(re, function(str) {
        var result = "";
        for (var i = 0; i < str.length; i++) {
          result += "*";
        }
        return result;
      });
      return newStr.slice(0, 1) + str2;
    }
  },
  created() {
    this.changePage(0);
  },
  mounted() {
    // this.init();
  },
  computed: {
    tableColumnsOrder() {
      let self = this;
      let columns = [];
      columns.push({
        title: "#",
        key: "id",
        minWidth: 20,
        align: "center"
      });
      columns.push({
        title: this.$t("uc.finance.finance.coin"),
        key: "coinSymbol",
        align: "center"
      });
      columns.push({
        title: this.$t("uc.otcorder.amount"),
        key: "num",
        align: "center"
      });
      columns.push({
        title: this.$t("uc.finance.finance.earn"),
        key: "earnNum",
        align: "center"
      });
      columns.push({
        title: this.$t("uc.finance.finance.updateTime"),
        key: "updateTime",
        minWidth: 90,
        align: "center"
      });
      columns.push({
        title: this.$t("uc.otcorder.created"),
        key: "createTime",
        minWidth: 90,
        align: "center"
      });
      if(this.whichItem == 1){
        columns.push({
          title: self.$t("exchange.action"),
          key: "operate",
          width: 110,
          align: "center",
          render: (h, params) => {
            return h(
                "Button",
                {
                  props: {
                    size: "small"
                  },
                  style: {
                    border: "1px solid #f0ac19",
                    color: "#f1ac19",
                    "line-height": "1.2",
                    "border-radius": "10px"
                  },
                  on: {
                    click: () => {
                      this.closeOrder(params.row.id);
                    }
                  }
                },
                self.$t("exchange.undo")
            );
          }
        });
      }

      return columns;
    }
  }
};
</script>
<style scoped>
.bill_box_order {
  width: 99%;
  padding-left: 20px;
  height: auto;
  margin: 0 auto;
  /* overflow: hidden; */
}

.order_box {
  text-align: left;
}

.order_box a {
  color: #0b0d1b;
  font-size: 16px;
  padding: 0 30px;
  cursor: pointer;
  text-decoration: none;
  text-align: center;
  line-height: 54px;
  display: inline-block;
}

.order_box .active {
  border-bottom: 2px solid #00b5f6;
}

.order_box .search {
  position: absolute;
  width: 300px;
  height: 32px;
  top: 12px;
  right: 0;
  display: flex;
}
</style>

<style lang="scss">
.bill_box_order {
  .order_box {
    .ivu-tabs {
      // overflow:initial;
      color:#fff;
      .ivu-tabs-content.ivu-tabs-content-animated {
        .ivu-tabs-tabpane {
          .ivu-table-wrapper {
            border: none;
            box-shadow: none;
            a {
              color: #f0a70a;
            }
          }
        }
      }
      .ivu-tabs-bar {
        border-color:#273742 !important;
        .ivu-tabs-nav-container {
          .ivu-tabs-nav-scroll {
            .ivu-tabs-ink-bar.ivu-tabs-ink-bar-animated {
              background-color: #f0a70a;
            }
            .ivu-tabs-tab.ivu-tabs-tab-active.ivu-tabs-tab-focused {
              color: #f0a70a;
              &:hover {
                color: #f0a70a;
              }
            }
            .ivu-tabs-tab {
              &:hover {
                color: #f0a70a;
              }
            }
          }
        }
      }
      .ivu-tabs-content {
        .ivu-tabs-tabpane {
          .ivu-table-header,
          .ivu-table-body {
            table {
              width: 100% !important;
              thead {
                .ivu-table-cell {
                  padding: 0;
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
