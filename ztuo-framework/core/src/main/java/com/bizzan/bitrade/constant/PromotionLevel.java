package com.bizzan.bitrade.constant;

import com.bizzan.bitrade.core.BaseEnum;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年03月08日
 */
@AllArgsConstructor
@Getter
public enum PromotionLevel implements BaseEnum {
    /**
     * 一级
     */
    ONE("一级"),
    /**
     * 二级
     */
    TWO("二级"),
    /**
     * 三级
     */
    THREE("三级");
    @Setter
    private String cnName;

    @Override
    @JsonValue
    public int getOrdinal() {
        return ordinal();
    }
}
