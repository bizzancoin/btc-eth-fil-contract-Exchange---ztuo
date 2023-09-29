package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractOptionOrderRepository;
import com.bizzan.bitrade.dao.ContractOptionRepository;
import com.bizzan.bitrade.entity.ContractOption;
import com.bizzan.bitrade.entity.ContractOptionOrder;
import com.bizzan.bitrade.entity.ContractOptionStatus;
import com.bizzan.bitrade.entity.Poke;
import com.bizzan.bitrade.entity.PresetPrice;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.pagination.Restrictions;
import com.bizzan.bitrade.service.Base.BaseService;
import com.querydsl.core.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
public class ContractOptionService extends BaseService {

    @Autowired
    private LocaleMessageSourceService msService;
    @Autowired
    private MongoTemplate mongoTemplate;


    @Autowired
    private ContractOptionRepository contractOptionRepository;

    public Page<ContractOption> findAll(Predicate predicate, Pageable pageable) {
        return contractOptionRepository.findAll(predicate, pageable);
    }

    public ContractOption save(ContractOption option) {
        return contractOptionRepository.saveAndFlush(option);
    }

    public ContractOption findOne(Long optionId) {
        return contractOptionRepository.findOne(optionId);
    }

    public Page<ContractOption> findAll(String symbol, int count) {
        Sort orders = new Sort(new Sort.Order(Sort.Direction.DESC, "createTime"));
        PageRequest pageRequest = new PageRequest(0, count, orders);
        Criteria<ContractOption> specification = new Criteria<ContractOption>();
        if(symbol != null && StringUtils.isNotEmpty(symbol)) {
            specification.add(Restrictions.eq("symbol", symbol, true));
        }
        specification.add(Restrictions.eq("status", ContractOptionStatus.CLOSED, true));
        return contractOptionRepository.findAll(specification, pageRequest);
    }

    public List<ContractOption> findBySymbolAndStatus(String symbol, ContractOptionStatus status) {
        return contractOptionRepository.findBySymbolAndStatus(symbol, status);
    }

    public ContractOption findBySymbolAndOptionNo(String symbol,int perOptionNo) {
        return contractOptionRepository.findBySymbolAndOptionNo(symbol, perOptionNo);
    }

    /**
     * 设置kline 类似戳一下
     * @param symbol
     * @param price
     */
    public void savePresetPrice(String symbol, BigDecimal price){
        PresetPrice presetPrice = new PresetPrice(price.stripTrailingZeros().toPlainString());
//        mongoTemplate.insert(presetPrice,"contract_preset_price_"+symbol+"_kline");
//        mongoTemplate.insert(presetPrice,"contract_preset_price_"+symbol+"_depth");
        mongoTemplate.insert(presetPrice,"contract_preset_price_"+symbol+"_detail");
//        mongoTemplate.insert(presetPrice,"contract_preset_price_"+symbol+"_trade");
        Poke poke = new Poke(price.stripTrailingZeros().toPlainString());
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_kline");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_depth");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_detail");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_trade");
    }


}
