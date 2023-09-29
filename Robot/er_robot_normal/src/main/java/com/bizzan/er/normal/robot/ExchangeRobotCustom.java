package com.bizzan.er.normal.robot;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicBoolean;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.bizzan.er.normal.entity.CustomRobotKline;
import com.bizzan.er.normal.entity.ExchangeOrderBean;
import com.bizzan.er.normal.entity.RobotParams;
import com.bizzan.er.normal.service.CustomRobotKlineService;
import com.bizzan.er.normal.service.RobotParamService;
import com.bizzan.er.normal.utils.HttpClientUtil;
import com.bizzan.er.normal.utils.MessageResult;

public class ExchangeRobotCustom implements Runnable, ExchangeRobot{
	private AtomicBoolean running = new AtomicBoolean(true);

	public  Logger logger  =  LoggerFactory.getLogger(ExchangeRobotCustom.class);
	
    private RestTemplate restTemplate;
	
	private RobotParamService robotParamService;
	
	private CustomRobotKlineService customRobotKlineService;
	
	protected String plateSymbol; // 交易对名（例：BTC/USDT）
	protected RobotParams robotParams; // 机器人运行参数
	
	// 以下三个参数为K线数据相关的参数
	protected String cDate = "";
	protected int pricePercent = 1; // 价格波动参数，默认1%
	protected BigDecimal[] klinePriceArr = new BigDecimal[97];
	protected BigDecimal lastPrice = BigDecimal.ZERO; // 上次价格，这个价格主要用于获取不到最新K线的情况
	
	protected int uid = 1;
	protected String sign = "77585211314qazwsx";
	protected String currenOrderURL = EXCHANGE_GATE_WAY+"/exchange/order/mockcurrentydhdnskd";
	protected String cancelOrderURL = EXCHANGE_GATE_WAY+"/exchange/order/mockcancelydhdnskd";
	protected String exchangeTYPE = "LIMIT_PRICE";
	protected String directionSELL = "SELL";
	protected String commitOrderURL = EXCHANGE_GATE_WAY+"/exchange/order/mockaddydhdnskd";
	protected String plateURL = EXCHANGE_GATE_WAY+"/market/exchange-plate-mini";

	protected Random rand = new Random();

	protected Instant lastSendOrderTime = Instant.now();
	private int lastIndexStart = -1;
	private int tendIndex = 0;
	private int minuteIndex = 0; // 分钟级价格浮动计算
	private BigDecimal randPricePercent = BigDecimal.ZERO; // 分钟级价格浮动计算

	public String getPlateSymbol() {
		return plateSymbol;
	}

	public void setPlateSymbol(String plateSymbol) {
		this.plateSymbol = plateSymbol;
	}

	public RobotParams getRobotParams() {
		return robotParams;
	}


	public void setRobotParams(RobotParams robotParams) {
		this.robotParams = robotParams;
		this.robotParams.setRobotType(1);
		robotParamService.update(robotParams.getCoinName(), robotParams);
	}
	
	public void updateRobotParams(RobotParams params) {
		this.robotParams.setStartAmount(params.getStartAmount());
		this.robotParams.setRandRange0(params.getRandRange0());
		this.robotParams.setRandRange1(params.getRandRange1());
		this.robotParams.setRandRange2(params.getRandRange2());
    	this.robotParams.setRandRange3(params.getRandRange3());
    	this.robotParams.setRandRange4(params.getRandRange4());
    	this.robotParams.setRandRange5(params.getRandRange5());
    	this.robotParams.setRandRange6(params.getRandRange6());
    	this.robotParams.setScale(params.getScale());
    	this.robotParams.setAmountScale(params.getAmountScale());
    	this.robotParams.setMaxSubPrice(params.getMaxSubPrice());
    	this.robotParams.setInitOrderCount(params.getInitOrderCount());
    	this.robotParams.setPriceStepRate(params.getPriceStepRate());
    	this.robotParams.setRunTime(params.getRunTime());
    	this.robotParams.setRobotType(1);
    	this.robotParams.setStrategyType(params.getStrategyType());
    	this.robotParams.setFlowPair(params.getFlowPair());
    	this.robotParams.setFlowPercent(params.getFlowPercent());
    	
    	robotParamService.update(this.plateSymbol, params);
	}
	
