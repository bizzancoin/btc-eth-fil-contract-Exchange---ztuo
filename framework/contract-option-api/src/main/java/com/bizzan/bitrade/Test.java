package com.bizzan.bitrade;

public class Test {

    public static void main(String[] args) {
        String tem = "btcusdt";
        StringBuilder sb = new StringBuilder(tem);
        sb.insert(tem.indexOf("usdt"), "/");
        System.out.println(sb.toString().toUpperCase());
    }


}
