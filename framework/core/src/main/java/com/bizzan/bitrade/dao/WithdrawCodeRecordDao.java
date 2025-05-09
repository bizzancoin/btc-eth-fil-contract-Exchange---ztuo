package com.bizzan.bitrade.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.bizzan.bitrade.constant.WithdrawStatus;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.WithdrawCodeRecord;
import com.bizzan.bitrade.entity.WithdrawRecord;

import java.util.List;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年01月29日
 */
public interface WithdrawCodeRecordDao extends BaseDao<WithdrawCodeRecord> {

    @Query(value = "select a.unit , sum(b.withdraw_amount) amount,sum(b.fee) from withdraw_record b,coin a where a.name = b.coin_id and date_format(b.deal_time,'%Y-%m-%d') = :date and b.status = 3 group by a.unit",nativeQuery = true)
    List<Object[]> getWithdrawStatistics(@Param("date")String date);

    long countAllByStatus(WithdrawStatus status);

	WithdrawCodeRecord findByWithdrawCode(String withdrawCode);
}
