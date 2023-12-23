<template>
  <div :class="pageView">
    <div class="page-content">
      <div class="time_download" style="display: none;">
        <div class="leftwrapper">
          <!-- <img src="../src/assets/images/clock.png" alt="" class="clock"> -->
          <Icon type="ios-clock-outline" class="clock"></Icon>
          <span>{{ time | dateFormat }}&#160;&#160;{{ utc }}</span>
        </div>
      </div>
      <div class="layout">
        <div class="layout-ceiling">
          <router-link to="/">
            <div class="layout-logo"></div>
          </router-link>
          <div class="layout-ceiling-main">
            <!-- 导航条 -->

            <div class="header_nav">
              <Menu :active-name="activeNav" width="auto" :open-names="['1']">
                <Submenu name="1">
                  <router-link to="/">
                    <MenuItem name="nav-index">{{ $t('header.index') }}</MenuItem>
                  </router-link>
                 <router-link to="/ctc">
                    <MenuItem name="nav-ctc">{{ $t('header.ctc') }}</MenuItem>
                  </router-link>
                  <router-link to="/otc/trade/usdt">
                    <MenuItem name="nav-otc">{{ $t('header.otc') }}</MenuItem>
                  </router-link>
                  <router-link to="/exchange">
                    <MenuItem name="nav-exchange">{{ $t('header.exchange') }}</MenuItem>
                  </router-link>
                  <router-link to="/swap">
                    <MenuItem name="nav-swap">{{ $t('header.swap1') }}</MenuItem>
                  </router-link>
<!--                  <router-link to="/option">
                    <MenuItem name="nav-option">{{ $t('header.option') }}</MenuItem>
                  </router-link> -->
                  <router-link to="/second">
                    <MenuItem name="nav-second">{{ $t('header.second') }}</MenuItem>
                  </router-link>
                  <router-link to="/lab">
                    <MenuItem name="nav-lab">{{ $t('header.lab') }}</MenuItem>
                  </router-link>
                  <router-link to="/invite">
                    <MenuItem name="nav-invite">{{ $t('header.invite') }}</MenuItem>
                  </router-link>
<!--                  <router-link to="/news">
                    <MenuItem name="nav-news">{{ $t('header.news') }}</MenuItem>
                  </router-link> -->
                  <router-link to="/announcement/0">
                    <MenuItem name="nav-service">{{$t("header.service")}}</MenuItem>
                  </router-link>
                </Submenu>
              </Menu>
            </div>
            <div class="header_nav_mobile_triggle" @click="toggleMemu()">
              <Icon type="md-menu" style="font-size: 26px;color:#cccccc;" />
            </div>
            <div class="header_nav" style="float:right;margin-left: 10px;">
              <Menu mode="horizontal" width="auto" @on-select="changelanguage" style="height: 50px;line-height:50px;">
                <Submenu name="lang">
                  <template slot="title" class="lang-title">
                    <span>{{ languageValue }}</span>
                    <img class="lang-img" v-if="lang == 'en_US'" />
                    <img class="lang-img" v-if="lang == 'ja_JP'" />
                    <img class="lang-img" v-if="lang == 'ko_KR'" />
                    <img class="lang-img" v-if="lang == 'de_DE'" />
                    <img class="lang-img" v-if="lang == 'fr_FR'" />
                    <img class="lang-img" v-if="lang == 'it_IT'" />
                    <img class="lang-img" v-if="lang == 'es_ES'" />
<!--                    <img class="lang-img" v-if="lang == 'ru_RU'" />
                    <img class="lang-img" v-if="lang == 'hi_IN'" /> -->
                    <img class="lang-img" v-if="lang == 'zh_HK'" />
                    <img class="lang-img" v-if="lang == 'zh_CN'" />
                  </template>
                  <MenuItem name="en_US" class="lang-item">English</MenuItem>
                  <MenuItem name="ja_JP" class="lang-item">日本語</MenuItem>
                  <MenuItem name="ko_KR" class="lang-item">한국어</MenuItem>
                  <MenuItem name="de_DE" class="lang-item">Deutsche</MenuItem>
                  <MenuItem name="fr_FR" class="lang-item">français</MenuItem>
                  <MenuItem name="it_IT" class="lang-item">italiano</MenuItem>
                  <MenuItem name="es_ES" class="lang-item">Español</MenuItem>
<!--                  <MenuItem name="ru_RU" class="lang-item">русский</MenuItem>
                  <MenuItem name="hi_IN" class="lang-item">हिंदी</MenuItem> -->
                  <MenuItem name="zh_HK" class="lang-item">繁體中文</MenuItem>
                  <MenuItem name="zh_CN" class="lang-item">简体中文</MenuItem>
                </Submenu>
              </Menu>
            </div>
            <div class="rightwrapper">
              <poptip placement="bottom" width="120" class="appdownload" trigger="hover">
                <a href="javascript:;" style="font-size:14px;"
                  >{{ $t('header.appdownlaod') }}
                  <Icon type="md-arrow-dropdown" size="18" />
                </a>
                <div class="api" slot="content">
                  <div class="ios">
                    <img src="../src/assets/images/appdownload.png" alt="" />
                    <div class="tips">
                      <span>{{ $t('header.scandownload') }}</span>
                    </div>
                  </div>
                </div>
              </poptip>
            </div>
            <div class="rr login-container">
              <!-- 判断是否登录 -->
              <!-- 登录 -->
              <div class="login_register isLogin" v-if="isLogin">
                <div class="mymsg">
                  <router-link to="/uc/safe">{{ $t('header.usercenter') }}</router-link>
                </div>
                <Dropdown>
                  <a href="javascript:void(0)">
                    <Icon type="md-person" size="20" />
                    <span>{{ strpo(member.username) }}</span>
                    <Icon type="md-arrow-dropdown" size="16" />
                  </a>
                  <DropdownMenu slot="list">
                    <DropdownItem>
                      <router-link to="/uc/money">
                        <Icon type="logo-bitcoin" /> &nbsp;{{ $t('header.assetmanage') }}
                      </router-link>
                    </DropdownItem>
                    <DropdownItem>
                      <router-link to="/uc/entrust/current">
                        <Icon type="md-swap" /> &nbsp;{{ $t('header.trademanage') }}
                      </router-link>
                    </DropdownItem>
                    <DropdownItem>
                      <router-link to="/uc/innovation/myorders">
                        <Icon type="md-swap" /> &nbsp;{{ $t('header.innovationmanage') }}
                      </router-link>
                    </DropdownItem>
                    <DropdownItem>
                      <div @click="logout"><Icon type="md-log-out" /> &nbsp;{{ $t('common.logout') }}</div>
                    </DropdownItem>
                  </DropdownMenu>
                </Dropdown>
              </div>
              <!-- 未登录 -->
              <div class="login_register" v-else>
                <Menu active-name11="1-1" width="auto" :open-names="['2']">
                  <Submenu name="2" id="login_register_theme">
                    <router-link to="/login" id="login">
                      <MenuItem name="1-1">{{ $t('common.login') }}</MenuItem>
                    </router-link>
                    <router-link to="/register" id="register">
                      <MenuItem name="1-2">{{ $t('common.register') }}</MenuItem>
                    </router-link>
                  </Submenu>
                </Menu>
              </div>
            </div>
	            <div class="rr login-container">
<!-- 	              <a target="_blank" href="">
	                <img style="cursor:pointer;width: 25px;vertical-align:middle;"  src="../src/assets/images/online_service.png" alt="" class="clock">
	              </a> -->
	            </div>
          </div>
        </div>
      </div>
      <router-view v-if="isRouterAlive"></router-view>
      <!-- </div> -->
    </div>

    <Drawer :closable="true" width="40" v-model="navDrawerModal" class="header_nav_mobile">
      <Menu :active-name="activeNav" width="auto" @on-select="changelanguage">
        <!-- 未登录 -->
        <div class="login_register" v-if="!isLogin" style="display: flex;">
          <!-- <Menu active-name11="1-1" width="auto" :open-names="['2']">
            <Submenu name="2" id="login_register_theme"> -->
          <router-link to="/login" id="login">
            <MenuItem name="1-1">{{ $t('common.login') }}</MenuItem>
          </router-link>
          <router-link to="/register" id="register">
            <MenuItem name="1-2">{{ $t('common.register') }}</MenuItem>
          </router-link>
          <!-- </Submenu>
          </Menu> -->
        </div>
        <router-link to="/">
          <MenuItem name="nav-index" style="text-align:left;color:#bdc2ca;">{{ $t('header.index') }}</MenuItem>
        </router-link>
