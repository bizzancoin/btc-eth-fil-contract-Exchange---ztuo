package com.bizzan.bitrade.dao;

import java.util.List;

import com.bizzan.bitrade.constant.CommonStatus;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.Coin;
import com.bizzan.bitrade.entity.TransferAddress;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年02月27日
 */
public interface TransferAddressDao extends BaseDao<TransferAddress> {
    List<TransferAddress> findAllByStatusAndCoin(CommonStatus status, Coin coin);

    TransferAddress findByAddressAndCoin(String address, Coin coin);
}
