package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractOptionCoinRepository;
import com.bizzan.bitrade.entity.ContractOption;
import com.bizzan.bitrade.entity.ContractOptionCoin;
import com.bizzan.bitrade.entity.ContractOptionStatus;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.service.Base.BaseService;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Path;
import java.util.List;

@Service
public class ContractOptionCoinService extends BaseService {
    @Autowired
    private ContractOptionCoinRepository coinRepository;

    public List<ContractOptionCoin> findAllEnabled() {
        Specification<ContractOptionCoin> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Path<String> enable = root.get("enable");
            criteriaQuery.where(criteriaBuilder.equal(enable, 1));
            return null;
        };
        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "sort");
        Sort sort = new Sort(order);
        return coinRepository.findAll(spec, sort);
    }

    //获取所有可显示币种
    public List<ContractOptionCoin> findAllVisible() {
        Specification<ContractOptionCoin> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Path<String> visible = root.get("visible");
            Path<String> enable = root.get("enable");
            criteriaQuery.where(criteriaBuilder.equal(enable, 1), criteriaBuilder.equal(visible, 1));
            return null;
        };
        Sort.Order order = new Sort.Order(Sort.Direction.ASC, "sort");
        Sort sort = new Sort(order);
        return coinRepository.findAll(spec, sort);
    }

    public ContractOptionCoin findOne(String id) {
        return coinRepository.findOne(id);
    }


    public ContractOptionCoin save(ContractOptionCoin contractOptionCoin) {
        return coinRepository.save(contractOptionCoin);
    }

    public Page<ContractOptionCoin> pageQuery(int pageNo, Integer pageSize) {
        Sort orders = Criteria.sortStatic("sort");
        PageRequest pageRequest = new PageRequest(pageNo - 1, pageSize, orders);
        return coinRepository.findAll(pageRequest);
    }

    public ContractOptionCoin findBySymbol(String symbol) {
        return coinRepository.findBySymbol(symbol);
    }

    public List<ContractOptionCoin> findAll() {
        return coinRepository.findAll();
    }

    public boolean isSupported(String symbol) {
        ContractOptionCoin coin = findBySymbol(symbol);
        return coin != null && (coin.getEnable() == 1);
    }

    public Page<ContractOptionCoin> findAll(Predicate predicate, Pageable pageable) {
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


}