<!--        <router-link to="/ctc">
          <MenuItem name="nav-ctc" style="text-align:left;color:#bdc2ca;">{{ $t('header.ctc') }}</MenuItem>
        </router-link>
        <router-link to="/otc/trade/usdt">
          <MenuItem name="nav-otc" style="text-align:left;color:#bdc2ca;">{{ $t('header.otc') }}</MenuItem>
        </router-link> -->
        <router-link to="/exchange">
          <MenuItem name="nav-exchange" style="text-align:left;color:#bdc2ca;">{{ $t('header.exchange') }}</MenuItem>
        </router-link>
        <router-link to="/swap">
          <MenuItem name="nav-swap" style="text-align:left;color:#bdc2ca;">{{ $t('header.swap1') }}</MenuItem>
        </router-link>
<!--        <router-link to="/option">-->
<!--          <MenuItem name="nav-option" style="text-align:left;color:#bdc2ca;">{{ $t('header.option') }}</MenuItem>-->
<!--        </router-link>-->
        <router-link to="/second">
          <MenuItem name="nav-second" style="text-align:left;color:#bdc2ca;">{{ $t('header.second') }}</MenuItem>
        </router-link>
        <router-link to="/lab" style="display: none;">
          <MenuItem name="nav-lab" style="text-align:left;color:#bdc2ca;">{{ $t('header.lab') }}</MenuItem>
        </router-link>
       <router-link to="/invite">
          <MenuItem name="nav-invite" style="text-align:left;color:#bdc2ca;">{{ $t('header.invite') }}</MenuItem>
        </router-link>
        <router-link to="/news" style="display: none;">
          <MenuItem name="nav-news" style="text-align:left;color:#bdc2ca;">{{ $t('header.news') }}</MenuItem>
        </router-link>
        <router-link to="/lab">
          <MenuItem name="nav-lab" style="text-align:left;color:#bdc2ca;">{{ $t('header.lab') }}</MenuItem>
        </router-link>
        <router-link to="/announcement/0" style="display: none;">
          <MenuItem name="nav-service" style="text-align:left;color:#bdc2ca;">{{$t("header.service")}}</MenuItem>
        </router-link>
        <Submenu name="nav_personal" v-if="isLogin">
          <template slot="title" class="lang-t  itle">
            <span style="color:#bdc2ca;">{{ $t('header.usercenter') }}</span>
          </template>
          <router-link to="/uc/safe">
            <MenuItem name="nav_safe" class="lang-item" style="padding-left:20px!important;">{{
              $t('uc.member.securitysetting')
            }}</MenuItem>
          </router-link>
          <router-link to="/uc/money">
            <MenuItem name="nav_assets" class="lang-item" style="padding-left:20px!important;">{{
              $t('header.assetmanage')
            }}</MenuItem>
          </router-link>
          <router-link to="/uc/innovation/myminings">
            <MenuItem name="nav_innnovationmanage" class="lang-item" style="padding-left:20px!important;">{{
              $t('header.innovationmanage')
            }}</MenuItem>
          </router-link>
          <div @click="logout"><Icon type="md-log-out" /> &nbsp;{{ $t('common.logout') }}</div>
        </Submenu>
        <div style="height: 1px;width:100%;background:rgb(59, 69, 85);margin-top:10px;margin-bottom:10px;"></div>
        <Submenu name="lang">
          <template slot="title" class="lang-title">
            <span style="color:#bdc2ca;">{{ languageValue }}</span>
          </template>
          <MenuItem name="en_US" class="lang-item" style="padding-left:20px!important;">English</MenuItem>
          <MenuItem name="ja_JP" class="lang-item" style="padding-left:20px!important;">日本語</MenuItem>
          <MenuItem name="ko_KR" class="lang-item" style="padding-left:20px!important;">한국어</MenuItem>
          <MenuItem name="de_DE" class="lang-item" style="padding-left:20px!important;">Deutsche</MenuItem>
          <MenuItem name="fr_FR" class="lang-item" style="padding-left:20px!important;">français</MenuItem>
          <MenuItem name="it_IT" class="lang-item" style="padding-left:20px!important;">italiano</MenuItem>
          <MenuItem name="es_ES" class="lang-item" style="padding-left:20px!important;">Español</MenuItem>
          <MenuItem name="ru_RU" class="lang-item" style="padding-left:20px!important;">русский</MenuItem>
          <MenuItem name="hi_IN" class="lang-item" style="padding-left:20px!important;">हिंदी</MenuItem>
          <MenuItem name="zh_HK" class="lang-item" style="padding-left:20px!important;">繁體中文</MenuItem>
          <MenuItem name="zh_CN" class="lang-item" style="padding-left:20px!important;">简体中文</MenuItem>
        </Submenu>
        <router-link to="/app">
          <MenuItem name="nav-appdownload" style="text-align:left;color:#bdc2ca;">{{
            $t('header.appdownlaod')
          }}</MenuItem>
        </router-link>
      </Menu>
    </Drawer>
    <!-- footer -->
    <div class="footer">
      <Row class="footer_content">
        <!-- 左边链接 -->
        <Col class="footer_left" :xs="24" :sm="8">
          <img src="./assets/images/logo-bottom.png" />
          <p style="letter-spacing:2px;">{{ $t('footer.gsmc') }}</p>
          <p>Copyright © 2021-2022 BTXCHAIN All rights reserved.</p>
          <!-- <div class="social-list">
            <ul>
              <Tooltip content="Wechat" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont iconweixin" />
                </li>
                <div slot="content">
                  <img style="height: 130px;border-radius: 5px;" src="./assets/images/wechatqrcode.jpg" />
                </div>
              </Tooltip>
              <Tooltip content="Biyong" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont iconbiyonglogo" />
                </li>
                <div slot="content">
                  <img style="height: 130px;border-radius: 5px;" src="./assets/images/biyongqrcode.png" />
                </div>
              </Tooltip>
              <Tooltip content="Telegram" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont icontelegram1" />
                </li>
                <div slot="content">
                  <img style="height: 130px;border-radius: 5px;" src="./assets/images/telegramqrcode.jpg" />
                </div>
              </Tooltip>
              <Tooltip content="https://weibo.com/bizzan" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont iconweibo" />
                </li>
              </Tooltip>
              <Tooltip content="https://twitter.com/BTXCHAINGlobal" theme="dark" placement="top">
                <li>
                  <Icon type="logo-twitter" />
                </li>
              </Tooltip>
              <Tooltip content="https://medium.com/@BTXCHAIN" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont iconmedium" />
                </li>
              </Tooltip>
              <Tooltip content="https://www.reddit.com/u/bizzanglobal" theme="dark" placement="top">
                <li>
                  <Icon custom="i-icon iconfont iconreddit" />
                </li>
              </Tooltip>
              <Tooltip content="coming" theme="dark" placement="top" style="display:none;">
                <li>
                  <Icon type="logo-facebook" />
                </li>
              </Tooltip>
            </ul>
          </div> -->
        </Col>
        <Col class="footer_right" :xs="13">
          <Row>
            <!-- 关于我们 -->
            <Col :xs="6">
              <ul>
                <li class="footer_title">
                  <span>{{ $t('footer.gsjj') }}</span>
                </li>
                <li>
                  <router-link target="_blank" to="/about-us">{{ $t('footer.gywm') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(1)">{{ $t('footer.jrwm') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" to="/announcement/0">{{ $t('footer.notice') }}</router-link>
                </li>

              </ul>
            </Col>
            <!-- 帮助中心 -->
            <Col :xs="6">
              <ul>
                <li class="footer_title">
                  <span>{{ $t('footer.bzzx') }}</span>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(2)">{{ $t('footer.xszn') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(3)">{{ $t('footer.cjwt') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(4)">{{ $t('footer.jyzn') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(5)">{{ $t('footer.bzzl') }}</router-link>
                </li>
              </ul>
            </Col>
            <!-- 条款协议 -->
            <Col :xs="6">
              <ul>
                <li class="footer_title">
                  <span>{{ $t('footer.tkxy') }}</span>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(6)">{{ $t('footer.mztk') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(7)">{{ $t('footer.ystk') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(8)">{{ $t('footer.fwtk') }}</router-link>
                </li>
                <li>
                  <router-link target="_blank" :to="getUrl(9)">{{ $t('footer.fltk') }}</router-link>
                </li>
              </ul>
            </Col>
            <!-- 联系我们 -->
            <Col :xs="6">
              <ul>
                <li class="footer_title">
                  <span>{{ $t('footer.lxwm') }}</span>
                </li>
                <li class="wechatclick">
                  <poptip width="200" trigger="hover" placement="right">
                    <a href="javascript:;" class="wechat">{{ $t('footer.kfyx') }}</a>
                    <div slot="content">
                      <p style="text-align:center;">BTXCHAIN@gmail.com</p>
                    </div>
                  </poptip>
                </li>
                <li class="wechatclick">
                  <poptip width="200" trigger="hover" placement="right">
                    <a href="javascript:;" class="wechat">{{ $t('footer.swhz') }}</a>
                    <div slot="content">
                      <p style="text-align:center;">BTXCHAIN@gmail.com</p>
                    </div>
                  </poptip>
                </li>
                <li class="wechatclick">
                  <poptip width="200" trigger="hover" placement="right">
                    <a href="javascript:;" class="wechat">{{ $t('footer.sbsq') }}</a>
                    <div slot="content">
                      <p style="text-align:center;">BTXCHAIN@gmail.com</p>
                    </div>
                  </poptip>
                </li>
                <li class="wechatclick">
                  <poptip width="200" trigger="hover" placement="right">
                    <a href="javascript:;" class="wechat">{{ $t('footer.tsjb') }}</a>
                    <div slot="content">
                      <p style="text-align:center;">BTXCHAIN@gmail.com</p>
                    </div>
                  </poptip>
                </li>
              </ul>
            </Col>
          </Row>
        </Col>
        <!-- 友情链接 -->
<!--        <Col class="footer_right" :xs="3" style="border-left: 1px solid #243051;">
          <ul>
            <li class="footer_title">
              <span>{{ $t('footer.yqlj') }}</span>
            </li>
            <li>
              <a target="_blank" href="https://www.feixiaohao.com/">非小号</a>
            </li>
            <li>
              <a target="_blank" href="https://www.8btc.com/">巴比特</a>
            </li>
            <li>
              <a target="_blank" href="https://www.chainnode.com/">链节点</a>
            </li>
            <li>
              <a target="_blank" href="https://www.jinse.com/">金色财经</a>
            </li>
          </ul>
        </Col> -->
      </Row>
    </div>
    <template>
      <BackTop :bottom="50"></BackTop>
    </template>
  </div>
</template>
<script>
import Vue from 'vue'
import { mapGetters, mapActions } from 'vuex'
export default {
  name: 'app',
  provide() {
    return {
      reload: this.reload,
    }
  },
  data() {
    return {
      isRouterAlive: true,
      pageView: 'page-view',
      xsShow: false, //手机显示
      activeWidth: window.innerWidth,
      utc: null,
      time: null,
      content: ' ',
      navDrawerModal: false,
      wechat: this.$t('footer.wechat'),
    }
  },
  watch: {
    activeNav: function() {
      switch (this.activeNav) {
        case 'nav-exchange':
          window.document.title =
            (this.lang == 'zh_CN' ? '交易中心' : 'Exchange') +
            ' - BTXCHAIN'
          break
        case 'nav-service':
          window.document.title =
            (this.lang == 'zh_CN' ? '公告' : 'Announcement') +
            ' - BTXCHAIN'
          break
        case 'nav-about':
          window.document.title =
            (this.lang == 'zh_CN' ? '关于' : 'About') + ' - BTXCHAIN'
          break
        case 'nav-lab':
          window.document.title =
            (this.lang == 'zh_CN' ? '创新实验室' : 'Lab') +
            ' - BTXCHAIN'
          break
        case 'nav-invite':
          window.document.title =
            (this.lang == 'zh_CN' ? '推广合伙人' : 'Promotion') +
            ' - BTXCHAIN'
          break
        case 'nav-cexchange':
          window.document.title =
            (this.lang == 'zh_CN' ? '活动' : 'Activity') + ' - BTXCHAIN'
          break
        default:
          window.document.title = 'BTXCHAIN'
          break
      }
    },
    $route(to, from) {
      this.pageView = 'page-view'
      if (to.path == '/reg') {
        this.pageView = 'page-view2'
        // if(!this.isMobile()){
        //     if(this.$route.query.code != undefined && this.$route.query.code != "" && this.$route.query.code != null){
        //         this.$router.replace('/register?code='+this.$route.query.code);
        //     }else{
        //         this.$router.replace('/register');
        //     }
        // }
      }

      if (to.path == '/' || to.path == '/index' || to.path == '/ctc' || to.path == '/exchange') {
        // if(this.isMobile()){
        //   this.$router.replace('/reg');
        // }
      }

      if (to.path == '/app') {
        this.pageView = 'page-view2'
      }

      // 红包页面
      if (to.path.length > 11 && to.path.substr(0, 9) == '/envelope') {
        this.pageView = 'page-view3'
      }
    },
    exchangeSkin() {},
    activeWidth: {
      handler(val, oldVal) {
        if (val <= 416) {
          this.xsShow = true
        } else {
          this.xsShow = false
        }
      },
      deep: true, //true 深度监听
      immediate: true,
    },
  },
  computed: {
    activeNav: function() {
      return this.$store.state.activeNav
    },
    isLogin: function() {
      return this.$store.getters.isLogin
    },
    member: function() {
      return this.$store.getters.member
    },
    languageValue: function() {
      var curlang = this.$store.getters.lang
      this.$i18n.locale = curlang
      if (curlang == 'en_US') {
        return 'English'
      }
      if (curlang == 'ja_JP') {
        return '日本語'
      }
      if (curlang == 'ko_KR') {
        return '한국어'
      }
      if (curlang == 'de_DE') {
        return 'Deutsche'
      }
      if (curlang == 'fr_FR') {
        return 'français'
      }
      if (curlang == 'it_IT') {
        return 'italiano'
      }
      if (curlang == 'es_ES') {
        return 'Español'
      }
      if (curlang == 'ru_RU') {
        return 'русский'
      }
      if (curlang == 'hi_IN') {
        return 'हिंदी'
      }
      if (curlang == 'zh_HK') {
        return '繁體中文'
      }
      if (curlang == 'zh_CN') {
        return '简体中文'
      }
      return curlang
    },
    lang() {
      return this.$store.state.lang
    },
    exchangeSkin() {
      return this.$store.state.exchangeSkin
    },
  },
  created: function() {
    this.initialize()
    zE('webWidget', 'hide')
    var d = new Date(),
      gmtHours = d.getTimezoneOffset() / 60
    this.utc = 'GMT ' + (gmtHours > 0 ? '-' : '+') + ' ' + String(gmtHours)[1]
    setInterval(() => {
      this.time = new Date().getTime()
    }, 1000)

    // 隐藏加载层
    let initLoading = document.getElementById('initLoading')
    if (initLoading != null) {
      document.body.removeChild(initLoading)
    }
  },
  methods: {
    reload() {
      this.isRouterAlive = false
      this.$nextTick(function() {
        this.isRouterAlive = true
      })
    },
    isMobile() {
      let flag = navigator.userAgent.match(
        /(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i
      )
      return flag
    },
    toggleMemu() {
      this.navDrawerModal = !this.navDrawerModal
    },
    strpo(str) {
      if (str.length > 4) {
        str = str.slice(0, 4) + '···'
      } else {
        str = str
      }
      return str
    },
    getUrl(type) {
      if (type == 1) {
        return '/helpdetail?cate=6&id=39&cateTitle=' + this.$t('footer.jrwm')
      } else if (type == 2) {
        return '/helplist?cate=0&cateTitle=' + this.$t('footer.xszn')
      } else if (type == 3) {
        return '/helplist?cate=1&cateTitle=' + this.$t('footer.cjwt')
      } else if (type == 4) {
        return '/helplist?cate=2&cateTitle=' + this.$t('footer.jyzn')
      } else if (type == 5) {
        return '/helplist?cate=3&cateTitle=' + this.$t('footer.bzzl')
      } else if (type == 6) {
        return '/helpdetail?cate=5&id=2&cateTitle=' + this.$t('footer.mztk')
      } else if (type == 7) {
        return '/helpdetail?cate=5&id=3&cateTitle=' + this.$t('footer.ystk')
      } else if (type == 8) {
        return '/helpdetail?cate=5&id=5&cateTitle=' + this.$t('footer.fwtk')
      } else if (type == 9) {
        return '/helpdetail?cate=5&id=38&cateTitle=' + this.$t('footer.fltk')
      }
    },
    initialize() {
      this.$store.commit('navigate', 'nav-index')
      this.$store.commit('recoveryMember')
      this.$store.commit('initLang')
      this.$store.commit('initLoginTimes')

      this.checkLogin()
    },
    logout() {
      this.$http.post(this.host + '/uc/loginout', {}).then(response => {
        var resp = response.body
        if (resp.code == 0) {
          this.$Message.success(resp.message)
          this.$store.commit('setMember', null)
          setTimeout(() => {
            location.href = '/'
          }, 1500)
        } else {
          this.$Message.error(resp.message)
        }
      })
    },
    checkLogin() {
      this.$http.post(this.host + '/uc/check/login', {}).then(response => {
        var result = response.body
        if (result.code == 0 && result.data == false) {
          this.$store.commit('setMember', null)
        }
      })
    },
    changelanguage: function(name) {
      console.log('change language: ' + name)
      if (
        name != 'en_US' &&
        name != 'ja_JP' &&
        name != 'ko_KR' &&
        name != 'de_DE' &&
        name != 'fr_FR' &&
        name != 'it_IT' &&
        name != 'es_ES' &&
        name != 'zh_HK' &&
        name != 'hi_IN' &&
        name != 'ru_RU' &&
        name != 'zh_CN'
      ) {
      } else {
        this.$store.commit('setlang', name)
        this.$i18n.locale = name
        this.reload()
      }
      // if (name == "en") {

      //    }
      //    if (name == "zh") {
      //      this.$store.commit("setlang", "简体中文");
      //      this.$i18n.locale = "zh";
      //      this.reload();
      //    }
      // if (name == "hk") {
      //   this.$store.commit("setlang", "繁体中文");
      //   this.$i18n.locale = "hk";
      //   this.reload();
      // }
      // if (name == "jp") {
      //   this.$store.commit("setlang", "日本语");
      //   this.$i18n.locale = "jp";
      //   this.reload();
      // }
      // if (name == "ko") {
      //   this.$store.commit("setlang", "韩语");
      //   this.$i18n.locale = "ko";
      //   this.reload();
      // }
      // if (name == "de") {
      //   this.$store.commit("setlang", "德语");
      //   this.$i18n.locale = "de";
      //   this.reload();
      // }
    },
  },
}
</script>

<style scoped lang="scss">
@media screen and (max-width: 768px) {
  .header_nav_mobile_triggle {
    display: inline-block !important;
  }
  .footer_content {
    width: 100%;
    padding: 20px 14px;
    padding-bottom: 50px;
  }

  .page-view,
  .page-view2 {
    .page-content {
      .layout {
        height: 45px;

        .layout-ceiling {
          padding: 5px 10px !important;

          .layout-ceiling-main {
            height: 35px !important;
            line-height: 35px !important;
          }

          .layout-logo {
            width: 200px !important;
            height: 35px !important;
          }
        }
      }
    }
  }
}

.header_nav_mobile_triggle {
  display: none;
  float: right;
  padding: 0 5px 0 20px;
}

.page-view2 .nav-pdf {
  color: #333;
  font-size: 14px;
}

.nav-pdf {
  font-size: 14px;
  color: #fff;
}

.page-view {
  height: 100%;

  .page-content {
    .time_download {
      padding: 0 80px;
      height: 35px;
      background-color: #000;
      line-height: 35px;
      overflow: hidden;

      .leftwrapper {
        float: left;

        .clock {
          display: inline-block;
          vertical-align: middle;
          color: #fff;
        }

        span {
          color: #fff;
          line-height: 35px;
          font-size: 12px;
        }
      }
    }

    .layout {
      width: 100%;
      position: absolute;
      z-index: 10;

      .layout-ceiling {
        padding: 5px 20px;

        .layout-logo {
          width: 300px;
          height: 48px;
          background: url(./assets/images/logo.png) no-repeat;
          background-size: 100% 100%;
          float: left;
          position: absolute;
          z-index: 10;
        }

        .layout-ceiling-main {
          height: 50px;
          line-height: 50px;
          margin-left: 218px;

          .header_nav {
            li.ivu-menu-submenu.ivu-menu-item-active.ivu-menu-opened.ivu-menu-child-item-active {
              background: none;

              .ivu-menu {
                a {
                  &:hover {
                    li {
                      background: none;
                      color: #f0a70a;
                    }
                  }

                  li.ivu-menu-item.ivu-menu-item-active.ivu-menu-item-selected {
                    color: #f0a70a;
                    border-bottom: 3px solid #ffa800;
                  }
                }

                .router-link-exact-active.router-link-active {
                  li {
                    color: #f0a70a;
                  }
                }
              }
            }

            .ivu-menu-vertical.ivu-menu-light {
              background: none;

              &:after {
                width: 0;
              }
            }
          }
        }

        .rr {
          float: right;
          z-index: 10;

          .mymsg {
            float: left;
            padding-right: 20px;

            a {
              color: #828ea1;
              display: inline;
              padding-right: 20px;
              border-right: 1px solid #828ea1;
            }

            a:hover {
              color: #fff;
            }
          }

          .login_register {
            float: left;
            padding-right: 20px;
            border-right: 1px solid #273c55;
            line-height: 50px;

            .ivu-menu {
              background: transparent;

              #login,
              #register {
                display: inline-block;
                min-width: 60px;
                height: 100%;
                text-align: center;
                line-height: 20px;
                margin-left: 0px;
                box-sizing: border-box;

                li {
                  height: 100%;
                  color: #828ea1;
                }

                &:hover {
                  li {
                    color: #fff;
                  }
                }
              }

              #login {
                border-right: 1px solid #273c55;
              }

              #register {
                color: #f0a70a !important;

                &:hover {
                  li {
                    color: #fff;
                  }
                }
              }
            }
          }

          .isLogin {
            .ivu-dropdown {
              display: block;
              float: left;

              .ivu-dropdown-rel {
                a {
                  margin-left: 0;
                  color: #828ea1;
                }

                a:hover {
                  color: #fff;
                }
              }

              .ivu-select-dropdown {
                position: absolute;
              }
            }
          }
        }

        .rightwrapper {
          float: right;

          .appdownload {
            float: left;
            // padding: 0 20px;
            padding-right: 0px;

            .ivu-poptip-rel {
              a {
                color: #828ea1;
              }

              i.ivu-icon.ivu-icon-arrow-down-b {
                margin-left: 5px;
              }
            }
          }

          .ios,
          .andrio {
            float: left;
            text-align: center;

            img {
              width: 116px;
              height: 116px;
              margin: 0 auto;
              border-radius: 3px;
            }

            .tips {
              height: 30px;

              img {
                width: 14px;
                height: 14px;
                margin-top: 5px;
                margin-right: 5px;
              }

              span {
                font-size: 14px;
                // color: #000;
              }
            }
          }

          .andrio {
            float: right;
          }

          .ivu-dropdown-rel a {
            color: #fff;
          }

          .ivu-select-dropdown {
            z-index: 901;

            #change_language_theme {
              li {
                background: #fff;
                color: #333;
              }
            }
          }

          .changelanguage {
            float: left;

            .languagelogo {
              float: left;
              padding-top: 5px;
              height: 45px;
              padding-left: 15px;
              margin-right: 12px;
            }
          }
        }
      }
    }
  }
}

.page-view2 {
  .ivu-select-single .ivu-select-selection {
    background-color: #0c1621;

    &:hover {
      border-color: transparent;
    }

    &:focus {
      border-color: transparent;
    }
  }

  .ivu-input-group-prepend {
    background-color: #0b1520;
    border: 1px solid #0b1520;
  }

  .page-content {
    .time_download {
      padding: 0 80px;
      height: 35px;
      background-color: #000;
      line-height: 35px;
      overflow: hidden;

      .leftwrapper {
        float: left;

        .clock {
          display: inline-block;
          vertical-align: middle;
          color: #fff;
        }

        span {
          color: #fff;
          line-height: 35px;
          font-size: 12px;
        }
      }

      .rightwrapper {
        float: right;

        .appdownload {
          float: left;
          // padding: 0 20px;
          padding-right: 30px;

          .ivu-poptip-rel {
            a {
              color: #fff;
              font-size: 12px;
            }

            i.ivu-icon.ivu-icon-arrow-down-b {
              margin-left: 5px;
            }
          }
        }

        .ios,
        .andrio {
          float: left;
          text-align: center;

          img {
            width: 106px;
            height: 106px;
            margin: 0 auto;
          }

          .tips {
            height: 30px;

            img {
              width: 14px;
              height: 14px;
              margin-top: 5px;
              margin-right: 5px;
            }

            span {
              font-size: 14px;
              // color: #000;
            }
          }
        }

        .andrio {
          float: right;
        }

        .ivu-dropdown-rel a {
          color: #fff;
        }

        .ivu-select-dropdown {
          z-index: 901;

          #change_language_theme {
            li {
              background: #fff;
              color: #333;
            }
          }
        }

        .changelanguage {
          float: left;

          .languagelogo {
            float: left;
            padding-top: 5px;
            height: 45px;
            padding-left: 15px;
            margin-right: 12px;
          }
        }
      }
    }

    .layout {
      background: #172636;
      // -moz-box-shadow:0px 2px 5px #f5f5f5;
      // -webkit-box-shadow:0px 2px 5px #f5f5f5;
      //  box-shadow:0px 2px 5px #f5f5f5;
      // border-bottom: 1px solid #eee;
      width: 100%;
      z-index: 10;
      position: absolute;
      top: 0;

      .layout-ceiling {
        padding: 5px 20px;

        .layout-logo {
          width: 300px;
          height: 48px;
          background: url(./assets/images/logo.png) no-repeat;
          background-size: 100% 100%;
          float: left;
          position: absolute;
        }

        .layout-ceiling-main {
          height: 50px;
          line-height: 50px;
          margin-left: 218px;

          .header_nav {
            display: none;

            li.ivu-menu-submenu.ivu-menu-item-active.ivu-menu-opened.ivu-menu-child-item-active {
              background: #172636;

              .ivu-menu {
                a {
                  &:hover {
                    li {
                      background: none;
                      color: #f0a70a;
                    }
                  }

                  li.ivu-menu-item.ivu-menu-item-active.ivu-menu-item-selected {
                    color: #f0a70a;
                    border-bottom: 3px solid #ffa800;
                  }

                  li {
                    color: #828ea1;
                  }
                }

                .router-link-exact-active.router-link-active {
                  li {
                    color: #f0a70a;
                  }
                }
              }
            }

            .ivu-menu-vertical.ivu-menu-light {
              &:after {
                width: 0;
              }
            }
          }
        }

        .rr {
          display: none;
          z-index: 10;
          float: right;

          .mymsg {
            float: left;
            padding-right: 20px;

            a {
              display: inline;
              padding-right: 20px;
              border-right: 1px solid #828ea1;
            }

            a:hover {
              color: #fff;
            }
          }

          .login_register {
            float: left;
            padding-right: 20px;
            border-right: 1px solid #273c55;
            line-height: 50px;

            .ivu-menu {
              background: transparent;

              #login,
              #register {
                display: inline-block;
                min-width: 60px;
                height: 100%;
                text-align: center;
                line-height: 20px;
                margin-left: 0px;
                box-sizing: border-box;

                li {
                  height: 100%;
                  color: #828ea1;
                }

                &:hover {
                  li {
                    color: #fff;
                  }
                }
              }

              #login {
                border-right: 1px solid #273c55;
              }

              #register {
                color: #f0a70a !important;

                &:hover {
                  li {
                    color: #fff;
                  }
                }
              }
            }
          }

          .isLogin {
            a {
              color: #828ea1;
            }

            a:hover {
              color: #fff;
            }

            .ivu-dropdown {
              display: block;
              float: left;

              .ivu-dropdown-rel {
                a {
                  margin-left: 0;
                }
              }

              .ivu-select-dropdown {
                position: absolute;
              }
            }
          }
        }

        .rightwrapper {
          display: none;
          float: right;

          .appdownload {
            float: left;
            // padding: 0 20px;
            padding-right: 0px;

            .ivu-poptip-rel {
              a {
                color: #828ea1;
              }

              i.ivu-icon.ivu-icon-arrow-down-b {
                margin-left: 5px;
              }
            }
          }

          .ios,
          .andrio {
            float: left;
            text-align: center;

            img {
              width: 106px;
              height: 106px;
              margin: 0 auto;
            }

            .tips {
              height: 30px;

              img {
                width: 14px;
                height: 14px;
                margin-top: 5px;
                margin-right: 5px;
                border-radius: 3px;
              }

              span {
                font-size: 14px;
                // color: #000;
              }
            }
          }

          .andrio {
            float: right;
          }

          .ivu-dropdown-rel a {
            color: #fff;
          }

          .ivu-select-dropdown {
            z-index: 901;

            #change_language_theme {
              li {
                background: #fff;
                color: #333;
              }
            }
          }

          .changelanguage {
            float: left;

            .languagelogo {
              float: left;
              padding-top: 5px;
              height: 45px;
              padding-left: 15px;
              margin-right: 12px;
            }
          }
        }
      }
    }
  }

  .footer {
    .footer_content {
      .footer_right {
        display: none;
      }
    }
  }
}

