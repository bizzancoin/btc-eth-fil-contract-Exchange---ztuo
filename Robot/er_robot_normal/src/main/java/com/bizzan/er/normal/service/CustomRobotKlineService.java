package com.bizzan.er.normal.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.bizzan.er.normal.entity.CustomRobotKline;
import com.bizzan.er.normal.entity.RobotParams;

@Service
public class CustomRobotKlineService {
	@Autowired
    private MongoTemplate mongoTemplate;
	
	public CustomRobotKline findOne(String coinName, String kdate){
        Query query = new Query();
        Criteria criteria = Criteria.where("coinName").is(coinName);
        Criteria criteria1 = Criteria.where("kdate").is(kdate);
        query.addCriteria(criteria);
        query.addCriteria(criteria1);
        return mongoTemplate.findOne(query, CustomRobotKline.class, "robot_kline");
    }
	
	public void update(String coinName, String kdate, CustomRobotKline params){
		CustomRobotKline param = findOne(coinName, kdate);
        if(param != null){
            Query query = new Query();
            Criteria criteria = Criteria.where("coinName").is(coinName);
            Criteria criteria1 = Criteria.where("kdate").is(kdate);
            query.addCriteria(criteria);
            query.addCriteria(criteria1);
            Update update =  new Update();
            update.set("coinName", params.getCoinName());
            update.set("kdate", params.getKdate());
            update.set("kline", params.getKline());
            update.set("pricePencent", params.getPricePencent());
            
            mongoTemplate.updateFirst(query, update, "robot_kline");
        }
        else{
        	CustomRobotKline newObj = new CustomRobotKline();
        	newObj.setCoinName(params.getCoinName());
        	newObj.setKdate(params.getKdate());
        	newObj.setKline(params.getKline());
        	newObj.setPricePencent(params.getPricePencent());
        	
            mongoTemplate.insert(newObj, "robot_kline");
        }
    }
	
	/**
	 * 查询某交易对某个日期以后的K线趋势
	 * 这里需要注意：系统是不支持对历史K线趋势进行修改的
	 * @param coinName
	 * @param afterDate
	 * @return
	 */
	public List<CustomRobotKline> queryRobotKline(String coinName, String afterDate) {
		Query query = new Query();
        Criteria criteria = Criteria.where("coinName").is(coinName);
        Criteria criteria1 = Criteria.where("kdate").gte(afterDate);
        query.addCriteria(criteria);
        query.addCriteria(criteria1);
        
		return mongoTemplate.find(query, CustomRobotKline.class, "robot_kline");
	}
}
