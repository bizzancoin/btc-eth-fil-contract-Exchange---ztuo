package com.bizzan.er.normal.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.bizzan.er.normal.entity.CustomRobotKline;
import com.bizzan.er.normal.entity.RobotParams;
import com.bizzan.er.normal.robot.ExchangeRobot;
import com.bizzan.er.normal.robot.ExchangeRobotCustom;
import com.bizzan.er.normal.robot.ExchangeRobotFactory;
import com.bizzan.er.normal.robot.ExchangeRobotNormal;
import com.bizzan.er.normal.service.CustomRobotKlineService;
import com.bizzan.er.normal.service.RobotParamService;
import com.bizzan.er.normal.utils.MessageResult;

@RestController
public class RobotController {
	
	private final static  Logger logger  =  LoggerFactory.getLogger(RobotController.class);
	
	@Autowired
    private RestTemplate restTemplate;
	
	@Autowired
	private RobotParamService robotParamService;
	@Autowired
	private CustomRobotKlineService customRobotKlineService;
	
	@Autowired
	private ExchangeRobotFactory exchangeRobotFactory;
	
	@RequestMapping("robotList")
	public MessageResult robotList(){
		Map<String, RobotParams> retMap = new HashMap<String, RobotParams>();
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
    public MessageResult setRobotParams(@RequestBody RobotParams params){
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
	 * 控盘机器人：新建/保存K线趋势数据
	 * @param pair
	 * @return
	 */
	@RequestMapping("saveKline")
    public MessageResult saveKline(@RequestBody CustomRobotKline params){
		logger.info("设置机器人K线参数：" + params.getCoinName());
		customRobotKlineService.update(params.getCoinName(), params.getKdate(), params);
		
		// 保存K线数据时，让机器人重载一次今日K线数据
		if(exchangeRobotFactory.containsExchangeRobot(params.getCoinName())) {
			ExchangeRobot robot = exchangeRobotFactory.getExchangeRobot(params.getCoinName());
			robot.reloadCustomRobotKline(); // 修改后的机器人参数，需要让机器人立马重新获取一下
		}
		
		MessageResult mr = new MessageResult(0,"设置参数成功");
		return mr;
    }
	
	/**
	 * 获取控盘机器人K线设置列表
	 * @param coinName
	 * @param kdate
	 * @return
	 */
	@RequestMapping("getRobotKline")
    public MessageResult getRobotKline(String coinName, String kdate){
		logger.info("获取机器人K线参数：" + coinName);
		List<CustomRobotKline> list = customRobotKlineService.queryRobotKline(coinName, kdate);
		
		MessageResult mr = new MessageResult(0,"设置参数成功");
		mr.setData(list);
		return mr;
    }

	/**
	 * 设置控盘机器人策略
	 * @param coinName
	 * @param strategy
	 * @param flowPair
	 * @param flowPercent
	 * @return
	 */
	@RequestMapping("setRobotStrategy")
	public MessageResult setRobotStrategy(String coinName, Integer strategy, String flowPair, BigDecimal flowPercent){

		logger.info("设置控盘机器人类型：{} - {} - {} - {}", coinName, strategy, flowPair, flowPercent);
		if(exchangeRobotFactory.containsExchangeRobot(coinName)) {
			exchangeRobotFactory.setRobotStrategy(coinName, strategy, flowPair, flowPercent);
			MessageResult mr = new MessageResult(0,"获取机器人参数成功");
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
	
	/**
	 * 创建一般机器人
	 * @param params
	 * @return
	 */
	@RequestMapping("createRobot")
	public MessageResult createRobot(@RequestBody RobotParams params) {
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
	
	/**
	 * 创建控盘机器人
	 * @param params
	 * @return
	 */
	@RequestMapping("createCustomRobot")
	public MessageResult createCustomRobot(@RequestBody RobotParams params) {
		logger.info("创建机器人：" + params.getCoinName());
		if(exchangeRobotFactory.containsExchangeRobot(params.getCoinName())) {
			MessageResult mr = new MessageResult(500, "新建失败，机器人已存在");
			return mr;
		}else {
			ExchangeRobotCustom robot = new ExchangeRobotCustom();
			
			robot.setRobotParamSevice(robotParamService);
			robot.setCustomRobotKlineService(customRobotKlineService); // 注意，这里是不同的
			
			robot.setRestTemplate(restTemplate);
			
			robot.setRobotParams(params);
			robot.setPlateSymbol(params.getCoinName());
			robot.reloadCustomRobotKline(); // 载入今日K线数据
			
			exchangeRobotFactory.addExchangeRobot(params.getCoinName(), robot);
			
			new Thread((ExchangeRobotCustom)robot).start();
			
			MessageResult mr = new MessageResult(0,"机器人创建成功");
			return mr;
		}
	}
	
	// 启动机器人
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
	
	// 停止机器人
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
