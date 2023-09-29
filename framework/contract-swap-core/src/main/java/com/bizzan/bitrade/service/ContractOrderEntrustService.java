package com.bizzan.bitrade.service;

import com.bizzan.bitrade.dao.ContractOrderEntrustRepository;
import com.bizzan.bitrade.entity.*;
import com.bizzan.bitrade.pagination.Criteria;
import com.bizzan.bitrade.pagination.Restrictions;
import com.bizzan.bitrade.service.Base.BaseService;
import com.querydsl.core.types.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class ContractOrderEntrustService  extends BaseService {
    @Autowired
    private LocaleMessageSourceService msService;

    @Autowired
    private ContractOrderEntrustRepository contractOrderEntrustRepository;

    public Page<ContractOrderEntrust> findAll(Predicate predicate, Pageable pageable) {
        return contractOrderEntrustRepository.findAll(predicate, pageable);
    }
    public ContractOrderEntrust save(ContractOrderEntrust order) {
        return contractOrderEntrustRepository.saveAndFlush(order);
    }
    /**
     * 查询所有需要处理的委托
     * @return
     */
    public List<ContractOrderEntrust> findAllNeedMatch() {
        return contractOrderEntrustRepository.findAllNeedMatch();
    }

    /**
     * 查询指定币种某一个用户正在委托的订单(包含开仓订单和平仓订单）
     * @param memberId
     * @param pattern
     * @return
     */
    public long queryEntrustingOrdersCountByContractCoinIdAndPattern(Long memberId, Long contractCoinId, ContractOrderPattern pattern) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractCoinId, false));
        specification.add(Restrictions.eq("patterns", pattern, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));

        return contractOrderEntrustRepository.count(specification);
    }

    /**
     * 查询指定币种某一个用户正在委托的订单(包含开仓订单和平仓订单）
     * @param memberId
     * @param contractCoinId
     * @return
     */
    public long queryEntrustingOrdersCountByContractCoinId(Long memberId, Long contractCoinId) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractCoinId, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));

        return contractOrderEntrustRepository.count(specification);
    }

    /**
     * 查找指定仓位模式开仓中的委托订单（仅查询开仓中的订单）- 指定币种
     * @param memberId
     * @return
     */
    public List<ContractOrderEntrust> queryEntrustOpeningOrdersBySymbol(Long memberId, Long contractCoinId) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractCoinId, false));
        specification.add(Restrictions.eq("entrustType", ContractOrderEntrustType.OPEN, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));
        return contractOrderEntrustRepository.findAll(specification);
    }

    /**
     * 查找指定仓位模式平仓中的委托订单（仅查询平仓中的订单）- 指定币种
     * @param memberId
     * @return
     */
    public List<ContractOrderEntrust> queryEntrustClosingOrdersBySymbolAndDirection(Long memberId, String symbol, ContractOrderDirection direction) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("symbol", symbol, false));
        specification.add(Restrictions.eq("direction", direction, false));
        specification.add(Restrictions.eq("entrustType", ContractOrderEntrustType.CLOSE, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));
        return contractOrderEntrustRepository.findAll(specification);
    }

    /**
     * 查询所有开仓中的订单
     * @param memberId
     * @return
     */
    public List<ContractOrderEntrust> queryAllEntrustOpeningOrders(Long memberId) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("entrustType", ContractOrderEntrustType.OPEN, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));
        return contractOrderEntrustRepository.findAll(specification);
    }
    /**
     * 根据合约ID查询所有平中的订单
     * @param memberId
     * @return
     */
    public List<ContractOrderEntrust> queryAllEntrustClosingOrdersByContractCoin(Long memberId, Long contractId, ContractOrderDirection direction) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractId, false));
        specification.add(Restrictions.eq("direction", direction, false));
        specification.add(Restrictions.eq("entrustType", ContractOrderEntrustType.CLOSE, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));
        return contractOrderEntrustRepository.findAll(specification);
    }
    /**
     * 查询指定用户指定币种当前所有开仓委托
     * @param memberId
     * @param symbol
     * @return
     */
    public List<ContractOrderEntrust> queryAllEntrustOpeningOrdersBySymbol(Long memberId, String symbol) {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();

        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("symbol", symbol, false));
        specification.add(Restrictions.eq("entrustType", ContractOrderEntrustType.OPEN, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));
        return contractOrderEntrustRepository.findAll(specification);
    }

    /**
     * 查询指定用户指定币种当前所有开仓委托(分页)
     * @param memberId
     * @param contractCoinId
     * @return
     */
    public Page<ContractOrderEntrust> queryPageEntrustingOrdersBySymbol(Long memberId, Long contractCoinId, int pageNo, int pageSize) {

        Sort orders = new Sort(new Sort.Order(Sort.Direction.DESC, "createTime"));
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();

        PageRequest pageRequest = new PageRequest(pageNo - 1, pageSize, orders);

        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractCoinId, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_ING, false));

        return contractOrderEntrustRepository.findAll(specification, pageRequest);
    }

    /**
     * 查询指定用户指定币种所有历史委托(分页)
     * @param memberId
     * @return
     */
    public Page<ContractOrderEntrust> queryPageEntrustHistoryOrdersBySymbol(Long memberId, Long contractCoinId, int pageNo, int pageSize) {

        Sort orders = new Sort(new Sort.Order(Sort.Direction.DESC, "createTime"));
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();

        PageRequest pageRequest = new PageRequest(pageNo - 1, pageSize, orders);

        specification.add(Restrictions.eq("memberId", memberId, false));
        specification.add(Restrictions.eq("contractId", contractCoinId, false));
        specification.add(Restrictions.ne("status", ContractOrderEntrustStatus.ENTRUST_ING, false));

        return contractOrderEntrustRepository.findAll(specification, pageRequest);
    }

    public ContractOrderEntrust findOne(Long entrustId) {
        return contractOrderEntrustRepository.findOne(entrustId);
    }

    public void updateStatus(Long id, ContractOrderEntrustStatus status) {
        contractOrderEntrustRepository.updateStatus(id, status);
    }

    public List<ContractOrderEntrust> loadUnMatchOrders(Long id) {
        return contractOrderEntrustRepository.loadUnMatchOrders(id);
    }

    public List<ContractOrderEntrust> findAllByMemberIdAndContractId(long memberId, Long contractCoinId) {
        return contractOrderEntrustRepository.findAllByMemberIdAndContractId(memberId, contractCoinId);
    }

    /**
     * 查询可以返佣的订单
     * @return
     */
    public List<ContractOrderEntrust> findCanRewardOrders() {
        Criteria<ContractOrderEntrust> specification = new Criteria<ContractOrderEntrust>();
        specification.add(Restrictions.eq("isReward", 0, false));
        specification.add(Restrictions.eq("status", ContractOrderEntrustStatus.ENTRUST_SUCCESS, false));
        return contractOrderEntrustRepository.findAll(specification);
    }
}
