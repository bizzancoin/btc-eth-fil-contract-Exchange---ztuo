package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.DataDictionary;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @Title: ${file_name}
 * @Description:
 * @date 2019/4/1214:15
 */
public interface DataDictionaryDao extends BaseDao<DataDictionary> {
    DataDictionary findByBond(String bond);
}
