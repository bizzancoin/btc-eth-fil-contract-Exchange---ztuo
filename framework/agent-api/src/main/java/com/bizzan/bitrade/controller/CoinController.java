package com.bizzan.bitrade.controller;

import com.alibaba.fastjson.JSONObject;
import com.bizzan.bitrade.annotation.AccessLog;
import com.bizzan.bitrade.constant.AdminModule;
import com.bizzan.bitrade.constant.PageModel;
import com.bizzan.bitrade.constant.SysConstant;
import com.bizzan.bitrade.constant.TransactionType;
import com.bizzan.bitrade.dto.CoinDTO;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.es.ESUtils;
import com.bizzan.bitrade.service.*;
import com.bizzan.bitrade.util.*;
import com.querydsl.core.types.dsl.BooleanExpression;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.springframework.util.Assert.notNull;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @description 后台货币web
 * @date 2019/12/29 15:01
 */
@RestController
@RequestMapping("coin")
@Slf4j
public class CoinController extends BaseController {

    private Logger logger = LoggerFactory.getLogger(BaseController.class);

    @Autowired
    private HotTransferRecordService hotTransferRecordService;

    @Autowired
    private CoinService coinService;

    @Autowired
    private MemberWalletService memberWalletService;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private RedisTemplate redisTemplate;
    @Autowired
    private MemberWalletService walletService;
    @Autowired
    private MemberService memberService;

    @Autowired
    private KafkaTemplate kafkaTemplate;

    @Autowired
    private LocaleMessageSourceService messageSource;

    @Autowired
    private MemberTransactionService memberTransactionService;

    @Autowired
    private ESUtils esUtils;

    @Autowired
    JDBCUtils jdbcUtils;

    @PostMapping("all-name")
    @AccessLog(module = AdminModule.SYSTEM, operation = "查找所有coin的name")
    public MessageResult getAllCoinName() {
        List<String> list = coinService.getAllCoinName();
        return MessageResult.getSuccessInstance(messageSource.getMessage("SUCCESS"), list);
    }

    @PostMapping("all-name-and-unit")
    @AccessLog(module = AdminModule.SYSTEM, operation = "查找所有coin的name和unit")
    public MessageResult getAllCoinNameAndUnit() {
        List<CoinDTO> list = coinService.getAllCoinNameAndUnit();
        return MessageResult.getSuccessInstance(messageSource.getMessage("SUCCESS"), list);
    }
}