.page-view3 {
  background: linear-gradient(150deg, #c3333d, #bc000d, #ff1d2c);
  min-height: 100%;
  background-color: #fff;

  .page-content {
    padding-bottom: 20px !important;

    .layout {
      display: none;
    }

    .time_download {
      display: none;
    }
  }

  .footer {
    display: none;
  }
}

.wechatclick .api2 {
  overflow: hidden;
  display: flex;
  justify-content: space-between;
  align-items: center;

  div {
    img {
      width: 100px;
    }

    span {
      display: block;
      color: #333;
      text-align: center;
    }
  }
}

.appdownload {
  /deep/ .ivu-poptip-inner {
    background-color: #27313e;
    color: #fff;
    padding-top: 10px;
  }

  /deep/ .ivu-poptip-popper .ivu-poptip-arrow {
    border-bottom-color: #27313e;
  }

  /deep/ .ivu-poptip-popper .ivu-poptip-arrow:after {
    border-bottom-color: #27313e;
  }
}
</style>

<style lang="scss">
.container_test {
  padding-top: 60px;
}

.ivu-table-filter-list .ivu-table-filter-select-item {
  color: #ccc;

  &:hover {
    background-color: #27313e;
    color: #f0ac19;
  }
}

.ivu-table-filter-list .ivu-table-filter-select-item-selected {
  color: #f0ac19;

  &:hover {
    color: #f0ac19;
  }
}

.ivu-table-filter i.on {
  color: #fff;
}

//tips
.ivu-message {
  color: #333;
}

.ivu-poptip-inner {
  background-color: #27313e;
  color: #fff;

  .ivu-poptip-body-content-inner {
    color: #fff;
  }
}

.ivu-poptip-popper {
  // border-top-color:#27313e;
  .ivu-poptip-arrow:after {
    left: 0 !important;
    border-right-color: #27313e !important;
  }
}

/* 多选框 */
.exchange .ivu-checkbox-checked .ivu-checkbox-inner {
  background-color: #f0a70a;
  border-color: #f0a70a;
}

/* modal */
.ivu-modal-confirm-head {
  text-align: center;
  margin-bottom: 15px;
}

.ivu-modal-header p,
.ivu-modal-header-inner {
  color: #fff;
}

.ivu-modal-body {
  border-radius: 5px;

  .ivu-modal-confirm {
    .ivu-modal-confirm-body {
      font-size: 14px;
    }
  }
}

.ivu-modal-confirm-footer .ivu-btn-primary {
  background-color: #f0a70a;
  border-color: #f0a70a;
}

.ivu-modal-confirm-footer .ivu-btn-text {
  &:hover {
    color: #f0a70a;
  }
}

.ivu-table-wrapper {
  background-color: #192330;

  .ivu-table {
    box-shadow: 0px 0px 4px #27313e;
    background-color: #192330;
    color: #ccc;

    &:before {
      background: transparent;
    }

    &:after {
      background: #192330;
    }

    .ivu-table-header {
      th {
        background-color: #27313e;
        border: none;
        color: #ccc;
      }
    }

    .ivu-table-row:hover {
      background: #1e2834;
    }

    .ivu-table-row td {
      background-color: transparent;
      border: none;
      border-bottom: 1px solid #27313e;
      color: #fff;
    }
  }
}

.ivu-table td {
  background-color: #192330;
  border-bottom: 1px solid #27313e;
}

.ivu-menu-light.ivu-menu-vertical .ivu-menu-item-active:not(.ivu-menu-submenu) {
  background: none;

  &:after {
    background: none;
  }
}

.ivu-select-dropdown .ivu-select-item {
  color: #ccc;
  padding: 6px 16px;
}

.page-view {
  height: 100%;

  .page-content {
    .layout {
      .layout-ceiling {
        background: #172636;
        box-shadow: 0 0 5px 5px rgba(0, 0, 0, 0.1);

        .layout-ceiling-main {
          .header_nav {
            .ivu-menu-vertical.ivu-menu-light {
              .ivu-menu-submenu-title {
                i.ivu-icon.ivu-icon-ios-arrow-down.ivu-menu-submenu-title-icon {
                  &:before {
                    content: '';
                  }
                }
              }
            }
          }

          .rr {
            .login_register .ivu-menu-submenu-title .ivu-icon {
              &:before {
                content: '';
              }
            }
          }
        }
      }
    }
  }
}

.page-view2 {
  height: 100%;

  .page-content {
    .layout {
      .layout-ceiling {
        .layout-ceiling-main {
          .header_nav {
            .ivu-menu-vertical.ivu-menu-light {
              .ivu-menu-submenu-title {
                i.ivu-icon.ivu-icon-ios-arrow-down.ivu-menu-submenu-title-icon {
                  &:before {
                    content: '';
                  }
                }
              }
            }
          }

          .rr {
            .login_register .ivu-menu-submenu-title .ivu-icon {
              &:before {
                content: '';
              }
            }
          }
        }
      }
    }
  }
}

html,
body {
  height: 100%;
  font-size: 14px;
  background: #0b1520;
  color: #fff;
}

/*自定义滚动条样式*/

::-webkit-scrollbar {
  width: 0px;
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #39557a;
  border-radius: 25px;
}

.ivu-carousel-dots li button {
  width: 30px;
  height: 10px;
  border-radius: 14px;
}

.ivu-menu-dark,
.ivu-menu-dark.ivu-menu-vertical .ivu-menu-opened {
  background: #18202a;
}

#checkbox {
  width: 10px;
}