	/**
	 * 处理当前委托，超过一定数量自动取消
	 */
	public void processCurrentOrder() {
		Map<String, String> param = new HashMap<String, String>();
        param.put("symbol", this.plateSymbol);
        param.put("uid", String.valueOf(this.uid));
        param.put("sign", this.sign);
        param.put("pageNo", "0");
        param.put("pageSize", "100");
		String plateResult = "";

		try {
			//logger.info("Process Current Order=====>" + this.plateSymbol);
			plateResult = HttpClientUtil.doHttpPost(this.currenOrderURL, param, null);
			if(plateResult != null && !plateResult.equals("")) {
				JSONObject obj = JSONObject.parseObject(plateResult);
				JSONArray orderList = obj.getJSONArray("content");
				
				JSONArray buyOrderList = new JSONArray();
				JSONArray sellOrderList = new JSONArray();
				for(int i = 0; i < orderList.size(); i++) {
					if(orderList.getJSONObject(i).getString("direction").equals("BUY")) {
						buyOrderList.add(orderList.getJSONObject(i));
					}else {
						sellOrderList.add(orderList.getJSONObject(i));
					}
				}
				
				if(buyOrderList.size() > 40) {
					// 取消1/3订单
					for(int j = 0; j < buyOrderList.size(); j++) {
						if(j % 3 == 0) {
							this.cancelCurrentOrder(buyOrderList.getJSONObject(j).getString("orderId"));
							Thread.sleep(1000);
						}
					}
				}
				
				if(sellOrderList.size() > 40) {
					// 取消1/3订单
					for(int k = 0; k < sellOrderList.size(); k++) {
						if(k % 3 == 0) {
							this.cancelCurrentOrder(sellOrderList.getJSONObject(k).getString("orderId"));
							Thread.sleep(1000);
						}
					}
				}
			}
		} catch (InterruptedException e) {
            logger.error("机器人异常：processCurrentOrder3: " + e);
		}
	}
	
	/**
	 * 发送取消订单请求
	 * @param orderId
	 */
	public void cancelCurrentOrder(String orderId) {
		Map<String, String> param = new HashMap<String, String>();
        param.put("uid", String.valueOf(this.uid));
        param.put("sign", this.sign);
        param.put("orderId", orderId);

        logger.info("取消订单：" + this.plateSymbol + " - " + orderId);
        HttpClientUtil.doHttpPost(this.cancelOrderURL, param, null);

	}
	
