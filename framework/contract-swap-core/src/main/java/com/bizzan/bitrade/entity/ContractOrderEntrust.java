package com.bizzan.bitrade.entity;

import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Data
@Table
public class ContractOrderEntrust implements Serializable {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private Long contractId; // 合约ID

    private Long memberId; // 用户ID

    private String contractOrderEntrustId; // 合约委托订单ID（自动生成）

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(11) default 1 comment '仓位模式'")
    private ContractOrderPattern patterns; // 0全仓 1逐仓

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(11) default 0 comment '委托订单类型'")
    private ContractOrderEntrustType entrustType; // 0 开仓 1 平仓 ｜ 与 direction 配合（）

    @Enumerated(EnumType.ORDINAL)
    @Column(columnDefinition = "int(11) default 1 comment '方向'")
    private ContractOrderDirection direction; // 0买 1卖

    @Enumerated(EnumType.ORDINAL)
    private ContractOrderType type; //委托类型 0市价 1限价 2计划委托

    private String symbol;//交易对符号
    private String coinSymbol;//币单位
    private String baseSymbol;//结算单位

    private BigDecimal triggerPrice;// 触发价(委托方式是计划/限价必填)

    private BigDecimal entrustPrice;// 委托价(委托方式是计划/限价必填)

    private BigDecimal tradedPrice;// 成交均价

    private String principalUnit;// 本金单位（如：USDT）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '本金数量'")
    private BigDecimal principalAmount;// 冻结保证金

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '下单时价'")
    private BigDecimal currentPrice;// 下单时价

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开仓手续费'")
    private BigDecimal openFee;// 开仓手续费

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '开仓手续费'")
    private BigDecimal closeFee;// 平仓手续费

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '合约面值'")
    private BigDecimal shareNumber;// 合约面值

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '委托数量'")
    private BigDecimal volume;// 委托数量（张）

    @Column(columnDefinition = "decimal(18,8) DEFAULT 0 comment '委托数量'")
    private BigDecimal tradedVolume;// 成交数量（张）

    @Column(columnDefinition = "decimal(18,8) default 0 comment '盈亏'")
    private BigDecimal profitAndLoss;// 盈亏金额

    private ContractOrderEntrustStatus status;// 0:委托中/1:已撤销/2:委托失败/3:委托成功

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long createTime;//创建时间

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Long triggeringTime;//触发时间

    @Column(columnDefinition = "int(2) default 0 comment '是否是计划委托的委托单'")
    private int isFromSpot;// 是否是计划委托的委托单，0：否，1：是

    @Column(columnDefinition = "int(2) default 0 comment '是否是计划委托的委托单'")
    private int isBlast;// 是否是爆仓单，0：否，1：是

    @Column(columnDefinition = "int(2) default 0 comment '是否已返佣'")
    private int isReward;// 是否已返佣，0：否，1：是

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }
}
