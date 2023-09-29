package com.bizzan.bitrade.model.screen;

import com.bizzan.bitrade.constant.ContractRewardRecordType;
import com.bizzan.bitrade.entity.ContractOrderDirection;
import com.bizzan.bitrade.entity.ContractOrderEntrustStatus;
import com.bizzan.bitrade.entity.ContractOrderEntrustType;
import com.bizzan.bitrade.entity.ContractOrderType;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class ContractRewardRecordScreen {
    private ContractRewardRecordType type;
    private Long memberId;
    @JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    private Date startTime;
    @JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    private Date endTime;
}
