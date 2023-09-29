package com.bizzan.bitrade.entity;

import lombok.Data;

import java.util.Date;

import javax.persistence.*;

import org.hibernate.annotations.CreationTimestamp;

import com.bizzan.bitrade.constant.PromotionLevel;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年03月08日
 */
@Entity
@Data
public class MemberPromotion {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    //邀请者Id
    private Long inviterId;
    //受邀者Id
    private Long inviteesId;

    @Enumerated(EnumType.ORDINAL)
    private PromotionLevel level;
    
    @CreationTimestamp
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createTime;
}
