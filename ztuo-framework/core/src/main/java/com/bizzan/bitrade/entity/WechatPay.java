package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * 微信信息
 *
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年01月16日
 */
@Data
@Embeddable
public class WechatPay implements Serializable {
    private static final long serialVersionUID = 1511509989072675896L;
    /**
     * 微信号
     */
    private String wechat;


    /**
     * 微信收款二维码
     */
    private String qrWeCodeUrl;
}
