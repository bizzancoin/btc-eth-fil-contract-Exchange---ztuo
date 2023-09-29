package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * 地址
 *
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年01月02日
 */
@Data
@Embeddable
public class Location implements Serializable {
    private String country;
    private String province;
    private String city;
    private String district;
}
