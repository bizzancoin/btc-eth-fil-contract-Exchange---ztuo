package com.bizzan.bitrade.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bizzan.bitrade.constant.Platform;
import com.bizzan.bitrade.dao.AppRevisionDao;
import com.bizzan.bitrade.entity.AppRevision;
import com.bizzan.bitrade.service.Base.TopBaseService;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @Title: ${file_name}
 * @Description:
 * @date 2019/4/2416:19
 */
@Service
public class AppRevisionService extends TopBaseService<AppRevision, AppRevisionDao> {

    @Override
    @Autowired
    public void setDao(AppRevisionDao dao) {
        super.setDao(dao);
    }

    public AppRevision findRecentVersion(Platform p){
        return dao.findAppRevisionByPlatformOrderByIdDesc(p);
    }
}
