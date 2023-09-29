package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.constant.SignStatus;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.Sign;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @Description:
 * @date 2019/5/311:10
 */
public interface SignDao extends BaseDao<Sign> {
    Sign findByStatus(SignStatus status);
}
