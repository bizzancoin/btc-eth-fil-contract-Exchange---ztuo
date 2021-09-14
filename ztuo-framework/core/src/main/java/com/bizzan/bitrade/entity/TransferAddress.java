package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.*;

import com.bizzan.bitrade.constant.CommonStatus;

import java.math.BigDecimal;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年02月27日
 */
@Entity
@Data
public class TransferAddress {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    @JoinColumn(name = "coin_id")
    @ManyToOne
    private Coin coin;
    private String address;
    @Column(columnDefinition = "decimal(18,6) comment '转账手续费率'")
    private BigDecimal transferFee=BigDecimal.ZERO;
    @Column(columnDefinition = "decimal(18,2) comment '最低转账数目'")
    private BigDecimal minAmount=BigDecimal.ZERO;
    @Enumerated(EnumType.ORDINAL)
    private CommonStatus status=CommonStatus.NORMAL;
}
