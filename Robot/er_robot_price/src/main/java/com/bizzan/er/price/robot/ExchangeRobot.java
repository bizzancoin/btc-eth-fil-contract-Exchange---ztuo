package com.bizzan.er.price.robot;

import java.math.BigDecimal;
import java.time.Instant;

import org.springframework.web.client.RestTemplate;

import com.bizzan.er.price.entity.PriceRobotParams;
import com.bizzan.er.price.service.RobotParamService;

public interface ExchangeRobot{
	
	/**
	 * 获取机器人参数
	 * @return
	 */
	public PriceRobotParams getRobotParams();
	
	/**
	 * 设置机器人参数
	 * @param params
	 */
	public void setRobotParams(PriceRobotParams params);
	
	public void setPlateSymbol(String symbol);
	
	/**
	 * 更新机器人参数
	 * @param params
	 */
	public void updateRobotParams(PriceRobotParams params);
	
	public void startRobot();
	
	public void stopRobot();
	
	public void setRobotParamSevice(RobotParamService service);
	
	public void setRestTemplate(RestTemplate rest);
	
	public Instant getLastSendOrderTime();
}
