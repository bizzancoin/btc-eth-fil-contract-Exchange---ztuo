package com.bizzan.er.price.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.bizzan.er.price.entity.PriceRobotParams;

@Service
public class RobotParamService {
	@Autowired
    private MongoTemplate mongoTemplate;
	
	public PriceRobotParams findOne(String coinName){
        Query query = new Query();
        Criteria criteria = Criteria.where("coinName").is(coinName);
        query.addCriteria(criteria);
        return mongoTemplate.findOne(query, PriceRobotParams.class, "robot_params");
    }
	
	public void update(String coinName, PriceRobotParams params){
		PriceRobotParams param = findOne(coinName);
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
            update.set("price", params.getPrice());
            update.set("maxSubPrice", params.getMaxSubPrice());
            update.set("initOrderCount", params.getInitOrderCount());
            update.set("priceStepRate", params.getPriceStepRate());
            update.set("runTime", params.getRunTime());
            
            mongoTemplate.updateFirst(query, update, "robot_params");
        }
        else{
        	PriceRobotParams robotParams = new PriceRobotParams();
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
        	robotParams.setPrice(params.getPrice());
        	robotParams.setMaxSubPrice(params.getMaxSubPrice());
        	robotParams.setInitOrderCount(params.getInitOrderCount());
        	robotParams.setPriceStepRate(params.getPriceStepRate());
        	robotParams.setRunTime(params.getRunTime());
            mongoTemplate.insert(robotParams, "robot_params");
        }
    }

}
