### 项目说明
  数字货币交易所Android端，从线上版本简化出来的基础版本，支持查看各交易对的即时行情数据(socket)，币币
  交易，法币交易，首页广告图轮播、公告轮播、涨幅榜展示，个人中心个人信息绑定、实名认证，手势密码，聊天等。
#### 结构简介
  adapter-适配器  
  app-全局类  
  base-基类  
  customview-自定义view  
  data-数据处理  
  entity-数据实体类  
  service-服务  
  socket-socket通信  
  ui-界面(mvp)  
  utils-工具  
 #### 三方库及以依赖的项目
  geetest-极验  
  umeng-友盟统计  
  PickerView-时间或者银行选择器  
  Butterknife-view注入框架  
  permission-权限请求框架  
  niceSpinner-下拉选择框  
  marqueeview-公告轮播(跑马灯效果)  
  lib-zxing-二维码  
  kchartlib-k线图  
  MPChatLib-k线图
#### 项目运行
  1.把UrlConfig中各个url改为对应的url,并根据实际情况在socket包中对应的socket类里修改端口号等配置,
  其他socket需求请查看ISocket中枚举CMD或另行添加;  
  2.如需统计功能，在manifest中配置友盟的appkey;
 ####维护计划
  1.清理无效代码和资源，修改不规范代码  
  2.重写网络请求和数据解析
  