// .login_right {
//   position: absolute;
//   background: #fff;
//   width: 350px;
//   height: 510px;
//   top: 35px;
//   right: 50px;
// }

.login_title {
  color: #000;
  text-align: center;
  height: 80px;
  font-size: 25px;
}

.login_right .ivu-select-dropdown {
  background: #fff;
}

.ivu-form-inline .ivu-form-item {
  display: block;
  margin-right: 0;
}

.layout {
  position: absolute;
}

.layout-copy {
  text-align: center;
  padding: 10px 0 20px;
  color: #9ea7b4;
}

.layout-ceiling-main {
  height: 50px;
  line-height: 50px;
  margin-left: 128px;
}

.layout-ceiling-main .rr {
  float: right;
}

.layout-ceiling-main .ivu-menu-vertical .ivu-menu-item,
.ivu-menu-vertical .ivu-menu-submenu-title {
  padding: 0;
}

.layout-ceiling-main .ivu-menu-item {
  font-size: 14px;
}

.layout-ceiling-main a {
  color: #fff;
  display: inline-block;
  line-height: 40px;
  height: 40px;
  text-align: center;
  margin-left: 20px;
  /*padding: 0 15px;*/
}
.ivu-col {
  text-align: left !important;
}
@media screen and (max-width: 768px) {
  .header_nav {
    display: none;
  }

  .login-container {
    display: none;
  }

  .footer_right {
    display: none;
  }

  .rightwrapper {
    display: none;
  }
}

