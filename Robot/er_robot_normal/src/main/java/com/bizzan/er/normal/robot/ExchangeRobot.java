package com.bizzan.er.normal.robot;

import java.math.BigDecimal;
import java.time.Instant;

import org.springframework.web.client.RestTemplate;

import com.bizzan.er.normal.entity.RobotParams;
import com.bizzan.er.normal.service.CustomRobotKlineService;
import com.bizzan.er.normal.service.RobotParamService;
import sun.rmi.server.InactiveGroupException;

public interface ExchangeRobot{
	//设置机器人需要操作的交易所地址
	public static final String EXCHANGE_GATE_WAY = "http://172.19.0.3:8801";
	
	/**
	 * 获取外部价格
	 * @return
	 */
	public BigDecimal getOuterPrice();
	
	/**
	 * 获取机器人参数
	 * @return
	 */
	public RobotParams getRobotParams();
	
	/**
	 * 设置机器人参数
	 * @param params
	 */
	public void setRobotParams(RobotParams params);
	
	public void setPlateSymbol(String symbol);
	
	/**
	 * 更新机器人参数
	 * @param params
	 */
	public void updateRobotParams(RobotParams params);
	
	public void startRobot();
	
	public void stopRobot();
	
	public void setRobotParamSevice(RobotParamService service);
	
	public void setRestTemplate(RestTemplate rest);
	
	public Instant getLastSendOrderTime();
	
	public void setCustomRobotKlineService(CustomRobotKlineService service); // 控盘机器人专用
	
	public boolean reloadCustomRobotKline(); // 重载k线数据，控盘机器人专用

	public void interrupt();

	public boolean isRunning();

	public void setRobotStrategy(int strategy, String flowPair, BigDecimal flowPercent);
}
