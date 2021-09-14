package com.bizzan.bitrade.entity;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

/**
 * 国家
 *
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年02月10日
 */
@Data
@Entity
public class Country {
    /**
     * 中文名称
     */
    @Id
    private String zhName;

    /**
     * 英文名称
     */
    private String enName;

    /**
     * 区号
     */
    private String areaCode;
    /**
     * 语言
     */
    private String language;

    /**
     * 当地货币缩写
     */
    private String localCurrency;

    private int sort;

}
