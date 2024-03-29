package com.bizzan.bitrade.entity;

import com.bizzan.bitrade.constant.ActivityRewardType;
import com.bizzan.bitrade.constant.BooleanEnum;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.util.Date;

/**
 * 推荐奖励设置
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年03月08日
 */
@Data
@Entity
public class RewardActivitySetting {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    @JoinColumn(name = "coin_id", nullable = false)
    @ManyToOne
    private Coin coin;
    /**
     * 启用禁用
     */
    @Enumerated(EnumType.ORDINAL)
    private BooleanEnum status = BooleanEnum.IS_FALSE;

    @Enumerated(EnumType.ORDINAL)
    private ActivityRewardType type;
    /**
     * 注册奖励：{"amount": 0.5}
     * <p>
     *
     */
    private String info;

    @UpdateTimestamp
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date updateTime;

    /**
     * 最近更改者
     */
    @JoinColumn(name = "admin_id")
    @ManyToOne
    private Admin admin;
}
