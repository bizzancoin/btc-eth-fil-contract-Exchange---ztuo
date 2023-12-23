<template>
  <div class="invite">
    <div class="bz_container">
      <div class="header">
        <div class="invite-title" v-if="width > 768">
          <!-- title -->
          <div class="my-link-text">{{ $t('invite.myinvitelink') }}：</div>
          <div class="my-link-content">{{ myInfo.inviteLink }}</div>
          <a
            class="copy-button"
            v-clipboard:copy="myInfo.inviteLink"
            v-clipboard:success="onCopy"
            v-clipboard:error="onError"
            href="javascript:;"
            >{{ $t('invite.copy') }}</a
          >
        </div>
        <!-- content -->
        <div class="invite-detail" v-if="width > 768">
          <div class="item">
            <p class="i-v">{{ myInfo.levelone }}</p>
            <p class="i-t">{{ $t('invite.mylevelone') }}</p>
          </div>
          <div class="item">
            <p class="i-v">{{ myInfo.leveltwo }}</p>
            <p class="i-t">{{ $t('invite.myleveltwo') }}</p>
          </div>
          <!-- <div class="item">
            <p class="i-v">{{ myInfo.commission }}</p>
            <p class="i-t">{{ $t('invite.mycommission') }}</p>
          </div> -->
          <div class="item">
            <p class="i-v">{{ myInfo.extrareward }}</p>
            <p class="i-t">{{ $t('invite.extrareward') }}</p>
          </div>
          <div class="item">
            <p class="i-v">{{ myInfo.partnerlevel }}</p>
            <p class="i-t">{{ $t('invite.partnerlevel') }}</p>
          </div>
        </div>
        <!-- 二维码 -->
        <div class="qr-code" style="background:#FFF;padding: 5px 5px;" v-if="width > 768">
          <qriously :value="myInfo.inviteLink" :size="140" foreground="#000" />
        </div>
        <!-- 移动端 -->
        <div class="header-web" v-if="width < 768">
          <h2>{{ $t('invite.myinvitelink') }}</h2>
          <h3>{{ myInfo.inviteLink }}</h3>
          <ul class="header-web-detail" v-if="width < 768">
            <li class="header-item">
              <p class="i-v">{{ myInfo.levelone }}</p>
              <p class="i-t">{{ $t('invite.mylevelone') }}</p>
            </li>
            <li class="header-item">
              <p class="i-v">{{ myInfo.leveltwo }}</p>
              <p class="i-t">{{ $t('invite.myleveltwo') }}</p>
            </li>
            <li class="header-item">
              <p class="i-v">{{ myInfo.commission }}</p>
              <p class="i-t">{{ $t('invite.mycommission') }}</p>
            </li>
            <li class="header-item">
              <p class="i-v">{{ myInfo.extrareward }}</p>
              <p class="i-t">{{ $t('invite.extrareward') }}</p>
            </li>
            <li class="header-item">
              <p class="i-v">{{ myInfo.partnerlevel }}</p>
              <p class="i-t">{{ $t('invite.partnerlevel') }}</p>
            </li>
          </ul>
          <Button
            class="copy-button"
            type="success"
            size="large"
            v-clipboard:copy="myInfo.inviteLink"
            v-clipboard:success="onCopy"
            v-clipboard:error="onError"
            >{{ $t('invite.copy') }}</Button
          >
        </div>
        <!-- 登陆状态 -->
        <div class="mask" v-if="!isLogin">
          <div class="login-btn">
            <ButtonGroup size="large">
              <Button type="warning" to="/login">{{ $t('common.login') }}</Button>
              <Button type="warning" to="/register">{{ $t('common.register') }}</Button>
            </ButtonGroup>
          </div>
        </div>
      </div>
      <!-- tips -->
      <p class="headertip">* {{ $t('invite.headertip') }}</p>
      <!-- 详情 -->
      <div class="main">
        
        <!-- 推广工具箱 -->
