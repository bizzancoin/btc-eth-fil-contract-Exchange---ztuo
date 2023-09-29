package com.bizzan.bitrade.model;

import com.bizzan.bitrade.constant.AuditStatus;
import com.bizzan.bitrade.controller.screen.AccountScreen;
import lombok.Data;

@Data
public class MemberApplicationScreen extends AccountScreen {
    private AuditStatus auditStatus;//审核状态
    private String cardNo ; //身份证号
}