	/**
	 * 构建指定价格、数量订单
	 * @param direction
	 * @param price
	 * @param amount
	 */
	protected void buildSingleOrder(String direction, BigDecimal price, BigDecimal amount) {
		ExchangeOrderBean orderBean = new ExchangeOrderBean();
		orderBean.setSymbol(this.plateSymbol);
		orderBean.setPrice(price);
		orderBean.setAmount(amount);
		orderBean.setDirection(direction);
		orderBean.setType(this.exchangeTYPE);
		orderBean.setUid(this.uid);
		orderBean.setUseDiscount(0);
		orderBean.setSign(this.sign);
    	
		this.sendOrder(orderBean);
		
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
            logger.error("机器人异常：buildSingleOrder: " + e);
		}
	}
	
	/**
	 * 构建初始化时的订单列表（买卖盘同时下单）
	 * @param count
	 * @param lastestPrice
	 */
	protected void buildInitPlateOrder(int count, BigDecimal lastestPrice) {
		BigDecimal priceBuy = lastestPrice.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
		BigDecimal priceSell = lastestPrice.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
		List<ExchangeOrderBean> buyList = new ArrayList<ExchangeOrderBean>();
		List<ExchangeOrderBean> sellList = new ArrayList<ExchangeOrderBean>();
		// 以最新价为基准构建卖盘
		for(int i = 0; i < count * 2; i++) {
			double temRand = 0.1;
			int intRand = this.rand.nextInt(100);
			if(intRand >= 0 && intRand < 1) {
				temRand = this.robotParams.getRandRange0();
			}else if(intRand >= 1 && intRand < 10) {
				temRand = this.robotParams.getRandRange1();
			}else if(intRand >= 10 && intRand < 30) {
				temRand = this.robotParams.getRandRange2();
			}else if(intRand >= 30 && intRand < 50) {
				temRand = this.robotParams.getRandRange3();
			}else if(intRand >= 50 && intRand < 70) {
				temRand = this.robotParams.getRandRange4();
			}else if(intRand >= 70 && intRand < 90) {
				temRand = this.robotParams.getRandRange5();
			}else{
				temRand = this.robotParams.getRandRange6();
			}
			// 以设置精度为基准生成随机精度的交易量
			BigDecimal amount = this.scaleAmount(temRand);
			
			ExchangeOrderBean orderBean = new ExchangeOrderBean();
			orderBean.setSymbol(this.plateSymbol);
			
			orderBean.setAmount(amount);
			
			orderBean.setType(this.exchangeTYPE);
			orderBean.setUid(this.uid);
			orderBean.setUseDiscount(0);
			orderBean.setSign(this.sign);
			if(i%2 == 0) {
				orderBean.setPrice(priceSell);
				orderBean.setDirection("SELL");
				
				sellList.add(orderBean);
			}else {
				orderBean.setPrice(priceBuy);
				orderBean.setDirection("BUY");
				buyList.add(orderBean);
			}
			
			// 价格递增、递减速度变化
			// 以priceStepRate为起始递增的增幅设置卖出价格，此举的目的是让距离最新价格越远的订单价格差越大
			BigDecimal temStep = BigDecimal.valueOf(i+1).divide(BigDecimal.valueOf(this.robotParams.getInitOrderCount()), 10, BigDecimal.ROUND_HALF_DOWN).multiply(this.robotParams.getPriceStepRate());
			if(i%2 == 0) {
				// 以priceStepRate为起始递增的增幅设置卖出价格
				priceSell = priceSell.add(priceSell.multiply(this.robotParams.getPriceStepRate().add(temStep))).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}else {
				// 以priceStepRate为起始递增的增幅设置卖出价格
				priceBuy = priceBuy.subtract(priceBuy.multiply(this.robotParams.getPriceStepRate().add(temStep))).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}
			// 处理小数位数（随机小数位数，让盘面乱一些）
			
			priceSell = this.scalePrice(priceSell);
			priceBuy = this.scalePrice(priceBuy);
			// 如果价格出现0或负数，则退出循环
			if(priceBuy.compareTo(BigDecimal.ZERO) <= 0 || priceSell.compareTo(BigDecimal.ZERO) <= 0) {
				break;
			}
			
		}
		
		// 随机发送买卖单
		int bIndex = buyList.size();
		int sIndex = sellList.size();
		while(bIndex >= 0 || sIndex >= 0) {
			int randNum = this.rand.nextInt(120);
			if(randNum > 50) {
				bIndex = bIndex - 1;
				if(bIndex >= 0) {
					String ret = this.sendOrder(buyList.get(bIndex));
					try {
						Thread.sleep(200);
					} catch (InterruptedException e) {
                        logger.error("机器人异常：buildInitPlateOrder1: " + e);
					}
				}
			}else {
				sIndex = sIndex - 1;
				if(sIndex >= 0) {
					String ret = this.sendOrder(sellList.get(sIndex));
					try {
						Thread.sleep(200);
					} catch (InterruptedException e) {
                        logger.error("机器人异常：buildInitPlateOrder2: " + e);
					}
				}
			}
		}
	}
	/**
	 * 构建随机订单
	 * @param direction  下单方向（BUY、SELL）
	 * @param count		随机订单数量
	 * @param lastestPrice   外部行情最新价
	 */
	protected void buildOrder(String direction, int count, BigDecimal lastestPrice, boolean initFlag) {
		
		BigDecimal price = lastestPrice.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
		// 以最新价为基准构建卖盘
		for(int i = 0; i < count; i++) {
			double temRand = 0.1;
			int intRand = this.rand.nextInt(100);
			if(intRand >= 0 && intRand < 1) {
				temRand = this.robotParams.getRandRange0();
			}else if(intRand >= 1 && intRand < 10) {
				temRand = this.robotParams.getRandRange1();
			}else if(intRand >= 10 && intRand < 30) {
				temRand = this.robotParams.getRandRange2();
			}else if(intRand >= 30 && intRand < 50) {
				temRand = this.robotParams.getRandRange3();
			}else if(intRand >= 50 && intRand < 70) {
				temRand = this.robotParams.getRandRange4();
			}else if(intRand >= 70 && intRand < 90) {
				temRand = this.robotParams.getRandRange5();
			}else{
				temRand = this.robotParams.getRandRange6();
			}
			// 以设置精度为基准生成随机精度的交易量
			BigDecimal amount = this.scaleAmount(temRand);
			
			ExchangeOrderBean orderBean = new ExchangeOrderBean();
			orderBean.setSymbol(this.plateSymbol);
			orderBean.setPrice(price);
			orderBean.setAmount(amount);
			orderBean.setDirection(direction);
			orderBean.setType(this.exchangeTYPE);
			orderBean.setUid(this.uid);
			orderBean.setUseDiscount(0);
			orderBean.setSign(this.sign);
        	
			this.sendOrder(orderBean);
			
			// 价格递增、递减速度变化
			// 以priceStepRate为起始递增的增幅设置卖出价格，此举的目的是让距离最新价格越远的订单价格差越大
			BigDecimal temStep = BigDecimal.valueOf(i+1).divide(BigDecimal.valueOf(this.robotParams.getInitOrderCount()), 10, BigDecimal.ROUND_HALF_DOWN).multiply(this.robotParams.getPriceStepRate());
			if(direction.equals(this.directionSELL)) {
				// 以priceStepRate为起始递增的增幅设置卖出价格
				price = price.add(price.multiply(this.robotParams.getPriceStepRate().add(temStep))).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}else {
				// 以priceStepRate为起始递增的增幅设置卖出价格
				price = price.subtract(price.multiply(this.robotParams.getPriceStepRate().add(temStep))).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}
			// 处理小数位数（随机小数位数，让盘面乱一些）
			
			price = this.scalePrice(price);
			// 如果价格出现0或负数，则退出循环
			if(price.compareTo(BigDecimal.ZERO) == 0 || price.compareTo(BigDecimal.ZERO) < 0) {
				break;
			}
			try {
				// 如果是买卖盘为空，即初始化时，可以快速下单
				// 如果不是初始化阶段，则可以2秒下一个单
				if(initFlag) {
					Thread.sleep(200);
				}else {
					Thread.sleep(2000);
				}
			} catch (InterruptedException e) {
                logger.error("机器人异常：buildOrder: " + e);
			}
		}
	}

	/**
	 * startPrice需小于endPrice
	 * @param direction
	 * @param startPrice
	 * @param endPrice
	 */
	protected void buildSpecOrder(String direction, BigDecimal startPrice, BigDecimal endPrice) {
		if(startPrice.compareTo(endPrice) > 0) {
			return;
		}
		BigDecimal price = startPrice.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
		// 在两个价格中间追加3个订单
		for(int i = 0; i < 3; i++) {
			double temRand = 0.1;
			int intRand = this.rand.nextInt(100);
			if(intRand >= 0 && intRand < 1) {
				temRand = this.robotParams.getRandRange0();
			}else if(intRand >= 1 && intRand < 10) {
				temRand = this.robotParams.getRandRange1();
			}else if(intRand >= 10 && intRand < 30) {
				temRand = this.robotParams.getRandRange2();
			}else if(intRand >= 30 && intRand < 50) {
				temRand = this.robotParams.getRandRange3();
			}else if(intRand >= 50 && intRand < 70) {
				temRand = this.robotParams.getRandRange4();
			}else if(intRand >= 70 && intRand < 90) {
				temRand = this.robotParams.getRandRange5();
			}else{
				temRand = this.robotParams.getRandRange6();
			}
			BigDecimal amount = this.scaleAmount(temRand);
			// 以价差的25%、50%、75%进行递增
			BigDecimal step = BigDecimal.valueOf(i+1).multiply(BigDecimal.valueOf(0.25));
			price = price.add(endPrice.subtract(startPrice).multiply(step));
			
			ExchangeOrderBean orderBean = new ExchangeOrderBean();
			orderBean.setSymbol(this.plateSymbol);
			orderBean.setPrice(price);
			orderBean.setAmount(amount);
			orderBean.setDirection(direction);
			orderBean.setType(this.exchangeTYPE);
			orderBean.setUid(this.uid);
			orderBean.setUseDiscount(0);
			orderBean.setSign(this.sign);
        	
			this.sendOrder(orderBean);

			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
                logger.error("机器人异常：buildSpecOrder: " + e);
			}
		}
	}
	protected void buildMiddleOrder(String direction, int count, BigDecimal lastestPrice) {
		
		BigDecimal price = lastestPrice.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
		// 以最新价为基准构建卖盘
		for(int i = 0; i < count; i++) {
			double temRand = 0.1;
			int intRand = this.rand.nextInt(100);
			if(intRand >= 0 && intRand < 1) {
				temRand = this.robotParams.getRandRange0();
			}else if(intRand >= 1 && intRand < 10) {
				temRand = this.robotParams.getRandRange1();
			}else if(intRand >= 10 && intRand < 30) {
				temRand = this.robotParams.getRandRange2();
			}else if(intRand >= 30 && intRand < 50) {
				temRand = this.robotParams.getRandRange3();
			}else if(intRand >= 50 && intRand < 70) {
				temRand = this.robotParams.getRandRange4();
			}else if(intRand >= 70 && intRand < 90) {
				temRand = this.robotParams.getRandRange5();
			}else{
				temRand = this.robotParams.getRandRange6();
			}
			BigDecimal amount = this.scaleAmount(temRand);
			
			// 价格递增、递减速度变化
			if(direction.equals(this.directionSELL)) {
				// 以0.1%增幅设置卖出价格
				price = price.subtract(price.multiply(this.robotParams.getPriceStepRate())).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}else {
				// 以0.1%降幅设置卖出价格
				price = price.add(price.multiply(this.robotParams.getPriceStepRate())).setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN);
			}
			price = this.scalePrice(price);
			if(price.compareTo(BigDecimal.ZERO) == 0 || price.compareTo(BigDecimal.ZERO) < 0) {
				break;
			}
			ExchangeOrderBean orderBean = new ExchangeOrderBean();
			orderBean.setSymbol(this.plateSymbol);
			orderBean.setPrice(price);
			orderBean.setAmount(amount);
			orderBean.setDirection(direction);
			orderBean.setType(this.exchangeTYPE);
			orderBean.setUid(this.uid);
			orderBean.setUseDiscount(0);
			orderBean.setSign(this.sign);
        	
			this.sendOrder(orderBean);

			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
                logger.error("机器人异常：buildMiddleOrder: " + e);
			}
		}
	}
	protected BigDecimal scaleAmount(double temRand) {
		BigDecimal randAmount = BigDecimal.valueOf(0);
		while(randAmount.compareTo(BigDecimal.ZERO) == 0) {
			randAmount = BigDecimal.valueOf(this.rand.nextDouble()*temRand + this.robotParams.getStartAmount()).setScale(this.rand.nextInt(this.robotParams.getAmountScale())+1, BigDecimal.ROUND_HALF_DOWN);
		}
		return randAmount;
	}
	
	protected BigDecimal scalePrice(BigDecimal price) {
		int temRand = this.rand.nextInt(100);
		if(price.compareTo(BigDecimal.valueOf(1000)) >= 0) {
			if(temRand < 50) { //50%概率出现整数
				return price.setScale(0, BigDecimal.ROUND_HALF_DOWN);
			}
			// 60%概率随机位数（0~scale）
			return price.setScale(this.rand.nextInt(this.robotParams.getScale()), BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(100)) >= 0) {
			if(temRand < 50) { //50%概率出现1位小数
				return price.setScale(1, BigDecimal.ROUND_HALF_DOWN);
			}
			// 60%概率随机位数（1~scale）
			return price.setScale(this.rand.nextInt(this.robotParams.getScale()) + 1, BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(10)) >= 0) {
			if(temRand < 50) { //50%概率出现2位小数
				return price.setScale(2, BigDecimal.ROUND_HALF_DOWN);
			}
			// 60%概率随机位数（2~scale）
			return price.setScale(this.rand.nextInt(this.robotParams.getScale()-1) + 2, BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(1)) >= 0) {
			if(temRand < 50) { //50%概率出现3位小数
				return price.setScale(3, BigDecimal.ROUND_HALF_DOWN);
			}
			// 60%概率随机位数（3~scale）
			return price.setScale(this.rand.nextInt(this.robotParams.getScale()-2) + 3, BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(0.1)) >= 0) {
			if(temRand < 50) { //50%概率出现4位小数
				return price.setScale(4, BigDecimal.ROUND_HALF_DOWN);
			}
			// 60%概率随机位数（4~scale）
			return price.setScale(this.rand.nextInt(this.robotParams.getScale()-3) + 4, BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(0.01)) >= 0) {
			if(temRand < 50) { //50%概率出现5位小数
				return price.setScale(5, BigDecimal.ROUND_HALF_DOWN);
			}
			int temN = this.robotParams.getScale()-4;
			temN = temN > 0 ? temN : 1;
			// 60%概率随机位数（5~scale）
			return price.setScale(this.rand.nextInt(temN) + 5, BigDecimal.ROUND_HALF_DOWN);
		}
		if(price.compareTo(BigDecimal.valueOf(0.001)) >= 0) {
			if(temRand < 50) { //50%概率出现6位小数
				return price.setScale(6, BigDecimal.ROUND_HALF_DOWN);
			}
			int temN = this.robotParams.getScale()-5;
			temN = temN > 0 ? temN : 1;
			// 60%概率随机位数（6~scale）
			return price.setScale(this.rand.nextInt(temN) + 6, BigDecimal.ROUND_HALF_DOWN);
		}
		return price.setScale(this.robotParams.getScale(), BigDecimal.ROUND_HALF_DOWN);
	}
	
	protected String sendOrder(ExchangeOrderBean order) {
		Map<String, String> param = new HashMap<String, String>();
		param.put("symbol", order.getSymbol());
		param.put("price", String.valueOf(order.getPrice().setScale(this.robotParams.getScale(), BigDecimal.ROUND_HALF_UP)));
		param.put("amount", String.valueOf(order.getAmount().setScale(this.robotParams.getAmountScale(), BigDecimal.ROUND_HALF_UP).add(BigDecimal.valueOf(1 + rand.nextInt(10)))));
		param.put("direction", order.getDirection());
		param.put("type", order.getType());
		param.put("useDiscount", String.valueOf(order.getUseDiscount()));
		param.put("uid", String.valueOf(order.getUid()));
		param.put("sign", order.getSign());

        try {
			String result = HttpClientUtil.doHttpPost(this.commitOrderURL, param, null);
			
			this.lastSendOrderTime = Instant.now();
			//logger.info("[" + order.getSymbol() + "] - 发送订单：" + param.get("direction") + " - " + param.get("price") + "/" + param.get("amount"));
			logger.info("[" + order.getSymbol() + "] " + "======>" + result);
			return result;
		} catch (Exception e) {
            logger.error("机器人异常：sendOrder3: " + e);
		}
        return null;
	}
	
	public void startRobot() {
		this.robotParams.setHalt(false);
		robotParamService.update(robotParams.getCoinName(), robotParams);
		logger.info("[" + this.plateSymbol + "] - 设置机器人为启动状态");
	}

	public void stopRobot() {
		this.robotParams.setHalt(true);
		robotParamService.update(robotParams.getCoinName(), robotParams);
		logger.info("[" + this.plateSymbol + "] - 设置机器人为停止状态");
	}
	
	@Override
	public void run() {
		logger.info("[" + this.plateSymbol + "] - 线程启动...");
		running.set(true);
		while(running.get()) {
			if(this.robotParams.isHalt()) {
				// 暂停状态
				try {
					Thread.sleep(5000);
				} catch (InterruptedException e) {
					logger.info("ERROR: 机器人出现异常2");
                    logger.error("机器人异常：run1: " + e);
				}
				continue;
			}
			logger.info("老子开始处理当前订单了，老子是：" + this.plateSymbol);
			this.processCurrentOrder();
			// 1、获取自己买卖盘数据
			Map<String, String> param = new HashMap<String, String>();
	        param.put("symbol", this.plateSymbol);
			String plateResult = "";
			boolean sendOrderFlag = false;
			try {
				plateResult = HttpClientUtil.doHttpPost(this.plateURL, param, null);
				if(plateResult != null && !plateResult.equals("")) {
					JSONObject obj = JSONObject.parseObject(plateResult);
					
					// 获取卖单委托（SELL）
					BigDecimal askLowestPrice = obj.getJSONObject("ask").getBigDecimal("lowestPrice");
					JSONArray askList = obj.getJSONObject("ask").getJSONArray("items");
					
					// 获取买单委托（BUY）
					BigDecimal bidHighestPrice = obj.getJSONObject("bid").getBigDecimal("highestPrice");
					JSONArray bidList = obj.getJSONObject("bid").getJSONArray("items");
					
					//logger.info("[" + this.plateSymbol + "]Sell order size:" +askList.size() + ", Buy order size:" + bidList.size());
					//logger.info("[" + this.plateSymbol + "]Sell lowest price:" + askLowestPrice + ", Buy highest price:" + bidHighestPrice);
					
					BigDecimal lastestPrice = BigDecimal.ZERO;
					lastestPrice = this.getOuterPrice();
					
					if(lastestPrice != null && lastestPrice.compareTo(BigDecimal.ZERO) != 0) {
						// 初始化状态随机下买卖单
						if(askList.size() == 0 && bidList.size() == 0) {
							this.buildInitPlateOrder(this.robotParams.getInitOrderCount(), lastestPrice);
						}else {
							// 卖盘不足
							if(askList.size() < 24) {
								//logger.info("[" + this.plateSymbol + "]Sell order size("+ askList.size() +") is blow than 24, it will auto commit " + this.robotParams.getInitOrderCount() +" sell orders.");
								if(askList.size() == 0) { //初始化
									this.buildOrder("SELL", this.robotParams.getInitOrderCount() - askList.size(), lastestPrice, true);
								}else {
									this.buildOrder("SELL", this.robotParams.getInitOrderCount() - askList.size(), lastestPrice, false);
								}
								
								sendOrderFlag = true;
							}
							// 买盘不足
							if(bidList.size() < 24) {
								//logger.info("[" + this.plateSymbol + "]Buy order size("+ bidList.size() +") is blow than 24, it will auto commit " + this.robotParams.getInitOrderCount() +" buy orders.");
								if(bidList.size() == 0) {
									this.buildOrder("BUY", this.robotParams.getInitOrderCount() - bidList.size(), lastestPrice, true);
								}else {
									this.buildOrder("BUY", this.robotParams.getInitOrderCount() - bidList.size(), lastestPrice, false);
								}
								sendOrderFlag = true;
							}
						

							// 外部行情价格 > 卖盘最低价，需要构建买单
							if(lastestPrice.compareTo(askLowestPrice) > 0) {
								//logger.info("[" + this.plateSymbol + "]Other market price("+ lastestPrice +") > sell lowest price(" + askLowestPrice + ")");
								BigDecimal totalAmount = BigDecimal.valueOf(0);
								for(int i = 0; i < askList.size(); i++) {
									if(((JSONObject)askList.get(i)).getBigDecimal("price").compareTo(lastestPrice) < 0) {
										totalAmount = totalAmount.add(((JSONObject)askList.get(i)).getBigDecimal("amount"));
									}else {
										break;
									}
								}
								totalAmount = totalAmount.add(BigDecimal.valueOf(this.robotParams.getStartAmount()).multiply(BigDecimal.valueOf(this.rand.nextInt(20) + 1)));
								this.buildSingleOrder("BUY", lastestPrice, totalAmount.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN));
								if(lastestPrice.subtract(bidHighestPrice).compareTo(this.robotParams.getMaxSubPrice()) > 0) {
									this.buildSpecOrder("BUY", bidHighestPrice, lastestPrice);
								}
								sendOrderFlag = true;
							}
							
							// 外部行情价格 < 买盘最高价，需要构建卖单
							if(lastestPrice.compareTo(bidHighestPrice) < 0) {
								//logger.info("[" + this.plateSymbol + "]Other market price("+ lastestPrice +") < buy highest price(" + bidHighestPrice + ")");
								BigDecimal totalAmount = BigDecimal.valueOf(0);
								for(int i = 0; i < bidList.size(); i++) {
									if(((JSONObject)bidList.get(i)).getBigDecimal("price").compareTo(lastestPrice) > 0) {
										totalAmount = totalAmount.add(((JSONObject)bidList.get(i)).getBigDecimal("amount"));
									}else {
										break;
									}
								}
								totalAmount = totalAmount.add(BigDecimal.valueOf(this.robotParams.getStartAmount()).multiply(BigDecimal.valueOf(this.rand.nextInt(20) + 1)));
								this.buildSingleOrder("SELL", lastestPrice, totalAmount.setScale(this.robotParams.getScale(),BigDecimal.ROUND_HALF_DOWN));
								if(askLowestPrice.subtract(lastestPrice).compareTo(this.robotParams.getMaxSubPrice()) > 0) {
									this.buildSpecOrder("SELL", lastestPrice, askLowestPrice);
								}
								sendOrderFlag = true;
							}
							// 买卖盘都不为空时才进行中间差价处理
							if(bidList.size() > 0 && askList.size() >0) {
								// 买卖盘价差超过maxSubPrice时，每方构建3个委托单
								if(askLowestPrice.subtract(bidHighestPrice).compareTo(this.robotParams.getMaxSubPrice()) > 0) {
									this.buildOrder("SELL", 3, lastestPrice, false);
									this.buildOrder("BUY", 3, lastestPrice, false);
									sendOrderFlag = true;
								}
							}
							
							// 如果没有发出任何订单，则发送一个卖单
							if(!sendOrderFlag) {
								int temR = this.rand.nextInt(10);
								String temDir = temR > 5 ? "SELL" : "BUY";  // 以50%的概率发布买单或卖单
								this.buildMiddleOrder(temDir, 1, lastestPrice);
							}
						}
					}else {
						logger.info("机器人错误，外部价格不存在或为0");
					}
				}
			} catch (Exception e) {
                logger.error("机器人异常：run2: " + e);
				logger.info("ERROR: 机器人出现异常1");
			} finally {
				try {
					Thread.sleep(this.rand.nextInt(this.robotParams.getRunTime()) + this.robotParams.getRunTime());
				} catch (InterruptedException e) {
                    logger.error("机器人异常：run3: " + e);
					logger.info("ERROR: 机器人出现异常2");
				}
			}
		}
		running.set(false);
	}

	@Override
	public BigDecimal getOuterPrice() {
		if(this.robotParams.getStrategyType() == 2) {
			// 根据Mongodb设置的K线数据计算某一时刻的价格
			Date t = new Date();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String dateStr = df.format(t);

			// 发生跨天情形，重载新K线数据
			if (!dateStr.equals(this.cDate)) {
				if (!this.reloadCustomRobotKline()) {
					// K线数据没有了怎么办。。。根据上次的价格做个随机计算，返回吧

					// 上次价格等于0怎么办
					if (this.lastPrice.compareTo(BigDecimal.ZERO) == 0) {
						return BigDecimal.ZERO;
					}
					int noDataRand = rand.nextInt(10);
					int changePercentRand = rand.nextInt(3); //价格在0%到2%之间浮动
					if (noDataRand > 6) { // 30%的概率增长
						return this.lastPrice.add(this.lastPrice.multiply(BigDecimal.valueOf(changePercentRand).divide(BigDecimal.valueOf(100))));
					} else {
						return this.lastPrice.subtract(this.lastPrice.multiply(BigDecimal.valueOf(changePercentRand).divide(BigDecimal.valueOf(100))));
					}
				}
			}
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(t);
			int hours = calendar.get(Calendar.HOUR_OF_DAY);
			;
			int minutes = calendar.get(Calendar.MINUTE);
			int seconds = calendar.get(Calendar.SECOND);

			int totalMinutes = hours * 60 + minutes;
			int totalSeconds = hours * 60 * 60 + minutes * 60 + seconds;
			// 15分钟 = 900秒
			int indexStart = totalMinutes / 15; // 表示15分钟一个间隔
			int indexEnd = indexStart + 1;
			int calSeconds = totalSeconds - indexStart * 15 * 60; // 计算当前区间（0~900s)处于第几秒

			// 计算位于第几分钟
			int temMinuteIndex = calSeconds / 60;
			if (this.minuteIndex == 0) {
				this.randPricePercent = BigDecimal.valueOf(this.pricePercent);
			}
			if (this.minuteIndex != temMinuteIndex) {
				// 每分钟的价格浮动比例做随机处理
				this.randPricePercent = BigDecimal.valueOf(rand.nextDouble()).setScale(2, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(this.pricePercent));
				this.minuteIndex = temMinuteIndex;
			}

			// 0 ～ 0.1PI    0.1PI ~ 0.2PI     0.2PI ~0.3PI     0.3PI ~ 0.4PI     0.4PI ~ 0.5PI
			// 此处看起来复杂，其实不难，就是根据当前秒数在这个价格区间内所处的位置去推算价格，并且不是直线上升，而是做了正弦函数的曲线价格
			BigDecimal sinValue = BigDecimal.valueOf(Math.PI).divide(BigDecimal.valueOf(2), 8, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(calSeconds).divide(BigDecimal.valueOf(900), 8, BigDecimal.ROUND_HALF_UP));

			// 每一轮K线走势随机出一个新的走势
			if (this.lastIndexStart != -1 && this.lastIndexStart != indexStart) {
				this.tendIndex = this.rand.nextInt(5); // 新周期随机出一种策略出来
			}

			// 根据随机策略生成K线
			sinValue = this.tendGenerateType(sinValue, this.tendIndex);

			BigDecimal calPrice = this.klinePriceArr[indexStart].subtract(
					(this.klinePriceArr[indexStart].subtract(
							this.klinePriceArr[indexEnd]).divide(
							BigDecimal.valueOf(900), 8, BigDecimal.ROUND_HALF_UP).multiply(
							BigDecimal.valueOf(calSeconds)
					)
					).multiply(BigDecimal.valueOf(Math.sin(sinValue.doubleValue())))
			);

			// 计算出一个比较平滑的曲线价格后，不能直接成为最终价格，因为过于平滑的价格曲线显然让K线不是那么好看
			// 因此，此处再对价格进行一个随机化处理，对当前价格做一个基于“价格浮动比例”的随机升降
			// 升或者降的概率是不同的，价格处于升势的时候，当前价格有60%的概率上涨，价格处于降势下，当前价格有40%概率上涨
			int tendType = this.klinePriceArr[indexStart].compareTo(this.klinePriceArr[indexEnd]) > 0 ? 1 : 0;
			BigDecimal priceRandSeed = BigDecimal.valueOf(rand.nextDouble()).multiply(this.randPricePercent);
			int tem = rand.nextInt(10);

			// 价格增减随机百分比
			BigDecimal percentRandValue = priceRandSeed.divide(BigDecimal.valueOf(100), 8, BigDecimal.ROUND_HALF_UP);
			if (tendType == 1) { // 下降趋势
				if (rand.nextInt(60) > 55) {
					calPrice = calPrice.add(calPrice.multiply(percentRandValue));
				} else {
					calPrice = calPrice.subtract(calPrice.multiply(percentRandValue));
				}
			} else { // 上升趋势
				if (rand.nextInt(60) > 5) {
					calPrice = calPrice.add(calPrice.multiply(percentRandValue));
				} else {
					calPrice = calPrice.subtract(calPrice.multiply(percentRandValue));
				}
			}

			if (calPrice.compareTo(BigDecimal.ZERO) < 0) {
				calPrice = BigDecimal.ZERO;
			}
			this.lastIndexStart = indexStart;
			this.lastPrice = calPrice;
			return calPrice;
		}else if(this.robotParams.getStrategyType() == 1) {
			try {
				String url = "http://ROBOT-TRADE-MARKET/ermarket/thumb/" + this.robotParams.getFlowPair().replace("/", "").toLowerCase();
				ResponseEntity<MessageResult> result = restTemplate.getForEntity(url, MessageResult.class);
				if (result.getStatusCode().value() == 200) {
					MessageResult mr = result.getBody();
					if (mr.getCode() == 0) {
						JSONObject obj = (JSONObject)JSONObject.toJSON(mr.getData());
						BigDecimal price = obj.getBigDecimal("price");
						return price.multiply(this.robotParams.getFlowPercent()).divide(BigDecimal.valueOf(100), 8, RoundingMode.HALF_DOWN);
					}
				}
			} catch (IllegalStateException e) {
				logger.error("机器人异常：getOuterPrice1:" + e);
				return BigDecimal.ZERO;
			} catch (Exception e) {
				logger.error("机器人异常：getOuterPrice2:" + e);
				return BigDecimal.ZERO;
			}
			return BigDecimal.ZERO;
		}else{
			return BigDecimal.ZERO;
		}
	}

	// 简单的五种随机策略
	private BigDecimal tendGenerateType(BigDecimal sinValue, int type) {
		BigDecimal pi01 = BigDecimal.valueOf(Math.PI).multiply(BigDecimal.valueOf(0.1));
		BigDecimal pi02 = BigDecimal.valueOf(Math.PI).multiply(BigDecimal.valueOf(0.2));
		BigDecimal pi03 = BigDecimal.valueOf(Math.PI).multiply(BigDecimal.valueOf(0.3));
		BigDecimal pi04 = BigDecimal.valueOf(Math.PI).multiply(BigDecimal.valueOf(0.4));
		BigDecimal pi05 = BigDecimal.valueOf(Math.PI).multiply(BigDecimal.valueOf(0.5));

		if(type == 0) {
			if(sinValue.compareTo(pi01) > 0 && sinValue.compareTo(pi02) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(2)); // 放大2倍增幅
			}
			if(sinValue.compareTo(pi02) > 0 && sinValue.compareTo(pi04) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(0.6));
			}
		}
		if(type == 1) {
			if(sinValue.compareTo(pi02) > 0 && sinValue.compareTo(pi04) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(0.6));
			}
		}
		if(type == 2) {
			if(sinValue.compareTo(pi01) > 0 && sinValue.compareTo(pi03) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(0.5));
			}
		}
		if(type == 3) {
			if(sinValue.compareTo(pi01) > 0 && sinValue.compareTo(pi02) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(2));
			}
		}
		if( type == 4) {
			if(sinValue.compareTo(pi03) > 0 && sinValue.compareTo(pi04) < 0) {
				return sinValue.multiply(BigDecimal.valueOf(0.7));
			}
		}
		return sinValue;
	}
	@Override
	public void setRobotParamSevice(RobotParamService service) {
		this.robotParamService = service;
	}

	@Override
	public void setRestTemplate(RestTemplate rest) {
		this.restTemplate = rest;
	}

	@Override
	public Instant getLastSendOrderTime() {
		return this.lastSendOrderTime;
	}

	@Override
	public void setCustomRobotKlineService(CustomRobotKlineService service) {
		this.customRobotKlineService = service;
	}

	/**
	 * 重载今天的K线数据
	 */
	@Override
	public boolean reloadCustomRobotKline() {
		Date t = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String dateStr = df.format(t);
		CustomRobotKline kline = this.customRobotKlineService.findOne(this.plateSymbol, dateStr);

		if(kline != null) {
			this.cDate = dateStr;
			this.pricePercent = kline.getPricePencent();
			
			String jsonStr = kline.getKline();
			JSONArray jsonArr = JSONArray.parseArray(jsonStr);

			for(int i = 0; i < jsonArr.size(); i++) {
				JSONArray arr = jsonArr.getJSONArray(i);
				this.klinePriceArr[arr.getIntValue(0)] = arr.getBigDecimal(1);
			}
			logger.info(dateStr + "K线数据重载成功！");
			return true;
		}else {
			logger.info("控盘机器人K线趋势数据缺失，请到后台添加K线");
			return false;
		}
	}
	/**
	 * 停止线程
	 */
	@Override
	public void interrupt() {
		running.set(false);
	}

	@Override
	public boolean isRunning() {
		return running.get();
	}

	@Override
	public void setRobotStrategy(int strategy, String flowPair, BigDecimal flowPercent) {
		this.robotParams.setStrategyType(strategy);
		this.robotParams.setFlowPair(flowPair);
		this.robotParams.setFlowPercent(flowPercent);

		robotParamService.update(this.plateSymbol, this.robotParams);
	}
}