.header_nav {
  float: left;
}

.ivu-dropdown-rel a {
  width: 100%;
}

.ivu-dropdown-menu {
  width: 120px;
}

.layout-ceiling-main .ivu-select-dropdown {
  background: #27313e;
  margin-left: 25px;

  .ivu-dropdown-item {
    padding: 10px 16px;
    color: #ccc;

    &:hover {
      color: #f0ac19;
    }
  }
}

.ivu-select-dropdown a {
  width: 100%;
  text-align: left;
  margin: 0;
  height: 20px;
  line-height: 20px;
}

// .ivu-dropdown-item:hover {
//   background: #27313e;
// }

// .ivu-dropdown-item {
//   color: #fff;
// }
.ivu-dropdown-item:hover {
  background-color: #27313e;
  color: #f0ac19;
}

.ivu-dropdown-item img {
  width: 14px;
  vertical-align: middle;
}

.ivu-radio-inner:after {
  background: #18202a;
}

/*安全中心*/

.user_center {
  height: 900px;
}

.ivu-menu-item {
  text-align: center;
}

.ivu-menu-vertical .ivu-menu-submenu .ivu-menu-item {
  padding-left: 0 !important;
  padding-right: 0;
  color: rgba(130, 142, 161, 1);
  font-size: 14px;
  border-right: 0 !important;
}

