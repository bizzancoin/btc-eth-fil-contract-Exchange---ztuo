package com.bizzan.er.normal.robot;

import java.math.BigDecimal;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;

import com.bizzan.er.normal.entity.RobotParams;
import com.bizzan.er.normal.service.RobotParamService;

public class ExchangeRobotFactory {
	
	private ConcurrentHashMap<String, ExchangeRobot> robotMap; // btcusdt -> robot
	
	public ExchangeRobotFactory() {
		robotMap = new ConcurrentHashMap<String, ExchangeRobot>();
	}
	
	public Map<String, ExchangeRobot> getRobotList(){
		return robotMap;
	}

	/**
	 * 只有表中不包含机器人才添加机器人
	 * @param coinName
	 * @param robot
	 */
	public void addExchangeRobot(String coinName, ExchangeRobot robot) {
		if(!this.containsExchangeRobot(coinName)) {
			this.robotMap.put(coinName, robot);
		}
	}

	/**
	 * 无论如何都把机器人添加到线程表
	 * @param coinName
	 * @param robot
	 */
	public void forceAddExchangeRobot(String coinName, ExchangeRobot robot) {
		this.robotMap.put(coinName, robot);
	}

	public void removeExchangeRobot(String coinName) {
		if(this.containsExchangeRobot(coinName)) {
			this.robotMap.remove(coinName);
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
	public RobotParams getRobotParams(String coinName) {
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
	public void setRobotParams(String coinName, RobotParams params) {
		ExchangeRobot robot = robotMap.get(coinName);
		if(robot != null) {
			robot.setRobotParams(params);
		}
	}

    public void setRobotStrategy(String coinName, Integer strategy, String flowPair, BigDecimal flowPercent) {
		ExchangeRobot robot = robotMap.get(coinName);
		if(robot != null) {
			robot.setRobotStrategy(strategy, flowPair, flowPercent);
		}
    }
}
