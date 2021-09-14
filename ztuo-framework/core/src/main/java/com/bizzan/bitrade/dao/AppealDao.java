package com.bizzan.bitrade.dao;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.bizzan.bitrade.constant.AppealStatus;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.Appeal;

import java.util.Map;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年01月23日
 */
public interface AppealDao extends BaseDao<Appeal> {

    @Query("select count(a.id) as complainantNum from Appeal a where a.initiatorId = :memberId")
    Long getBusinessAppealInitiatorIdStatistics(@Param("memberId")Long memberId);

    @Query("select count(a.id) as defendantNum from Appeal a where a.associateId = :memberId")
    Long getBusinessAppealAssociateIdStatistics(@Param("memberId")Long memberId);

    long countAllByStatus(AppealStatus status);
}
