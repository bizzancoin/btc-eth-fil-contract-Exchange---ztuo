<template>
  <div>
    <!-- 待优化 2018年4月16日15:33:35 -->
    <Card>
      <p slot="title">
        包赔设置
        <Button type="primary" size="small" @click="refreshPageManual">
          <Icon type="refresh"></Icon>刷新
        </Button>
      </p>
      <Row class="functionWrapper" style='padding:0px 8px 8px 8px'>
        <Col span="24">
          <div style="float: right" class="clearfix">
            <Button type="error" @click="delSet">删除</Button>
            <Button type="primary"@click="addCoinClick">添加包赔设置</Button>
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
      <p style="font-size:11px;">注意1：设置包赔规则时，包赔时间段不可交叉</p>

      <Modal
          class="auditModel"
          v-model="coinModal"
          title="新增/修改包赔规则"
          @on-ok="submit">
        <ul>
          <li><span><i>*</i>开始时间：</span>
            <p>
              <Input v-model="secondSet.startTime"></Input>
              <span>{{ }}</span>
            </p>
          </li>
          <li><span><i>*</i>结束时间：</span>
            <p>
              <Input v-model="secondSet.endTime"></Input>
              <span>{{ }}</span>
            </p>
          </li>
          <li>
            <span><i>*</i>包赔数量：</span>
            <p> <Input v-model="secondSet.orderNum"></Input> </p>
          </li>
          <li>
            <span><i>*</i>最大比例(小数)：</span>
            <p> <Input v-model="secondSet.limitRate"></Input> </p>
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
import { querySets, addSets, updateSets,delSets } from '@/service/getData'

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
      secondSet: {
        id: 0,
        startTime: "",
        endTime: "",
        orderNum: 0,
        limitRate: 0,
        createTime: "",
        updateTime: ""
      },
      columns: [
        {
          type: 'selection',
          width: 60
        },
        {
          title: '开始时间',
          key:"startTime",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.startTime)
            ]);
          }
        },
        {
          title: '结束时间',
          key:"endTime",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.endTime)
            ]);
          }
        },
        {
          title: "包赔单数",
          key: "orderNum",
          width: 220,
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.orderNum)
            ]);
          }
        },
        {
          title: '最大比例',
          key:"limitRate",
          render: (h, params) => {
            const row = params.row;
            return h("div", {}, [
              h("span", {style:{}}, row.limitRate * 100 + "%")
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
                        this.secondSet = {
                          id:params.row.id,
                          startTime: params.row.startTime,
                          endTime: params.row.endTime,
                          orderNum: params.row.orderNum,
                          limitRate: params.row.limitRate
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
    select(selection) {
      this.selectedArr = selection;
    },
    refreshPageManual(){
      this.ifLoading = true;
      this.refreshdata(this.currentPage);
    },
    refreshdata(pageIndex) {
      querySets({ pageNo: pageIndex, pageSize: 50}).then( res => {
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
      delSets({ ids: delArr })
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
      this.secondSet = {
        startTime: "",
        endTime: "",
        orderNum: 0,
        limitRate: 0,
        createTime: "",
        updateTime: ""
      };
      this.coinModal = true;
    },
    submit(){
      if(this.isAdd) {
        addSets(this.secondSet).then(res => {
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
        updateSets(this.secondSet).then(res => {
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