<!--        <div class="promotion-tools">
          <h2>{{ $t('invite.ptools') }}</h2>
          <div class="tools">
            <div class="item" @click="showCardItem">
              <img src="https://bzeex.oss-cn-hongkong.aliyuncs.com/2019/08/08/promotioncard.png" />
              <p class="title">
                {{ $t('invite.pt_title')
                }}<span style="color:#FF0000;margin-left:10px;font-size:13px;">{{
                  $t('invite.pt_card_title_tips')
                }}</span>
              </p>
              <p class="desc">{{ $t('invite.pt_desc') }}</p>
            </div>
            <div class="item" @click="useInviteImage">
              <img src="https://bzeex.oss-cn-hongkong.aliyuncs.com/2019/08/08/invitebg.jpg" />
              <p class="title">{{ $t('invite.pt_invite_title') }}</p>
              <p class="desc">{{ $t('invite.pt_invite_desc') }}</p>
            </div>
          </div>
          <p class="bottom">{{ $t('invite.pt_tips') }}</p>
        </div> -->
        <!-- table1--- pc -->

        <!-- table2----unknow -->
        <!-- <div class="invite-rank" style="display:none;">
          <Row :gutter="80">
            <Col span="12">
              <h2>{{ $t('invite.promotioncount') }}TOP20{{ $t('invite.rankweek') }}</h2>
              <p class="ranktitle">
                <span>{{ $t('invite.laststastic') }}: {{ lastStasticWeek }}</span>
              </p>
              <Table class="rank-table" :columns="columns1" :data="topRankWeek"></Table>
              <p class="rank-tips">* {{ $t('invite.ranktip2') }}</p>
            </Col>
            <Col span="12">
              <h2>{{ $t('invite.promotioncount') }}TOP20{{ $t('invite.rankmonth') }}</h2>
              <p class="ranktitle">
                <span>{{ $t('invite.laststastic') }}: {{ lastStasticMonth }}</span>
              </p>
              <Table class="rank-table" :columns="columns1" :data="topRankMonth"></Table>
              <p class="rank-tips">* {{ $t('invite.ranktip2') }}</p>
            </Col>
          </Row>
        </div> -->
      </div>
      <!-- <H1 style="color:#000;text-align:center;margin-top: 100px;font-size:30px;;">{{ $t('invite.thanks') }}</H1> -->

      <Drawer :title="$t('invite.pt_title')" :closable="false" v-model="showCardModal" width="350">
        <div class="ptcard-header">
          <img class="card-img" src="https://bzeex.oss-cn-hongkong.aliyuncs.com/2019/08/08/promotioncard.png" />
          <div class="desc">
            <p class="title">{{ $t('invite.pt_title') }}</p>
            <p class="amount">{{ $t('invite.pt_card_amount') }}：0.001 BTC</p>
            <p class="deadline">{{ $t('invite.pt_card_deadline') }}：60{{ $t('invite.pt_card_day') }}</p>

            <Button v-if="isLogin && !hasCard" type="error" size="large" @click="getFreeCard">{{
              $t('invite.pt_card_btn')
            }}</Button>
            <Button v-if="isLogin && hasCard" type="error" size="large" @click="usePromotionImage">{{
              $t('invite.usepromotion')
            }}</Button>
            <Button v-else to="/login" type="success" size="large">{{ $t('invite.pt_card_btn_login') }}</Button>
          </div>
        </div>
        <Divider style="margin-top: 40px;" orientation="left">{{ $t('invite.pt_card_rule') }}</Divider>
        <div class="ptcard-info">
          <p class="title">{{ $t('invite.pt_card_summary') }}</p>
          <p class="detail">{{ $t('invite.pt_card_rule1') }}：BTXCHAIN@gmail.com。</p>
          <p class="detail">{{ $t('invite.pt_card_rule2') }}</p>
          <p class="detail">{{ $t('invite.pt_card_rule3') }}</p>
          <p class="detail">{{ $t('invite.pt_card_rule4') }}</p>
          <p class="detail">{{ $t('invite.pt_card_rule5') }}</p>
          <p class="detail">{{ $t('invite.pt_card_rule6') }}</p>
        </div>
      </Drawer>

      <Drawer
        :title="promotionTitle"
        :closable="false"
        v-model="showPromotionModal"
        width="350"
        style="text-align:center;"
      >
        <div style="position:relative;width: 318px;" id="promotionImage" ref="promotionImage">
          <img style="width:100%;display:block;" src="../../assets/images/promotion/promotionbg1.jpg" />
          <p
            style="position:absolute;top: 210px;text-align:center;width: 100%;text-align:center;font-size:26px;color:#F90;font-weight:bold;"
          >
            {{ promotionCode }}
          </p>
          <p style="position:absolute;top: 250px;text-align:center;width: 100%;text-align:center;">
            {{ $t('invite.context_title') }}
          </p>
        </div>
        <p style="text-align:center;font-size:12px;color:#888;margin-top: 10px;">{{ $t('invite.imagetips') }}</p>
        <Button
          type="error"
          size="large"
          :loading="saveImageLoading"
          long
          style="margin-top: 20px;"
          @click="saveImage"
          >{{ $t('invite.saveimage') }}</Button
        >
      </Drawer>

      <Drawer
        :title="$t('invite.context_title3')"
        :closable="false"
        v-model="showInviteImageModal"
        width="350"
        style="text-align:center;"
      >
        <div style="position:relative;width: 318px;" id="inviteImage" ref="inviteImage">
          <img style="width:100%;display:block;" src="../../assets/images/promotion/invitebg1.jpg" />
          <div
            class="qr-code"
            style="background:#FFF;position:absolute;top: 260px;left:105px;border-radius: 5px;height: 100px;"
          >
            <qriously :value="myInfo.inviteLink" :size="100" foreground="#000" />
          </div>
          <p style="position:absolute;top: 375px;text-align:center;width: 100%;text-align:center;">
            {{ $t('invite.context_title1') }}
          </p>
          <p style="position:absolute;top: 395px;text-align:center;width: 100%;text-align:center;font-size:16px;">
            {{ $t('invite.context_title2') }}：{{ inviteCode }}
          </p>
        </div>
        <p style="text-align:center;font-size:12px;color:#888;margin-top: 10px;">{{ $t('invite.imagetips') }}</p>
        <Button
          type="error"
          size="large"
          :loading="saveImageLoading"
          long
          style="margin-top: 20px;"
          @click="saveInviteImage"
          >{{ $t('invite.saveimage') }}</Button
        >
      </Drawer>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import VueQriously from 'vue-qriously'
