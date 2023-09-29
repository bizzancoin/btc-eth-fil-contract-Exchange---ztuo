package com.bizzan.bitrade.entity.transform;

import lombok.Data;

import java.util.List;

/**
 *
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年01月15日
 */
@Data
public class SpecialPage<E> {

    private List<E> context;
    private int currentPage;
    private int totalPage;
    private int pageNumber;
    private int totalElement;
}
