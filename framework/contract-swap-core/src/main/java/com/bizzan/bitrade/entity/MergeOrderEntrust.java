package com.bizzan.bitrade.entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class MergeOrderEntrust {
    private List<ContractOrderEntrust> orders = new ArrayList<>();

    //最后位置添加一个
    public void add(ContractOrderEntrust order){
        orders.add(order);
    }

    public ContractOrderEntrust get(){
        return orders.get(0);
    }

    public int size(){
        return orders.size();
    }

    public BigDecimal getEntrustPrice(){
        return orders.get(0).getEntrustPrice();
    }

    public Iterator<ContractOrderEntrust> iterator(){
        return orders.iterator();
    }
    
    public BigDecimal getTotalVolume() {
    	BigDecimal total = new BigDecimal(0);
    	for(ContractOrderEntrust item : orders) {
    		total = total.add(item.getVolume());
    	}
    	return total;
    }
}
