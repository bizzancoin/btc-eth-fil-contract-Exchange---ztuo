package com.bizzan.bitrade.util;

import org.springframework.validation.BindingResult;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年12月08日
 */
public class BindingResultUtil {
    public static MessageResult validate(BindingResult bindingResult){
        if (bindingResult.hasErrors()){
            String message=bindingResult.getFieldError().getDefaultMessage();
            return MessageResult.error(500, message);
        }else {
            return null;
        }
    }
}
