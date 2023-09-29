package com.bizzan.bitrade.dao;

import org.springframework.data.jpa.repository.Query;

import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.dto.SmsDTO;

import java.util.List;

/**
 * @Description:
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date: create in 9:47 2019/6/28
 * @Modified:
 */
public interface SmsDao extends BaseDao<SmsDTO> {
    
    @Query(value = "select * from tb_sms where sms_status = '0' ",nativeQuery = true)
    SmsDTO findBySmsStatus();
}
