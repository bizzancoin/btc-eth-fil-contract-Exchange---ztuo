## This project is the IOS end of the ZTuo digital asset trading platform

This source code is limited to exchange and study, where it involves legal issues and I have nothing to do with it


- ## [简体中文](README.md)
---
# Donate:
#### Your donation is our biggest motivation for open source
- BTC/USDT (Bitcoin/USDT): 1Dwwqhw9pV9iSSQwuJc8nAygda7XfahaoW
- ETH/USDT (Ethereum/USDT): 0x4f1ea0f10aa99f608f31f70b4d3119f6928693ed
- LTC (Litecoin): LXr4TMtDhCSpdAo98vg2sbvX3UXDVPQvMa

## Join us
    In order to facilitate everyone to communicate and learn, please join the QQ exchange group:
    *Blockchain exchange technical knowledge exchange group [QQ group: 735446452]


**Instructions**</r>
- The last use environment of the code is: Xcode10.0, the minimum supported version is iOS8.0 </n>

- Three-party library description, part of the three-party library in this project is managed by cocoapods, and the three-party library used: [cocoapods installation tutorial](https://www.jianshu.com/p/1bb0ad42cb2e)</r>
1. AFNetworking (a lightweight network request library)</r>
2. SDWebImage (asynchronous image download program with cache support)</r>
3. FMDB (Objective-C package around SQLite)</r>
4. Masonry (a lightweight layout framework)</r>
5. IQKeyboardManager (No code plug-in universal library to prevent keyboard sliding problems)</r>
6. CocoaAsyncSocket (asynchronous socket library)</r>
7. Youmeng Statistics</r>
8. Baidu Statistics</r>
9. MJRefresh</r>
10. Tencent waterproof verification</r>

 **Notes**</r>
1. Test on real machine for personal developer account. Push is removed from the project. If necessary, please add it yourself. </r>
2. Baidu and Youmeng statistics integrated in the project, if necessary, please apply for relevant information yourself. </r></r>
3. The defined global constants are in the constant.h file

 **Introduction to structure**</r>
- resource image resource file </r>
- Thirdpart encapsulated class </r>
- Remote network request encapsulation </r>
- Common categories </r>
- Controllers Business Controller Directory </r>

**Data communication socket**</r>

Socket communications in the project are all managed by the SocketManager class.</r>

Service subscription method:</r>
- `- (void)sendMsgWithLength:(int)length withsequenceId:(long)sequenceId withcmd:(short)cmd withVersion:(int)Version withRequestId:(int)RequestId withbody:(NSDictionary*)jsonDict;`</r>

This method is to subscribe to all socket links, the following is the meaning of the parameters:</r>
- length The fixed byte length of the message header</r>
- sequenceId token</r>
- cmd subscription service type</r>
- RequestId </r>
- jsonDict extends json object</r>
- Note: The parameters for subscribing to socket push are negotiated with the server. If there are changes, you need to negotiate with the server</r>

Subscription message callback agent method:</n>
- `- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;`</n>
- All subscription service callbacks will execute this proxy method, and the data data response header of the callback needs to be processed. If there is a subscription service, this proxy method must be implemented</r>
 ```
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //cmd is the service type of the response, in order to process the corresponding business
 }
 ```

**common problem** 

Certificate error:
- Select Project->Capabilities->Push Notifications to close this option
- Select Project->Capabilities->Background Modes to close this option

Path error:
- Select the project->Build settings->Prefix Header and drag the PrefixHeader.pch in the project here.