.ivu-menu-dark.ivu-menu-vertical .ivu-menu-submenu .ivu-menu-item-active,
.ivu-menu-dark.ivu-menu-vertical .ivu-menu-submenu .ivu-menu-item-active:hover {
  background: #1855fd !important;
}

.rr .ivu-menu-vertical.ivu-menu-light:after {
  width: 0;
}

.layout_menu_right {
  margin-left: 3%;
  background: #18202a;
  color: #fff;
  padding-bottom: 130px;
}

.menu_right_title {
  font-size: 16px;
  line-height: 45px;
  margin: 0 10px;
  padding-left: 20px;
  border-bottom: 1px solid #263142;
}

.category .ivu-radio-group.ivu-radio-group-button {
  width: 100%;
}

.category .ivu-radio-group label {
  font-size: 14px;
}

.category .ivu-radio-group-button .ivu-radio-wrapper {
  background: #28313e;
  color: #979797;
  border: 0;
  padding: 0 25px;
}

.category .ivu-radio-group-button .ivu-radio-wrapper-checked {
  color: #fff;
  background: #2f3d52;
  box-shadow: none;
}

.category .ivu-radio-wrapper span {
  padding-left: 0;
}

.purse_address_left {
  float: left;
  width: 86%;
}

.purse_address p {
  font-size: 10px;
  line-height: 25px;
  color: #979797;
}

.purse_address_left_icon {
  line-height: 40px;
  height: 40px;
  width: 100%;
}

.purse_address_left_icon img {
  vertical-align: middle;
  margin-right: 10px;
}

.purse_address span {
  font-size: 14px;
  float: left;
  color: #fff;
  padding: 0 20px;
  background: #28313e;
  width: 21%;
}

.purse_address_left_icon label {
  float: left;
  width: 72%;
  height: 40px;
  border: 2px solid #28313e;
  padding-left: 20px;
}

#qrcode canvas {
  width: 120px;
}

#qrcode img {
  width: 100%;
}

.chart_container #chart_updated_time {
  float: left;
}

// 粘住底部布局
.page-content {
  min-height: 100%;
  padding-bottom: 200px;
}

.footer {
  width: 100%;
  overflow: hidden;
  margin-top: -200px;
  // background: #192330;
}

.footer_content {
  color: #53575c;
  width: 1200px;
  margin: 0 auto;
  padding: 40px 0;
  color: rgba(255, 255, 255, 0.8);
  text-align: left;
}

.footer_left {
  font-size: 13px;
}

.footer_left img {
  margin-bottom: 15px;
  height: 50px;
  display: block;
}

.footer_left p {
  margin: 10px 0;
  color: #828ea1;
  text-align: left;
}

.footer_right {
  text-align: left;
}

