package com.bizzan.utils;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class BigDecimalUtil {

    public static BigDecimal add(BigDecimal valA, BigDecimal valB, int scale){
        return valA.add(valB).setScale(scale, RoundingMode.HALF_UP);
    }

    public static BigDecimal multiply(BigDecimal valA, BigDecimal valB, int scale){
        return valA.multiply(valB).setScale(scale, RoundingMode.HALF_UP);
    }

    public static BigDecimal addNew(BigDecimal valA, BigDecimal valB,BigDecimal valC,BigDecimal valD,BigDecimal valE, int scale){
        return valA.add(valB).add(valC).add(valD).add(valE).setScale(scale, RoundingMode.HALF_UP);
    }
}
