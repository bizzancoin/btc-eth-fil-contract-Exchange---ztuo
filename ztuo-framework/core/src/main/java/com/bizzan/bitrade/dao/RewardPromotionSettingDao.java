package com.bizzan.bitrade.dao;

import com.bizzan.bitrade.constant.BooleanEnum;
import com.bizzan.bitrade.constant.PromotionRewardType;
import com.bizzan.bitrade.dao.base.BaseDao;
import com.bizzan.bitrade.entity.RewardPromotionSetting;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年03月08日
 */
public interface RewardPromotionSettingDao extends BaseDao<RewardPromotionSetting> {
    RewardPromotionSetting findByStatusAndType(BooleanEnum booleanEnum, PromotionRewardType type);
}
