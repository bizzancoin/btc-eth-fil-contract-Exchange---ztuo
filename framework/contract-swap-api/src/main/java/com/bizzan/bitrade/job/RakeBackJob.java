package com.bizzan.bitrade.job;


import com.bizzan.bitrade.entity.ContractOrderEntrust;
import com.bizzan.bitrade.service.ContractOrderEntrustService;
import com.bizzan.bitrade.service.ContractRewardRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class RakeBackJob {
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;
    private Logger logger = LoggerFactory.getLogger(OrderUpdateJob.class);

    @Autowired
    private ContractOrderEntrustService contractOrderEntrustService;
    @Autowired
    private ContractRewardRecordService contractRewardRecordService;

    // 5分钟一次合约返佣
//    @Scheduled(fixedRate = 300*1000)
    public void autoCancelOrder(){
        logger.info("start rake back...");
        List<ContractOrderEntrust> list = contractOrderEntrustService.findCanRewardOrders();
        if(list!=null && list.size()>0){
            for(ContractOrderEntrust orderEntrust:list){
                contractRewardRecordService.sendReward(orderEntrust);
            }
        }
        logger.info("end rake back...");
    }


}
