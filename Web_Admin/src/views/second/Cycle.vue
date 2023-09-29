<template>
  <div>
    <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        周期设置
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div style="float: right" class="clearfix">
            <Button type="error" @click="delSet">删除</Button>
            <Button type="primary"@click="addCoinClick">添加周期设置</Button>
          </div>
        </Col>
      </Row>
      <Table
          border
          :columns="columns"
          :data="coinList"
          @on-selection-change="select"
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
          title="新增/修改周期设置"
          @on-ok="submit">
        <ul>
          <li><span><i>*</i>周期赔率：</span>
            <p>
              <Input v-model="secondCycle.cycleRate"></Input>
              <span>{{ }}</span>
            </p>
          </li>
          <li><span><i>*</i>周期时长(秒)：</span>
            <p>
              <Input v-model="secondCycle.cycleLength"></Input>
              <span>{{ }}</span>
            </p>
          </li>
          <li>
            <span><i>*</i>最大数量：</span>
            <p> <Input v-model="secondCycle.maxAmount"></Input> </p>
          </li>
          <li>
            <span><i>*</i>最小数量：</span>
            <p> <Input v-model="secondCycle.minAmount"></Input> </p>
          </li>
        </ul>
      </Modal>

      <!-- 是否删除 -->
      <Modal
          v-model="ifDelete"
          title="删除"
          @on-ok="confirmDel"
          @on-cancel="cancelDel">
        <p>是否删除已选择的{{ selectedArr.length }}项</p>
      </Modal>

    </Card>
  </div>
</template>


<script>
import dtime from 'time-formater'
import { queryCycles, addCycles, updateCycles,delCycles } from '@/service/getData'

export default {
  data() {
    return {
      ifLoading: true,
      ifDelete: false,
      pageNum: 1,
      currentPage: 1,
      coinModal: false,
      isAdd: true,
      selectedArr: [],
      secondCycle: {
        id: 0,
        cycleRate: "",
        cycleLength: "",
        minAmount: 0,
        maxAmount: 0,
        createTime: "",
        updateTime: ""
      },
      columns: [
        {
          type: 'selection',
          width: 60
        },
        {
          title: '周期赔率',
          key:"cycleRate",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.cycleRate)
            ]);
          }
        },
        {
          title: '周期时长（秒）',
          key:"cycleLength",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.cycleLength)
            ]);
          }
        },
        {
          title: "最大数量",
          key: "maxAmount",
          width: 220,
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.maxAmount)
            ]);
          }
        },
        {
          title: '最小数量',
          key:"minAmount",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.minAmount)
            ]);
          }
        },
        {
          title: "创建时间",
          key: "createTime"
        },
        {
          title: "修改时间",
          key: "updateTime"
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
                        this.secondCycle = {
                          id:params.row.id,
                          cycleRate: params.row.cycleRate,
                          cycleLength: params.row.cycleLength,
                          maxAmount: params.row.maxAmount,
                          minAmount: params.row.minAmount
                        };
                        console.dir(this.secondCycle);
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
    select(selection) {
      this.selectedArr = selection;
    },
    refreshPageManual(){
      this.ifLoading = true;
      this.refreshdata(this.currentPage);
    },
    refreshdata(pageIndex) {
      queryCycles({ pageNo: pageIndex, pageSize: 50}).then( res => {
        this.coinList = res.data.content;
        this.pageNum = res.data.totalElements;
        this.ifLoading = false;
      });
    },
    confirmDel () {
      let delArr = [];
      this.selectedArr.forEach( item => {
        delArr.push(item.id);
      })
      delCycles({ ids: delArr })
          .then( res => {
            if(!res.code) {
              this.refreshdata(1);
              this.$Message.success('删除成功!');
            }else{
              this.$Message.error('删除失败!');
            }
          })
    },
    cancelDel () {
      this.$Message.success('已取消！');
    },
    delSet() {
      if(!!this.selectedArr.length) {
        this.ifDelete = true;
      }else{
        this.$Message.warning('请选择需要删除的内容！');
      }
    },
    addCoinClick(){
      this.isAdd = true;
      this.secondCycle = {
        cycleRate: "",
        cycleLength: "",
        minAmount: 0,
        maxAmount: 0,
      };
      this.coinModal = true;
    },
    submit(){
      if(this.isAdd) {
        addCycles(this.secondCycle).then(res => {
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
        updateCycles(this.secondCycle).then(res => {
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