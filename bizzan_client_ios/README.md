## 本项目为ZTuo数字资产交易平台IOS端

本源码仅限于交流学习，凡涉及到法律问题与本人无关



- ## [English](README-EN.md)
---
# 捐赠:
#### 您的捐赠是我们开源最大的动力
- BTC/USDT(比特币/USDT)：1Dwwqhw9pV9iSSQwuJc8nAygda7XfahaoW
- ETH/USDT(以太坊/USDT)：0x4f1ea0f10aa99f608f31f70b4d3119f6928693ed
- LTC(莱特币)：LXr4TMtDhCSpdAo98vg2sbvX3UXDVPQvMa

## 加入我们
    为方便大家交流和学习，请各位小伙伴加入QQ交流群：
	*区块链交易所技术知识交流群【QQ群：735446452】


**说明文档**</r>
- 代码的最后使用环境是：Xcode10.0, 最低支持版本iOS8.0 </n>

- 三方库说明，本项目部分三方库使用cocoapods管理，所使用三方库：[cocoapods安装教程](https://www.jianshu.com/p/1bb0ad42cb2e)</r>
1. AFNetworking（一个轻量级的网络请求库）</r> 
2. SDWebImage（具有缓存支持的异步映像下载程序）</r>
3. FMDB（围绕SQLite的Objective-C封装）</r>
4. Masonry（一个轻量级的布局框架）</r>
5. IQKeyboardManager（无代码插入式通用库防止键盘滑动问题）</r>
6. CocoaAsyncSocket（异步套接字库）</r>
7. 友盟统计</r>
8. 百度统计</r>
9. MJRefresh</r>
10. 腾讯防水校验</r>

 **注意事项**</r>
1. 为个人开发者账号真机测试，项目去掉了推送，如有需要请自行添加。</r>
2. 项目中集成的百度和友盟统计，如有需要请自己申请相关资料。</r></r>
3. 定义的全局常量在constant.h文件中

 **结构简介**</r>
- resource 图片资源文件 </r>
- Thirdpart 封装的类 </r>
- Remote 网络请求封装 </r>
- Common 常用分类 </r>
- Controllers 业务控制器目录 </r>

**数据通讯socket**</r>

工程中socket通讯都由SocketManager类同一管理</r>

服务订阅方法：</r>
- `- (void)sendMsgWithLength:(int)length withsequenceId:(long)sequenceId withcmd:(short)cmd withVersion:(int)Version withRequestId:(int)RequestId withbody:(NSDictionary*)jsonDict;`</r>

此方法是订阅所有socket链接的方法，以下是参数含义：</r>
- length 消息头固定字节长度</r>
- sequenceId token</r>
- cmd 订阅服务类型</r>
- RequestId </r>
- jsonDict 扩展json对象</r>
- 注意：订阅socket推送的参数都是与服务端协商好的，如果有变动需要与服务端协商沟通</r>

订阅消息回调代理方法：</n>
- `- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;`</n>
- 所有的订阅服务回调都会执行此代理方法，需要对回调的data数据响应头做处理，如有订阅服务必须实现此代理方法</r>
 ```
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //cmd便是响应的服务类型，以此来处理相应的业务
 }
 ```

**常见问题** 

证书报错：
- 选择工程->Capabilities->Push Notifications 关闭此选项
- 选择工程->Capabilities->Background Modes 关闭此选项

路径报错：
- 选择工程->Build settings->Prefix Header 把工程中PrefixHeader.pch拖入此处即可
