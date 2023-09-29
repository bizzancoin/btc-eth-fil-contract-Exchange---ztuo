package com.bizzan.bitrade.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bizzan.bitrade.dao.FeedbackDao;
import com.bizzan.bitrade.entity.Feedback;
import com.bizzan.bitrade.service.Base.BaseService;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年03月19日
 */
@Service
public class FeedbackService extends BaseService {
    @Autowired
    private FeedbackDao feedbackDao;

    public Feedback save(Feedback feedback){
        return feedbackDao.save(feedback);
    }
}
