package com.bizzan.bitrade.entity;

import com.bizzan.bitrade.constant.ContractRewardRecordType;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 合约返佣记录
 */
@Data
@Entity
public class ContractRewardRecord {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;
    @JoinColumn(name = "coin_id", nullable = false)
    @ManyToOne
    private Coin coin;
    @Enumerated(EnumType.ORDINAL)
    private ContractRewardRecordType type;
    @Column(columnDefinition = "decimal(18,8) comment '奖励数量'")
    private BigDecimal num;

    @JoinColumn(name = "member_id", nullable = false)
    @ManyToOne
    private Member member;

    @JoinColumn(name = "from_member_id", nullable = false)
    @ManyToOne
    private Member fromMember;
    @JoinColumn(name = "order_id", nullable = false)
    @ManyToOne
    private ContractOrderEntrust contractOrderEntrust;
    /**
     * 创建时间
     */
    @CreationTimestamp
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
}
