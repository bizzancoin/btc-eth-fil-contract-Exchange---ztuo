package com.bizzan.er.normal.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.bizzan.er.normal.entity.RobotParams;

@Service
public class RobotParamService {
	@Autowired
    private MongoTemplate mongoTemplate;
	
	public RobotParams findOne(String coinName){
        Query query = new Query();
        Criteria criteria = Criteria.where("coinName").is(coinName);
        query.addCriteria(criteria);
        return mongoTemplate.findOne(query, RobotParams.class, "robot_params");
    }
	
	public void update(String coinName, RobotParams params){
		RobotParams param = findOne(coinName);
        if(param != null){
            Query query = new Query();
            Criteria criteria = Criteria.where("coinName").is(coinName);
            query.addCriteria(criteria);
            Update update =  new Update();
            update.set("isHalt", params.isHalt());
            update.set("startAmount", params.getStartAmount());
            update.set("randRange0", params.getRandRange0());
            update.set("randRange1", params.getRandRange1());
            update.set("randRange2", params.getRandRange2());
            update.set("randRange3", params.getRandRange3());
            update.set("randRange4", params.getRandRange4());
            update.set("randRange5", params.getRandRange5());
            update.set("randRange6", params.getRandRange6());
            update.set("scale", params.getScale());
            update.set("amountScale", params.getAmountScale());
            update.set("maxSubPrice", params.getMaxSubPrice());
            update.set("initOrderCount", params.getInitOrderCount());
            update.set("priceStepRate", params.getPriceStepRate());
            update.set("runTime", params.getRunTime());
            update.set("robotType", params.getRobotType());
            update.set("strategyType", params.getStrategyType());
            update.set("flowPair", params.getFlowPair());
            update.set("flowPercent", params.getFlowPercent());
            
            mongoTemplate.updateFirst(query, update, "robot_params");
        }
        else{
        	RobotParams robotParams = new RobotParams();
        	robotParams.setCoinName(coinName);
        	robotParams.setHalt(params.isHalt());
        	robotParams.setStartAmount(params.getStartAmount());
        	robotParams.setRandRange0(params.getRandRange0());
        	robotParams.setRandRange1(params.getRandRange1());
        	robotParams.setRandRange2(params.getRandRange2());
        	robotParams.setRandRange3(params.getRandRange3());
        	robotParams.setRandRange4(params.getRandRange4());
        	robotParams.setRandRange5(params.getRandRange5());
        	robotParams.setRandRange6(params.getRandRange6());
        	robotParams.setScale(params.getScale());
        	robotParams.setAmountScale(params.getAmountScale());
        	robotParams.setMaxSubPrice(params.getMaxSubPrice());
        	robotParams.setInitOrderCount(params.getInitOrderCount());
        	robotParams.setPriceStepRate(params.getPriceStepRate());
        	robotParams.setRunTime(params.getRunTime());
        	robotParams.setRobotType(params.getRobotType());
        	robotParams.setStrategyType(params.getStrategyType());
        	robotParams.setFlowPair(params.getFlowPair());
        	robotParams.setFlowPercent(params.getFlowPercent());
            mongoTemplate.insert(robotParams, "robot_params");
        }
    }

}
