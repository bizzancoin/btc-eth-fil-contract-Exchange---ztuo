package com.bizzan.bitrade.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.SysPermission;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年12月18日
 */
public interface SysPermissionDao extends BaseDao<SysPermission> {

    @Modifying
    @Query(value="delete from admin_role_permission where rule_id = ?1",nativeQuery = true)
    int deletePermission(long permissionId);
}
