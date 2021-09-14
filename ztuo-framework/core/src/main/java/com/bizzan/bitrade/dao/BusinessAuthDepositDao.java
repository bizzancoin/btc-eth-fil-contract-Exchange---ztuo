package com.bizzan.bitrade.dao;

import java.util.List;

import com.bizzan.bitrade.constant.CommonStatus;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.BusinessAuthDeposit;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2019/5/5
 */
public interface BusinessAuthDepositDao extends BaseDao<BusinessAuthDeposit> {
    public List<BusinessAuthDeposit> findAllByStatus(CommonStatus status);
}
