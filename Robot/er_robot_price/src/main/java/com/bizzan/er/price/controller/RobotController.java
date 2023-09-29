package com.bizzan.er.price.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.bizzan.er.price.entity.PriceRobotParams;
import com.bizzan.er.price.robot.ExchangeRobot;
import com.bizzan.er.price.robot.ExchangeRobotFactory;
import com.bizzan.er.price.robot.ExchangeRobotNormal;
import com.bizzan.er.price.service.RobotParamService;
import com.bizzan.er.price.utils.MessageResult;

@RestController
public class RobotController {
	
	private final static  Logger logger  =  LoggerFactory.getLogger(RobotController.class);
	
	@Autowired
    private RestTemplate restTemplate;
	
	@Autowired
	private RobotParamService robotParamService;
	
	@Autowired
	private ExchangeRobotFactory exchangeRobotFactory;
	
	@RequestMapping("robotList")
	public MessageResult robotList(){
		Map<String, PriceRobotParams> retMap = new HashMap<String, PriceRobotParams>();
		Map<String, ExchangeRobot> robotList = exchangeRobotFactory.getRobotList();
		for (Map.Entry<String, ExchangeRobot> entry : robotList.entrySet()) {
			retMap.put(entry.getKey(), entry.getValue().getRobotParams());
		}
		MessageResult mr = new MessageResult(0,"获取成功");
		mr.setData(retMap);
		return mr;
    }
	/**
	 * 设置机器人参数
	 * @param pair
	 * @return
	 */
	@RequestMapping("setRobotParams")
    public MessageResult setRobotParams(@RequestBody PriceRobotParams params){
		logger.info("设置机器人参数：" + params.getCoinName());
		if(exchangeRobotFactory.containsExchangeRobot(params.getCoinName())) {
			exchangeRobotFactory.setRobotParams(params.getCoinName(), params);
			MessageResult mr = new MessageResult(0,"设置参数成功");
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "机器人不存在");
			return mr;
		}
    }
	
	/**
	 * 获取机器人参数
	 * @param coinName
	 * @return
	 */
	@RequestMapping("getRobotParams")
	public MessageResult getRobotParams(String coinName) {
		logger.info("获取机器人参数：" + coinName);
		if(exchangeRobotFactory.containsExchangeRobot(coinName)) {
			MessageResult mr = new MessageResult(0,"获取机器人参数成功");
			mr.setData(exchangeRobotFactory.getRobotParams(coinName));
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "机器人不存在");
			return mr;
		}
	}
	
	@RequestMapping("createRobot")
	public MessageResult createRobot(@RequestBody PriceRobotParams params) {
		logger.info("创建机器人：" + params.getCoinName());
		if(exchangeRobotFactory.containsExchangeRobot(params.getCoinName())) {
			MessageResult mr = new MessageResult(500, "新建失败，机器人已存在");
			return mr;
		}else {
			ExchangeRobot robot = new ExchangeRobotNormal();
			
			robot.setRobotParamSevice(robotParamService);
			robot.setRestTemplate(restTemplate);
			
			robot.setRobotParams(params);
			robot.setPlateSymbol(params.getCoinName());
			
			exchangeRobotFactory.addExchangeRobot(params.getCoinName(), robot);
			
			new Thread((ExchangeRobotNormal)robot).start();
			
			MessageResult mr = new MessageResult(0,"机器人创建成功");
			return mr;
		}
	}
	
	@RequestMapping("startRobot")
	public MessageResult startRobot(String coinName) {
		logger.info("启动机器人：" + coinName);
		if(exchangeRobotFactory.containsExchangeRobot(coinName)) {
			ExchangeRobot robot = exchangeRobotFactory.getExchangeRobot(coinName);
			robot.startRobot();
			MessageResult mr = new MessageResult(0,"机器人启动成功");
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "启动失败，机器人不存在");
			return mr;
		}
	}
	
	@RequestMapping("stopRobot")
	public MessageResult stopRobot(String coinName) {
		logger.info("停止机器人：" + coinName);
		if(exchangeRobotFactory.containsExchangeRobot(coinName)) {
			ExchangeRobot robot = exchangeRobotFactory.getExchangeRobot(coinName);
			robot.stopRobot();
			MessageResult mr = new MessageResult(0,"机器人停止成功");
			return mr;
		}else {
			MessageResult mr = new MessageResult(500, "停止失败，机器人不存在");
			return mr;
		}
	}
}