import html2canvas from 'html2canvas'

Vue.use(VueQriously)

export default {
  data() {
    let self = this
    return {
      width: window.innerWidth,
      detailTitle1: [
        { type: 0, name: '推广返佣', id: 0 },
        { type: 1, name: '推广人数', id: 1 },
      ],
      active1: 0,
      showCardModal: false,
      hasCard: false,
      showPromotionModal: false,
      saveImageLoading: false,
      showInviteImageModal: false,
      promotionTitle: '',
      inviteCode: '', // 邀请码
      promotionCode: '', // 兑换码
      myInfo: {
        levelone: 0,
        leveltwo: 0,
        commission: 0,
        extrareward: 0,
        partnerlevel: '-',
        inviteLink: 'https://pc.usdtest.online/register?code=000000',
      },
      promotionRecordPage: {
        pageNo: 1,
        pageSize: 10,
      },
      columns: [
        {
          title: self.$t('invite.colum_text0'),
          type: 'index',
          width: 60,
          align: 'center',
        },
        {
          title: self.$t('invite.colum_text1'),
          key: 'userIdentify',
          align: 'center',
        },
        {
          title: self.$t('invite.colum_text2'),
          key: 'levelOne',
          width: 110,
          align: 'center',
        },
        {
          title: self.$t('invite.colum_text3'),
          key: 'estimatedReward',
          width: 160,
        },
        {
          title: self.$t('invite.colum_text4'),
          width: 90,
          key: 'extraReward',
        },
      ],
      topRankMonth: [],
      topRankWeek: [],
      lastStasticWeek: '',
      lastStasticMonth: '',
      columns1: [
        {
          title: self.$t('invite.colum_text0'),
          type: 'index',
          width: 80,
          align: 'center',
        },
        {
          title: self.$t('invite.colum_text1'),
          key: 'userIdentify',
          align: 'center',
        },
        {
          title: self.$t('invite.colum_text2'),
          key: 'levelOne',
          align: 'center',
        },
      ],
      lastUpdate: '',
      topRewardRank: [],
      topInviteCountRank: [],
      dataFanyong: [
        {
          sort: 1,
          name: '186****9837',
          age: 18,
          address: '18273.98',
          date: '+23',
        },
        {
          sort: 2,
          name: '186****9837',
          age: 24,
          address: '18273.98',
          date: '+23',
        },
      ],
      dataFanyong1: [
        {
          sort: 1,
          name: '186****9837',
          age: 18,
          address: '18273.98',
          date: '+23',
        },
      ],
    }
  },
  created: function() {
    this.init()
  },
  computed: {
    lang() {
      this.updateLangData()
      return this.$store.state.lang
    },
    langPram() {
      return this.$store.state.lang
    },
    isLogin: function() {
      return this.$store.getters.isLogin
    },
  },
  methods: {
    init() {
      this.$store.commit('navigate', 'nav-invite')
      if (this.isLogin) {
        this.getMemberInfo()
        this.getCardInfo()
      }
      this.getRank()
    },
    handleChange(type) {
      this.active1 = type
    },
    useInviteImage() {
      if (!this.isLogin) {
        this.$Message.error(this.$t('common.logintip'))
        return
      }
      this.showInviteImageModal = true
      window.pageYOffset = 0
      document.documentElement.scrollTop = 0
      document.body.scrollTop = 0
    },
    usePromotionImage() {
      if (!this.isLogin) {
        this.$Message.error(this.$t('common.logintip'))
        return
      }
      this.showPromotionModal = true
      window.pageYOffset = 0
      document.documentElement.scrollTop = 0
      document.body.scrollTop = 0
    },
    getCardInfo() {
      this.$http.post(this.host + this.api.uc.mycardlist).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          if (resp.data != null && resp.data.length > 0) {
            this.promotionTitle = resp.data[0].cardName
            this.promotionCode = resp.data[0].cardNo
            this.hasCard = true
          }
        } else {
          this.$Message.error(this.loginmsg)
        }
        this.loading = false
      })
    },
    dataURLToBlob(dataurl) {
      let arr = dataurl.split(',')
      let mime = arr[0].match(/:(.*?);/)[1]
      let bstr = atob(arr[1])
      let n = bstr.length
      let u8arr = new Uint8Array(n)
      while (n--) {
        u8arr[n] = bstr.charCodeAt(n)
      }
      return new Blob([u8arr], { type: mime })
    },
    saveInviteImage() {
      this.save('inviteImage', '邀请图片')
      this.saveImageLoading = true
    },
    saveImage() {
      this.save('promotionImage', '推广合伙人图片')
      this.saveImageLoading = true
    },
    save(divText, imgText) {
      let canvasID = this.$refs[divText]
      let that = this
      let scale = 1
      let a = document.createElement('a')
      html2canvas(canvasID, {
        scale,
        useCORS: true,
        width: canvasID.offsetWidth * scale,
        height: canvasID.offsetHeight * scale,
      }).then(canvas => {
        const context = canvas.getContext('2d')
        // 【重要】关闭抗锯齿 https://segmentfault.com/a/1190000011478657
        context.mozImageSmoothingEnabled = false
        context.webkitImageSmoothingEnabled = false
        context.msImageSmoothingEnabled = false
        context.imageSmoothingEnabled = false
        context.scale(scale, scale)

        let dom = document.body.appendChild(canvas)
        dom.style.display = 'none'
        a.style.display = 'none'
        document.body.removeChild(dom)
        let blob = that.dataURLToBlob(dom.toDataURL('image/png'))
        a.setAttribute('href', URL.createObjectURL(blob))
        //这块是保存图片操作  可以设置保存的图片的信息
        a.setAttribute('download', imgText + '.png')
        document.body.appendChild(a)
        a.click()
        URL.revokeObjectURL(blob)
        document.body.removeChild(a)

        this.saveImageLoading = false
      })
    },
    showCardItem() {
      this.showCardModal = true
    },
    onCopy(e) {
      this.$Message.success(this.$t('uc.finance.recharge.copysuccess') + e.text)
    },
    onError(e) {
      this.$Message.error(this.$t('uc.finance.recharge.copysuccess'))
    },
    getMemberInfo() {
      this.myInfo.inviteLink = this.$store.state.member.promotionPrefix + this.$store.state.member.promotionCode
      this.inviteCode = this.$store.state.member.promotionCode

      // 获取邀请人数
      this.$http.post(this.host + this.api.uc.memberInfo, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.myInfo.levelone = resp.data.firstLevel
          this.myInfo.leveltwo = resp.data.secondLevel
          this.myInfo.partnerlevel = this.partnerNameByCount(resp.data.firstLevel)
        } else {
          this.$Notice.error({
            title: this.$t('common.tip'),
            desc: resp.message,
          })
        }
      })

      // 获取个人佣金信息
      this.$http.post(this.host + this.api.uc.mypromotion, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.myInfo.commission = resp.data.estimatedReward
          this.myInfo.extrareward = resp.data.extraReward
        } else {
          this.$Notice.error({
            title: this.$t('common.tip'),
            desc: resp.message,
          })
        }
      })
    },
    getFreeCard: function() {
      this.$http.post(this.host + this.api.uc.getfreecard, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.$Notice.success({
            title: this.$t('common.tip'),
            desc: this.$t('invite.pt_card_receivew_success'),
            duration: 30,
          })

          this.getCardInfo()
        } else {
          this.$Notice.error({
            title: this.$t('common.tip'),
            desc: resp.message,
            duration: 15,
          })
        }
      })
    },
    getTopRankWeek: function() {
      // 获取推广合伙人排行榜
      this.$http.post(this.host + this.api.uc.toppromotionweek, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.topRankWeek = resp.data.topinviteweek
          if (this.topRankWeek.length > 0) {
            this.lastStasticWeek = this.topRankWeek[0].stasticDate
          }
        }
      })
    },
    getTopRankMonth: function() {
      // 获取推广合伙人排行榜
      this.$http.post(this.host + this.api.uc.toppromotionmonth, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.topRankMonth = resp.data.topinvitemonth
          if (this.topRankMonth.length > 0) {
            this.lastStasticMonth = this.topRankMonth[0].stasticDate
          }
        }
      })
    },
    getRank: function() {
      // 获取推广合伙人排行榜
      this.$http.post(this.host + this.api.uc.toppromotion, {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.topRewardRank = resp.data.topreward
          this.topInviteCountRank = resp.data.topinvite
          if (this.topRewardRank.length > 0) {
            this.lastUpdate = this.topRewardRank[0].stasticDate
          }
        } else {
          this.$Notice.error({
            title: this.$t('common.tip'),
            desc: resp.message,
          })
        }
      })
    },
    partnerNameByCount: function(count) {
      if (count == undefined || count == null || count == '') {
        return '-'
      }
      let partnerName = 'Lv1(' + this.$t('invite.lv1') + ')'
      if (count > 10) partnerName = 'Lv2(' + this.$t('invite.lv2') + ')'
      if (count > 100) partnerName = 'Lv3(' + this.$t('invite.lv3') + ')'
      if (count > 500) partnerName = 'Lv4(' + this.$t('invite.lv4') + ')'
      if (count > 1500) partnerName = 'Lv5(' + this.$t('invite.lv5') + ')'
      if (count > 3000) partnerName = 'Lv6(' + this.$t('invite.lv6') + ')'
      return partnerName
    },
    updateLangData: function() {
      this.columns[0].title = this.$t('invite.colum_text0')
      this.columns[1].title = this.$t('invite.colum_text1')
      this.columns[2].title = this.$t('invite.colum_text2')
      this.columns[3].title = this.$t('invite.colum_text3')
      this.columns[4].title = this.$t('invite.colum_text4')
    },
  },
}
</script>
<style lang="scss" scoped>
@import url('../../assets/css/common.scss');
// bz_container
.invite {
  display: flex;
  flex-direction: column;
  background: linear-gradient(200deg, #f19100, #ffc84b, #ffc540);
  padding-bottom: 100px;
  .header {
    position: relative;
    margin-top: 100px;
    padding: 25px 50px;
    width: 100%;
    color: #000;
    background: linear-gradient(200deg, #ff9900, #ffbe2b, #ffa500);
    background-size: 100% 100%;
    box-shadow: 0px 0px 20px #5b5b5b8c;
    margin-bottom: 10px;
    border-radius: 8px;
    .invite-title {
      font-size: 16px;
      display: flex;
      flex-direction: row;
      margin-right: 170px;
      padding-bottom: 15px;
      border-bottom: 1px dashed #e3a700;
      .my-link-text {
        line-height: 38px;
      }
      .my-link-content {
        background: rgba(0, 0, 0, 0);
        border-radius: 3px;
        height: 38px;
        line-height: 38px;
        width: 600px;
        text-align: center;
        box-shadow: 0px 0px 15px #00000026 inset;
      }
      .copy-button {
        height: 32px;
        line-height: 32px;
        background: linear-gradient(350deg, #e1e1e1, #ffffff);
        padding: 0 20px;
        margin-left: 20px;
        border-radius: 5px;
        color: #000;
        font-size: 14px;
        margin-top: 3px;
        box-shadow: 0px 0px 10px #afafaf;
        width: 100px;
        text-align: center;
        cursor: pointer;
        &:hover {
          background: linear-gradient(350deg, #efefef, #e1e1e1);
        }
        &:focus {
          box-shadow: 0px 0px 10px #00000026 inset;
        }
      }
    }
    .invite-detail {
      margin-right: 170px;
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      padding-top: 10px;
      .item {
        width: 18%;
        text-align: center;
        .i-t {
          font-size: 12px;
          background: #0000000f;
          padding: 5px 0;
        }
        .i-v {
          font-size: 26px;
          font-weight: bold;
        }
      }
    }
    .qr-code {
      position: absolute;
      top: 15px;
      right: 20px;
      height: 150px;
      width: 150px;
      border-radius: 10px;
      box-shadow: 0px 0px 15px #00000057 inset;
    }
    .mask {
      width: 100%;
      background: #ffffffe0;
      position: absolute;
      top: 0;
      left: 0;
      border-radius: 8px;
      height: 100%;
      text-align: center;
      .login-btn {
        width: 150px;
        height: 35px;
        line-height: 35px;
        border-radius: 3px;
        margin: 0 auto;
        margin-top: 80px;
      }
    }
  }
  p.headertip {
    font-size: 12px;
    text-align: right;
    color: rgba(0, 0, 0, 0.48);
    text-shadow: 0 0 25px #ffffff;
  }
  // 内容详情
  .main {
    width: 100%;
    border-radius: 6px;
    margin-top: 30px;
    .invite-content {
      background: #fff;
      padding: 30px 30px;
      margin-bottom: 30px;
      color: #6d6d6d;
      border-radius: 5px;
      box-shadow: 0px 0px 20px #909090;
      .content {
        margin-top: 20px;
        min-height: 100px;
        padding-left: 40px;
        line-height: 30px;
        .content-title {
          margin-bottom: 20px;
          border-left: 5px solid #e7e7e7;
          padding-left: 25px;
        }
        .percent-table {
          margin-bottom: 10px;
          background: #ededed;
          text-align: center;
          margin-left: 30px;
          font-size: 12px;
          width: 90%;
          margin-top: 10px;
          border-right: 1px solid #c8c8c8;
          border-bottom: 1px solid #c8c8c8;
          border-collapse: collapse;
          tr {
            background: #fff;
            td {
              border-left: 1px solid #c8c8c8;
              border-top: 1px solid #c8c8c8;
            }
          }
        }
        .rule-tips {
          font-size: 12px;
          padding: 10px;
          margin-left: 30px;
          width: 90%;
          margin-bottom: 10px;
          border: 1px solid #c8c8c8;
        }
        .rule-update {
          font-size: 12px;
          text-align: right;
          color: #afafaf;
          margin-top: 20px;
          padding-top: 20px;
          border-top: 1px solid #ededed;
        }
      }
      > h2 {
        padding-bottom: 10px;
        border-bottom: 1px solid #ededed;
      }
    }

    .promotion-tools {
      color: #3a3a3a;
      position: relative;
      h2 {
        padding-bottom: 0px;
        margin-bottom: 20px;
        margin-top: 60px;
      }
      .tools {
        background: #fff;
        border-radius: 5px;
        box-shadow: 0px 0px 20px #909090;
        padding: 20px 20px 50px 20px;
        display: flex;
        .item {
          width: 30%;
          padding: 5px;
          margin-right: 10px;
          img {
            width: 100%;
            border-radius: 5px;
            height: 160px;
            &:hover {
              opacity: 0.9;
            }
          }
          p.title {
            font-size: 16px;
            padding: 0 5px;
          }
          p.desc {
            font-size: 12px;
            padding: 0 5px;
            color: #999;
          }
          &:hover {
            cursor: pointer;
          }
        }
      }
      .bottom {
        color: #c2c2c2;
        font-size: 12px;
        text-align: right;
        margin-top: 10px;
        position: absolute;
        bottom: 5px;
        position: absolute;
        width: 96%;
        bottom: 10px;
        left: 2%;
        border-top: 1px dashed #c2c2c2;
        padding-top: 10px;
        text-align: center;
      }
    }
    .invite-rank {
      margin-top: 60px;
      p.ranktitle {
        text-align: left;
        font-size: 12px;
        margin-bottom: 20px;
        color: #383838;
      }
      h2 {
        padding-bottom: 0px;
        color: #3a3a3a;
        text-align: left;
        span {
          font-size: 14px;
          font-weight: normal;
          margin-left: 10px;
        }
      }
      .ivu-table-wrapper .ivu-table .ivu-table-row td {
        background-color: transparent;
        border: none;
        border-bottom: 1px solid #e3e3e3;
        color: #151515;
      }
      .ivu-table-wrapper .ivu-table .ivu-table-header th {
        background-color: #f90;
        color: #000;
      }
      .ivu-table-wrapper .ivu-table .ivu-table-row:hover {
        background: #f7f7f7 !important;
      }
      .rank-tips {
        text-align: right;
        color: #000;
        font-size: 12px;
        margin-top: 10px;
      }
      .rank-table {
        box-shadow: 0 0 25px #000;
      }
    }
  }
}

.ptcard-header {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  flex-wrap: wrap;
  margin-top: 20px;
  .card-img {
    width: 260px;
    height: 140px;
    border-radius: 5px;
  }
  .desc {
    height: 130px;
    width: 100%;
    color: #000;
    padding-left: 20px;
    .title {
      font-size: 20px;
      margin-bottom: 5px;
    }
    .amount,
    .deadline {
      font-size: 14px;
      color: #888;
    }
    .ivu-btn {
      margin-top: 25px;
      letter-spacing: 1px;
    }
  }
}
.ptcard-info {
  color: #555;
  line-height: 25px;
  .title {
    color: rgb(85, 85, 85);
    line-height: 25px;
    padding: 5px 10px;
    background: #f9f9f9;
    border: 1px solid #ededed;
  }
  .detail {
    margin-top: 10px;
  }
}

@media screen and (max-width: 768px) {
  .invite {
    p.headertip {
      text-align: left;
    }
    .header {
      margin-top: 60px;
      padding: 14px;
    }
    // 内容详情
    .main {
      margin-top: 20px;
      .invite-content {
        padding: 14px;
        .content {
          margin-top: 10px;
          padding-left: 0px;
          line-height: 20px;
          .content-title {
            margin-bottom: 10px;
            border-left: 0;
            padding-left: 0;
          }
          .percent-table {
            margin-left: 0px;
            width: 100%;
          }
          .rule-tips {
            margin-left: 0;
            width: 100%;
          }
          .rule-update {
            font-size: 12px;
            text-align: right;
            color: #afafaf;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ededed;
          }
        }
        > h2 {
          padding-bottom: 0;
          border-bottom: 0;
          text-align: center;
        }
      }

      .promotion-tools {
        h2 {
          text-align: center;
          padding-bottom: 0px;
          margin-bottom: 16px;
          margin-top: 0px;
        }
        .tools {
          flex-wrap: wrap;
          .item {
            width: 100%;
            padding: 5px;
            margin-right: 0;
            margin-bottom: 10px;
          }
        }
      }
      .invite-rank {
        margin-top: 40px;
        .invite-table {
           overflow:scroll;
          &::-webkit-scrollbar {
            height: 2px;
          }
          &::-webkit-scrollbar-thumb {
            background: #eee;
          }
          &::-webkit-scrollbar-track-piece {
            background: transparent;
          }
          .table {
            width: 200%;
          }
        }

        p.ranktitle {
          text-align: left;
          font-size: 12px;
          margin-bottom: 20px;
          color: #383838;
        }
        h2 {
          padding-bottom: 0px;
          color: #3a3a3a;
          text-align: left;
          span {
            font-size: 14px;
            font-weight: normal;
            margin-left: 10px;
          }
        }
        .ivu-table-wrapper .ivu-table .ivu-table-row td {
          background-color: transparent;
          border: none;
          border-bottom: 1px solid #e3e3e3;
          color: #151515;
        }
        .ivu-table-wrapper .ivu-table .ivu-table-header th {
          background-color: #f90;
          color: #000;
        }
        .ivu-table-wrapper .ivu-table .ivu-table-row:hover {
          background: #f7f7f7 !important;
        }
        .rank-tips {
          text-align: left;
        }
        .rank-table {
          box-shadow: 0 0 25px #000;
        }
      }
    }
  }

  h3,
  h2 {
    font-weight: normal;
  }
  .header-web-detail {
    margin-top: 10px;
    li {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-direction: row-reverse;
      font-size: 12px;
      margin-bottom: 14px;
      .i-t {
        background: #0000000f;
        padding: 5px 0;
        min-width: 140px;
        text-align: center;
      }
    }
  }
  .copy-button {
    width: 100%;
    color: #333;
    background: linear-gradient(350deg, #e1e1e1, #fff);
    box-shadow: 0px 0px 10px #afafaf;
  }
}
</style>

<style scoped>
.ivu-table-wrapper .ivu-table .ivu-table-row td {
  background-color: transparent;
  border: none;
  border-bottom: 1px solid #e3e3e3;
  color: #151515;
}
.ivu-table-wrapper .ivu-table .ivu-table-header th {
  background-color: #f90;
  color: #000;
}
.ivu-table-wrapper .ivu-table .ivu-table-row:hover {
  background: #f7f7f7 !important;
}
.ivu-table-wrapper .ivu-table {
  background-color: #ffffff;
}
.ivu-table:after {
  width: 0;
}
.ivu-table-wrapper .ivu-table .ivu-table-row td {
  border-bottom: none;
}
</style>

<style lang="scss">
.tabs-card {
  display: flex;
  border-radius: 2px;
  height: 30px;
  line-height: 30px;
  border: 1px solid #eee;
  color: #999;
  margin-bottom: 20px;
  li {
    flex: 1;
    text-align: center;
    font-size: 14px;
    white-space: nowrap;
  }
  .active {
    background-color: #eee;
    color: #333;
  }
}
</style>
