package com.bizzan.er.price.robot;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;

import com.bizzan.er.price.entity.PriceRobotParams;
import com.bizzan.er.price.service.RobotParamService;

public class ExchangeRobotFactory {
	
	private ConcurrentHashMap<String, ExchangeRobot> robotMap; // btcusdt -> robot
	
	public ExchangeRobotFactory() {
		robotMap = new ConcurrentHashMap<String, ExchangeRobot>();
	}
	
	public Map<String, ExchangeRobot> getRobotList(){
		return robotMap;
	}
	
	public void addExchangeRobot(String coinName, ExchangeRobot robot) {
		if(!this.containsExchangeRobot(coinName)) {
			this.robotMap.put(coinName, robot);
		}
	}
	
	public boolean containsExchangeRobot(String coinName) {
		return robotMap != null && robotMap.containsKey(coinName);
	}
	
	public ExchangeRobot getExchangeRobot(String coinName) {
		return robotMap.get(coinName);
	}
	
	/**
	 * 获取机器人参数
	 * @param coinName
	 * @return
	 */
	public PriceRobotParams getRobotParams(String coinName) {
		ExchangeRobot robot = robotMap.get(coinName);
		if(robot != null) {
			return robot.getRobotParams();
		}else {
			return null;
		}
	}
	
	/**
	 * 设置机器人参数
	 * @param coinName
	 * @param params
	 */
	public void setRobotParams(String coinName, PriceRobotParams params) {
		ExchangeRobot robot = robotMap.get(coinName);
		if(robot != null) {
			robot.setRobotParams(params);
		}
	}
}
