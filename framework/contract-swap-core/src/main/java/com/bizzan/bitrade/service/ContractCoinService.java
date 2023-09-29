package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractCoinRepository;
import com.bizzan.bitrade.entity.ContractCoin;
import com.bizzan.bitrade.entity.ContractType;
import com.bizzan.bitrade.entity.KLine;
import com.bizzan.bitrade.entity.Poke;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.service.Base.BaseService;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Path;
import java.math.BigDecimal;
import java.util.List;

@Service
public class ContractCoinService  extends BaseService {
    @Autowired
    private ContractCoinRepository coinRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    public List<ContractCoin> findAllEnabled() {
        Specification<ContractCoin> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Path<String> enable = root.get("enable");
            criteriaQuery.where(criteriaBuilder.equal(enable, 1));
            return null;
        };
        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "sort");
        Sort sort = new Sort(order);
        return coinRepository.findAll(spec, sort);
    }

    //获取所有可显示币种
    public List<ContractCoin> findAllVisible() {
        Specification<ContractCoin> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Path<String> visible = root.get("visible");
            Path<String> enable = root.get("enable");
            criteriaQuery.where(criteriaBuilder.equal(enable, 1), criteriaBuilder.equal(visible, 1));
            return null;
        };
        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "sort");
        Sort sort = new Sort(order);
        return coinRepository.findAll(spec, sort);
    }

    public ContractCoin findOne(Long id) {
        return coinRepository.findOne(id);
    }


    public ContractCoin save(ContractCoin contractCoin) {
        return coinRepository.save(contractCoin);
    }

    public Page<ContractCoin> pageQuery(int pageNo, Integer pageSize) {
        Sort orders = Criteria.sortStatic("sort");
        PageRequest pageRequest = new PageRequest(pageNo - 1, pageSize, orders);
        return coinRepository.findAll(pageRequest);
    }

    /**
     * 获取合约交易对，如果引入多类型合约，使用该函数的地方都需要更改为：findBySymbolAndCategory
     * @param symbol
     * @return
     */
    public ContractCoin findBySymbol(String symbol) {
        return coinRepository.findBySymbol(symbol);
    }

    public ContractCoin findBySymbolAndType(String symbol, ContractType type) {
        return coinRepository.findBySymbolAndType(symbol, type);
    }
    public List<ContractCoin> findAll() {
        return coinRepository.findAll();
    }

    public boolean isSupported(String symbol) {
        ContractCoin coin = findBySymbol(symbol);
        return coin != null && (coin.getEnable() == 1);
    }

    public Page<ContractCoin> findAll(Predicate predicate, Pageable pageable) {
        return coinRepository.findAll(predicate, pageable);
    }

    public List<String> getBaseSymbol() {
        return coinRepository.findBaseSymbol();
    }

    public List<String> getCoinSymbol(String baseSymbol) {
        return coinRepository.findCoinSymbol(baseSymbol);
    }

    public List<String> getAllCoin(){
        return coinRepository.findAllCoinSymbol();
    }

    public void increaseTotalLoss(Long id, BigDecimal amount) {
        coinRepository.increaseTotalLoss(id, amount);
    }

    public void increaseTotalProfit(Long id, BigDecimal amount) {
        coinRepository.increaseTotalProfit(id, amount);
    }

    public void increaseTotalOpenFee(Long id, BigDecimal amount) {
        coinRepository.increaseOpenFee(id, amount);
    }

    public void increaseTotalCloseFee(Long id, BigDecimal amount) {
        coinRepository.increaseCloseFee(id, amount);
    }

    /**
     * 戳一下
     * @param symbol
     * @param price
     */
    public void savePoke(String symbol, BigDecimal price){
        Poke poke = new Poke(price.stripTrailingZeros().toPlainString());
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_kline");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_depth");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_detail");
        mongoTemplate.insert(poke,"contract_poke_"+symbol+"_trade");
    }
}
