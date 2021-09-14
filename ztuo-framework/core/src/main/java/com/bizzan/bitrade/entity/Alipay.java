package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * 支付宝信息
 *
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年01月16日
 */
@Data
@Embeddable
public class Alipay implements Serializable {
    private static final long serialVersionUID = 8317734763036284945L;
    /**
     * 支付宝帐号
     */
    private String aliNo;
    /**
     * 支付宝收款二维码
     */
    private String qrCodeUrl;
}
