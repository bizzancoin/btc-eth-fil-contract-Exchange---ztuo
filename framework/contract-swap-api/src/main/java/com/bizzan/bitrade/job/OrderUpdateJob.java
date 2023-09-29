package com.bizzan.bitrade.job;


import com.alibaba.fastjson.JSON;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class OrderUpdateJob {

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;
    private Logger logger = LoggerFactory.getLogger(OrderUpdateJob.class);

    // 5分钟检查一次超时订单
    @Scheduled(fixedRate = 300*1000)
    public void autoCancelOrder(){

    }


}
