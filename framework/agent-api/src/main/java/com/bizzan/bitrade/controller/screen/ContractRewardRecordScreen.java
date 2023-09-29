package com.bizzan.bitrade.controller.screen;

import com.bizzan.bitrade.constant.ContractRewardRecordType;
import com.bizzan.bitrade.constant.TransactionType;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @author sulinxin
 */
@Data
public class ContractRewardRecordScreen {

    /**
     * 交易时间搜索
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    private Date startTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(timezone = "GMT+8",pattern = "yyyy-MM-dd")
    private Date endTime;
    /**
     * 0开仓手续费返佣  1平仓手续费返佣
     */
    private ContractRewardRecordType type;

    private Long memberId ;

    private String symbol;
}
