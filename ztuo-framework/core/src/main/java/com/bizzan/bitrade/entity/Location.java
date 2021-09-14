package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.Embeddable;
import java.io.Serializable;

/**
 * 地址
 *
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
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