.footer_right ul {
  float: left;
  margin: 0 30px;
}

.footer_right ul li {
  list-style-type: none;
}

.footer_right ul li a {
  color: #828ea1;
  line-height: 30px;
  display: block;
  font-size: 12px;
}

.footer_right ul li a:hover {
  color: #ffffff;
}

.footer_title {
  font-size: 13px;
  height: 40px;
}

.ivu-select-selected-value {
  color: #bbbec4;
}

/*法币交易*/

.ivu-col {
  text-align: center;
}

.page-view {
  .page-content {
    .layout {
      .layout-ceiling {
        .rr {
          .login_register {
            .ivu-menu-light.ivu-menu-vertical .ivu-menu-item-active:not(.ivu-menu-submenu) {
              color: #fff;
            }
          }

          .isLogin {
            .ivu-dropdown {
              display: inline-block;

              .ivu-select-dropdown {
                padding: 0;
                margin: 0;

                .ivu-dropdown-menu {
                  .ivu-dropdown-item {
                    // background: #27313e;
                    // color: #ccc;
                    border-radius: 5px;
                    // &:hover {
                    //   background: #27313e;
                    //   color: #ccc;
                    // }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

.changelanguage {
  .ivu-dropdown {
    .ivu-select-dropdown {
      z-index: 901;
    }
  }
}

// 重置分页器颜色
.ivu-page-next,
.ivu-page-prev {
  background-color: #192330;
}

.ivu-page-item {
  background-color: #192330;
  border-color: #27313e;
}

.ivu-page-item-jump-next,
.ivu-page-item-jump-prev,
.ivu-page-next,
.ivu-page-prev {
  border-color: #27313e;
}

.ivu-page-item-active {
  // background-color: #f0ac19;
  // border-color: #f0ac19;
  // color: #fff;
  font-weight: bold;
}

.ivu-page-next:hover,
.ivu-page-prev:hover {
  border-color: #f0ac19;
}

.ivu-page-next:hover a,
.ivu-page-prev:hover a {
  color: #f0ac19;
}

.ivu-page-item-jump-prev a,
.ivu-page-item-jump-next a {
  color: #666;
}

.ivu-page-item-jump-prev a:hover,
.ivu-page-item-jump-next a:hover {
  color: #f0ac19;
}

.ivu-page-item:hover {
  border-color: #f0ac19;
}

.ivu-page-item:hover a {
  color: #f0ac19;
}

.ivu-page-item.ivu-page-item-active a {
  color: #f0ac19;
}

.ivu-page-disabled {
  a {
    cursor: not-allowed;

    .ivu-icon {
      cursor: not-allowed;
    }
  }
}

/*input框样式重置*/
.ivu-input,
.ivu-input-number-input,
.ivu-input-number {
  background-color: #192330;
  color: #fff;
  border-color: #27313e;

  &:hover {
    border-color: #27313e;
  }

  &:focus {
    border-color: #27313e;
    box-shadow: none;
  }
}

.ivu-input[disabled]:hover,
fieldset[disabled] .ivu-input:hover {
  border-color: #27313e;
}

.ivu-input[disabled],
fieldset[disabled] .ivu-input {
  background-color: #27313e;
}

.ivu-input-number-focused {
  box-shadow: none;
}

.ivu-input-number:focus {
  box-shadow: none;
}

.ivu-form .ivu-form-item-label {
  color: #ccc;
}

.ivu-input-number-handler-wrap {
  background: #27313e;
  border-left: 1px solid #192330;
}

.ivu-input-number-handler {
  border-top: 1px solid #192330;
}

.ivu-input-number-handler:hover .ivu-input-number-handler-up-inner,
.ivu-input-number-handler:hover .ivu-input-number-handler-down-inner {
  color: #ccc;
}

.ivu-input-group-append,
.ivu-input-group-prepend {
  color: #ccc;
}

/*下拉框样式重置*/
.ivu-select-selection {
  background-color: #192330;
  color: #fff;
  border: 1px solid #27313e;
}

.ivu-select-selection:hover {
  border-color: #27313e;
}

.ivu-select-visible .ivu-select-selection {
  border-color: #27313e;
  box-shadow: none;
}

.ivu-select-selected-value {
  color: #fff;
}

.ivu-select-selection-focused {
  border-color: #27313e;
}

.ivu-select-dropdown {
  background-color: #192330;
}

.ivu-select-disabled .ivu-select-selection {
  background-color: #27313e;
}

.ivu-select-disabled .ivu-select-selection:hover {
  border-color: #27313e;
}

/*下拉框*/
.ivu-select-item-selected {
  background-color: #192330;
  color: #ccc;
}

.ivu-select-item-focus {
  background-color: #192330;
}

.ivu-select-item:hover {
  background-color: #27313e;
  // color:#ccc;
  color: #f0ac19;
}

.ivu-select-multiple .ivu-select-item-selected {
  background-color: #192330;
  color: #f0ac19;
}

.ivu-select-multiple .ivu-select-item-focus,
.ivu-select-multiple .ivu-select-item-selected:hover {
  background-color: #192330;
}

.ivu-select-multiple .ivu-select-item-selected:after {
  color: #f0ac19;
}

.ivu-select-item-selected,
.ivu-select-item-selected:hover {
  background-color: #192330;
  color: #f0ac19;
}

// chexkboxes
.ivu-checkbox-inner {
  background-color: #192330;
}

// 开关
.ivu-switch {
  border: 1px solid #27313e;
  background-color: #192330;
}

.ivu-switch:after {
  background-color: #ccc;
}

// tag
.ivu-tag {
  border: 1px solid #27313e;
  border-radius: 3px;
  background: #192330;
}

.ivu-tag-text {
  color: #ccc;
}

/*table组件样式重置*/
.ivu-table-wrapper {
  border: none;
}

.ivu-table-wrapper > .ivu-spin-fix {
  background-color: rgba(0, 0, 0, 0.2);
  border: none;
  border-color: #fff;
}

.ivu-spin-fix {
  background-color: rgba(0, 0, 0, 0.2);
  border: none;
  border-color: #fff;
}

/*加载样式重置*/
.ivu-spin-dot {
  background: #f0ac19;
}

.ivu-tabs-bar {
  border-color: #f5f5f5;
}

/*日期组件样式重置*/
.ivu-picker-panel-icon-btn {
  &:hover {
    color: #f0ac19;
  }
}

.ivu-date-picker-focused input {
  border-color: #1f2936;
  box-shadow: none;
}

.ivu-date-picker-cells-focused em {
  // -moz-box-shadow: 0 0 0 1px #f0ac19 inset;
  // -webkit-box-shadow: 0 0 0 1px #f0ac19 inset;
  // box-shadow: 0 0 0 1px #f0ac19 inset;
  box-shadow: none;
  color: #f0ac19;

  &:after {
    // background: #27313e;
  }
}

.ivu-date-picker-cells-cell {
  color: #fff;
}

.ivu-date-picker-cells-cell-selected em,
.ivu-date-picker-cells-cell-selected:hover em {
  background: #27313e;
  color: #f0ac19;
}

.ivu-date-picker-cells-cell-today em:after {
  background: #27313e;
}

.ivu-date-picker-cells-cell-range:before {
  background: rgba(240, 167, 10, 0.2);
}

.ivu-date-picker-cells-cell:hover em {
  background: #27313e;
  color: #f0ac19;
}

/*按钮样式重置*/

.ivu-btn {
  border: none;
}

.ivu-btn-primary:hover {
  background: #f0ac19;
  border-color: #f0ac19;
}

.ivu-btn.ivu-btn-default {
  background-color: #27313e;
  color: #fff;

  &:hover {
    color: #f0a70a;
    // background: #27313e;
    // border: 1px solid #f0a70a;
  }

  &:active {
    color: #f0a70a;
    // border: 1px solid #f0a70a;
    // background: #27313e;
  }
}

// primary按钮
.ivu-btn-text {
  color: #ccc;
  border: 1px solid #27313e;
}

.ivu-btn-primary {
  background-color: #f0ac19;
  border-color: #f0ac19;
}

.ivu-btn-text:hover {
  background-color: transparent;
  color: #f0ac19;
}

.ivu-input-group-append,
.ivu-input-group-prepend {
  background-color: #27313e;
  border: 1px solid #27313e;
}

.ivu-form-item-error .ivu-input-group-append,
.ivu-form-item-error .ivu-input-group-prepend {
  background-color: #27313e;
  border: 1px solid #27313e;
}

.ivu-form-item-error .ivu-input,
.ivu-form-item-error .ivu-input:focus,
.ivu-form-item-error .ivu-input:hover {
  border: 1px solid #27313e;
  box-shadow: none;
}

/*radio样式重置*/
.ivu-radio-checked .ivu-radio-inner {
  border-color: #f0ac19;
}

.ivu-radio-checked:hover {
  .ivu-radio-inner {
    border-color: #f0ac19;
  }
}

.ivu-radio-inner:after {
  background: #f0ac19;
}

.ivu-switch-checked {
  border-color: #f0ac19;
  background-color: #f0ac19;
}

.ivu-switch:focus {
  box-shadow: none;
}

.ivu-radio-focus {
  box-shadow: none;
}

//弹窗
.ivu-modal-content {
  background-color: #192330;
}

.ivu-modal-header {
  border-bottom: 1px solid #27313e;
}

.ivu-modal-confirm-head-icon-confirm {
  color: #fff;
}

.ivu-modal-header p {
  color: #fff;
}

.ivu-modal-footer {
  border-top: 1px solid #27313e;
}

/*排序小箭头样式重置*/
.ivu-table-sort i.on {
  color: #f0ac19;
}

.ivu-table-sort i:hover {
  color: #f0ac19;
}

.ivu-modal-confirm-head-icon {
  font-size: 24px;
}

.ivu-modal-confirm-body {
  color: #fff;
  padding-left: 0;
}

.ivu-modal-confirm-head-title {
  color: #fff;
  margin-left: 5px;
}

.ivu-modal-confirm-footer {
  padding-top: 10px;
  border-top: 1px solid #27313e;
}

// 上传组件
.ivu-upload-list-file:hover {
  background-color: #27313e;
}

.ivu-menu-light.ivu-menu-horizontal .ivu-menu-item-active,
.ivu-menu-light.ivu-menu-horizontal .ivu-menu-item:hover,
.ivu-menu-light.ivu-menu-horizontal .ivu-menu-submenu-active,
.ivu-menu-light.ivu-menu-horizontal .ivu-menu-submenu:hover {
  border-bottom: 0 !important;
  color: #828ea1 !important;
}

.ivu-menu-horizontal .ivu-menu-submenu .ivu-select-dropdown .ivu-menu-item:hover {
  background: #2f3e51 !important;
}

.ivu-menu-horizontal.ivu-menu-light {
  background: transparent !important;
}

.ivu-menu-horizontal.ivu-menu-light:after {
  height: 0 !important;
}

.ivu-select-dropdown {
  border-radius: 0 !important;
}

.lang-img {
  height: 20px;
  margin-bottom: -5px;
  margin-right: 5px;
}

.lang-item {
  text-align: left;

  img {
    height: 20px;
    margin-bottom: -5px;
    margin-right: 5px;
  }

  &:hover {
    background: #2f3e51;
  }
}

.ivu-message-notice-content {
  background: #324368;
  color: #a3bbcc;
}

.social-list {
  display: block;
  ul {
    list-style: none;
    padding-top: 5px;
    li {
      transition: all 0.5s;
      width: 25px;
      height: 25px;
      line-height: 25px;
      border-radius: 2px;
      background: rgb(57, 69, 89);
      text-align: center;
      float: left;
      margin-right: 8px;
      color: #a3b6c6;

      &:hover {
        color: #fff;
        cursor: pointer;
      }
    }
  }
}

.ivu-tooltip-inner {
  background: #394559;
}

.ivu-tooltip-arrow {
  border-bottom-color: #394559;
}

.ivu-notice-notice {
  background: #21364d;
}

.ivu-notice-title {
  color: #ffffff;
}

.ivu-notice-desc {
  color: #ffffff;
}

.swiper-pagination-fraction,
.swiper-pagination-custom,
.swiper-container-horizontal > .swiper-pagination-bullets {
  bottom: -5px;
}

.swiper-pagination-bullet {
  background: #fff;
  border-radius: 2px;
  height: 3px;
  width: 15px;
  opacity: 0.3;
  transition: all 0.5s;
}

.swiper-pagination-bullet-active {
  background: #f0a70a !important;
  width: 30px;
  opacity: 1;
}

.login_right .ivu-select-dropdown {
  background: #212b36;
}

.login_right .ivu-select-dropdown .ivu-select-item {
  text-align: left;
}

.ivu-form-item-error .ivu-input-group-append,
.ivu-form-item-error .ivu-input-group-prepend,
.ivu-input-group-append,
.ivu-input-group-prepend {
  background-color: #17212e;
  border-bottom: 1px solid #27313e;
  border-top: none;
  border-left: none;
  border-right: none;
}

.ivu-select-single .ivu-select-selection {
  background-color: #17212e;
}

.login_form {
  /* WebKit browsers */
  input::-webkit-input-placeholder {
    color: #8a8a8acf !important;
    font-size: 0.95rem !important;
    letter-spacing: 1px !important;
  }

  /* Mozilla Firefox 4 to 18 */
  input:-moz-placeholder {
    color: #8a8a8a !important;
    font-size: 13px !important;
    letter-spacing: 1px !important;
  }

  /* Mozilla Firefox 19+ */
  input::-moz-placeholder {
    color: #8a8a8a !important;
    font-size: 13px !important;
    letter-spacing: 1px !important;
  }

  /* Internet Explorer 10+ */
  input::-ms-input-placeholder {
    color: #8a8a8a !important;
    font-size: 13px !important;
    letter-spacing: 1px !important;
  }

  .ivu-input-group-prepend {
    font-size: 0.95rem;
    letter-spacing: 1px;
  }
}

.login_form
  .login_right
  form.ivu-form.ivu-form-label-right.ivu-form-inline
  .password
  .ivu-form-item-content
  .ivu-input-wrapper.ivu-input-type
  .ivu-input {
  letter-spacing: 8px;
}

.ivu-menu-light {
  background: transparent !important;
}

.ivu-spin-fullscreen-wrapper {
  background: #46597a70 !important;
}

.ivu-spin {
  color: #f0a70a !important;
}

.ivu-poptip-popper[x-placement^='bottom'] .ivu-poptip-arrow {
  border-bottom-color: #27313e;
}

.ivu-poptip-popper[x-placement^='bottom'] .ivu-poptip-arrow:after {
  border-bottom-color: #27313e;
}

.ivu-poptip-title-inner {
  color: #ccc;
  font-size: 14px;
}

.ivu-poptip-title:after {
  background-color: #394253;
}

.tag-hot {
  display: inline-block;
  padding: 0 4px;
  background: #ff0000;
  color: #fff;
  line-height: 16px;
  font-size: 10px;
  margin-left: 5px;
  margin-top: -5px;
  border-radius: 2px;
  position: absolute;
  top: 16px;
  font-weight: 600;
}

.page {
  text-align: right;
  margin-top: 10px;

  .ivu-page {
    .ivu-page-prev,
    .ivu-page-next {
      background: transparent !important;
      color: #000;
      border: none;
    }

    .ivu-page-item {
      background-color: transparent !important;
      color: #000;
      border: none;
    }
  }
}

.ivu-progress-bg {
  border-radius: 0 !important;
  background-color: #ff8100;
  max-width: 100%;
}

.ivu-progress-success .ivu-progress-bg {
  background-color: #ff8100 !important;
}

.header_nav_mobile .ivu-menu-vertical .ivu-menu-item,
.header_nav_mobile .ivu-menu-vertical .ivu-menu-submenu-title {
  padding: 8px 24px 8px 5px;
  color: #828ea1;
}

.header_nav_mobile .ivu-drawer-wrap .ivu-drawer-no-header .ivu-drawer-content .ivu-drawer-body {
  background: #2b323a;
  padding-top: 60px;
}

.header_nav_mobile .ivu-menu-vertical.ivu-menu-light:after {
  background: transparent !important;
}

.header_nav_mobile .ivu-menu-light.ivu-menu-vertical .ivu-menu-item-active:not(.ivu-menu-submenu) {
  color: #f0a70a;
}

.ivu-col {
  text-align: left !important;
}
</style>
