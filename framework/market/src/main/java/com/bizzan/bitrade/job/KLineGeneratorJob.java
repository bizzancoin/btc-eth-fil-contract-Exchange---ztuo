package com.bizzan.bitrade.job;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;

import com.bizzan.bitrade.processor.CoinProcessor;
import com.bizzan.bitrade.processor.CoinProcessorFactory;
import com.bizzan.bitrade.service.ExchangeCoinService;

import java.util.Calendar;
import java.util.HashMap;

/**
 * 生成各时间段的K线信息
 *
 */
@Component
@Slf4j
public class KLineGeneratorJob {
    @Autowired
    private CoinProcessorFactory processorFactory;
    @Autowired
    private ExchangeCoinService coinService;

	@Autowired
	private TaskExecutor taskExecutor;

    /**
     * 每分钟定时器，处理分钟K线
     */
    @Scheduled(cron = "0 * * * * *")
    public void handle5minKLine(){
        Calendar calendar = Calendar.getInstance();
        log.info("分钟K线:{}",calendar.getTime());
        //将秒、微秒字段置为0
        calendar.set(Calendar.SECOND,0);
        calendar.set(Calendar.MILLISECOND,0);
        long time = calendar.getTimeInMillis();
        int minute = calendar.get(Calendar.MINUTE);
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        processorFactory.getProcessorMap().forEach((symbol,processor)->{
        	if(!processor.isStopKline()) {
				taskExecutor.execute(new Runnable() {
					@Override
					public void run() {
						processor.generateKLine(time, minute, hour);
					}
				});
			}
        });
    }

	/**
     * 每小时运行
     */
    @Scheduled(cron = "0 0 * * * *")
    public void handleHourKLine(){
        processorFactory.getProcessorMap().forEach((symbol,processor)-> {
        	if(!processor.isStopKline()) {
	            Calendar calendar = Calendar.getInstance();
	            log.info("小时K线:{}",calendar.getTime());
	            //将秒、微秒字段置为0
	            calendar.set(Calendar.MINUTE, 0);
	            calendar.set(Calendar.SECOND, 0);
	            calendar.set(Calendar.MILLISECOND, 0);
	            long time = calendar.getTimeInMillis();
	
	            processor.generateKLine(1, Calendar.HOUR_OF_DAY, time);
        	}
        });
    }

    /**
     * 每日0点处理器，处理日K线
     */
    @Scheduled(cron = "0 0 0 * * *")
    public void handleDayKLine(){
        processorFactory.getProcessorMap().forEach((symbol,processor)->{
        	if(!processor.isStopKline()) {
	            Calendar calendar = Calendar.getInstance();
	            log.info("日K线:{}",calendar.getTime());
	            //将秒、微秒字段置为0
	            calendar.set(Calendar.HOUR_OF_DAY,0);
	            calendar.set(Calendar.MINUTE,0);
	            calendar.set(Calendar.SECOND,0);
	            calendar.set(Calendar.MILLISECOND,0);
	            long time = calendar.getTimeInMillis();
	            int week = calendar.get(Calendar.DAY_OF_WEEK);
	            int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
	            if(week == 1){
	                processor.generateKLine(1, Calendar.DAY_OF_WEEK, time);
	            }
	            if(dayOfMonth == 1){
	                processor.generateKLine(1, Calendar.DAY_OF_MONTH, time);
	            }
	            processor.generateKLine(1, Calendar.DAY_OF_YEAR,time);
        	}
        });
    }
}
