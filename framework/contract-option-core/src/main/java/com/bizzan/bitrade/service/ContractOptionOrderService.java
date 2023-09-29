package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractOptionCoinRepository;
import com.bizzan.bitrade.dao.ContractOptionOrderRepository;
import com.bizzan.bitrade.dao.ContractOptionRepository;
import com.bizzan.bitrade.entity.ContractOption;
import com.bizzan.bitrade.entity.ContractOptionCoin;
import com.bizzan.bitrade.entity.ContractOptionOrder;
import com.bizzan.bitrade.entity.ContractOptionOrderDirection;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.pagination.Restrictions;
import com.bizzan.bitrade.service.Base.BaseService;
import com.bizzan.bitrade.util.MessageResult;
import com.querydsl.core.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.Calendar;
import java.util.List;

@Slf4j
@Service
public class ContractOptionOrderService extends BaseService {

    @Autowired
    private LocaleMessageSourceService msService;

    @Autowired
    private ContractOptionOrderRepository contractOptionOrderRepository;

    @Autowired
    private ContractOptionRepository contractOptionRepository;

    @Autowired
    private ContractOptionCoinRepository contractOptionCoinRepository;

    public Page<ContractOptionOrder> findAll(Predicate predicate, Pageable pageable) {
        return contractOptionOrderRepository.findAll(predicate, pageable);
    }

    public Page<ContractOptionOrder> findAll(Long memberId, String symbol, int pageNo, int pageSize) {
        Sort orders = new Sort(new Sort.Order(Sort.Direction.DESC, "createTime"));
        PageRequest pageRequest = new PageRequest(pageNo, pageSize, orders);
        Criteria<ContractOptionOrder> specification = new Criteria<ContractOptionOrder>();
        if(symbol != null && StringUtils.isNotEmpty(symbol)) {
            specification.add(Restrictions.eq("symbol", symbol, true));
        }
        specification.add(Restrictions.eq("memberId", memberId, false));
        return contractOptionOrderRepository.findAll(specification, pageRequest);
    }

    public ContractOptionOrder save(ContractOptionOrder order) {
        return contractOptionOrderRepository.saveAndFlush(order);
    }

    public List<ContractOptionOrder> findByMemberIdAndOptionId(Long memberId, Long optionId) {
        return contractOptionOrderRepository.findByMemberIdAndOptionId(memberId, optionId);
    }

    public List<ContractOptionOrder> findByOptionId(Long optionId){
        return contractOptionOrderRepository.findByOptionId(optionId);
    }

    public List<ContractOptionOrder> findByMemberId(Long memberId) {
        return contractOptionOrderRepository.findByMemberId(memberId);
    }

    public MessageResult setOptionOrder(Long memberId, Integer optionNo, Short optionNoChange, Short directionChange) {
        ContractOptionOrder order = contractOptionOrderRepository.findByMemberIdOptionNo(memberId,optionNo);
        if(order == null){
            return MessageResult.error(msService.getMessage("ORDER_DOES_NOT_EXIST"));
        }
        ContractOption option = contractOptionRepository.getOne(order.getOptionId());
        if(option == null){
            return MessageResult.error(msService.getMessage("CONTRACT_PERIOD_DOES_NOT_EXIST"));
        }
        ContractOptionCoin coin = contractOptionCoinRepository.findOne(option.getSymbol());
        long currentTime = Calendar.getInstance().getTimeInMillis();
        long timeGap = currentTime - option.getOpenTime();
        if(timeGap/1000 > coin.getCloseTimeGap()-6){
            return MessageResult.error(msService.getMessage("SETUP_FAILED"));
        }
        if(optionNoChange == 2){
            order.setOptionNo(order.getOptionNo()+1);
            ContractOption nextOption = contractOptionRepository.findBySymbolAndOptionNo(order.getSymbol(), order.getOptionNo());
            if(nextOption == null){
                return MessageResult.error(msService.getMessage("CONTRACT_PERIOD_DOES_NOT_EXIST"));
            }
            order.setOptionId(nextOption.getId());
        }
        if(directionChange == 2){
            if(order.getDirection().getCode() == 0){
                order.setDirection(ContractOptionOrderDirection.SELL);
            }else if(order.getDirection().getCode() == 1){
                order.setDirection(ContractOptionOrderDirection.BUY);
            }
        }
        contractOptionOrderRepository.setOptionNoDirection(order.getId(),order.getOptionNo(),order.getOptionId(),order.getDirection());
        return MessageResult.success();
    }
}
