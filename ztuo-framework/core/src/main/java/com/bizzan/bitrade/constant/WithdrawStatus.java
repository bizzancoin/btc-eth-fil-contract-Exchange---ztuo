package com.bizzan.bitrade.constant;

import com.bizzan.bitrade.core.BaseEnum;
import com.fasterxml.jackson.annotation.JsonValue;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年02月25日
 */
@AllArgsConstructor
@Getter
public enum WithdrawStatus implements BaseEnum {
    PROCESSING("审核中"),WAITING("等待放币"),FAIL("失败"), SUCCESS("成功");
    private String cnName;
    @Override
    @JsonValue
    public int getOrdinal() {
        return this.ordinal();
    }
}
