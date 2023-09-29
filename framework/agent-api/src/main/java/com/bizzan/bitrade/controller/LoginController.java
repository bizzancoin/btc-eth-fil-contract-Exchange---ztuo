package com.bizzan.bitrade.controller;

import com.bizzan.bitrade.entity.LoginInfo;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.bizzan.bitrade.constant.SysConstant;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.Sign;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.event.MemberEvent;
import com.bizzan.bitrade.service.LocaleMessageSourceService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.service.SignService;
import com.bizzan.bitrade.system.GeetestLib;
import com.bizzan.bitrade.util.MessageResult;

import javax.servlet.http.HttpServletRequest;

import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;

import java.util.Calendar;
import java.util.HashMap;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年01月10日
 */
@RestController
@Slf4j
public class LoginController extends BaseController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberEvent memberEvent;
    @Autowired
    private LocaleMessageSourceService messageSourceService;
    @Autowired
    private LocaleMessageSourceService msService;
    @Autowired
    private GeetestLib gtSdk;
    @Autowired
    private SignService signService;
    
    @Value("${person.promote.prefix:}")
    private String promotePrefix;

    @RequestMapping(value = "/login")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult login(HttpServletRequest request, String username, String password) {
        Assert.hasText(username, messageSourceService.getMessage("MISSING_USERNAME"));
        Assert.hasText(password, messageSourceService.getMessage("MISSING_PASSWORD"));
        String ip = getRemoteIp(request);

        try {
            LoginInfo loginInfo = getLoginInfo(username, password, ip, request);
            return success(loginInfo);
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    private LoginInfo getLoginInfo(String username, String password, String ip, HttpServletRequest request) throws Exception {
        Member member = memberService.login(username, password);
        memberEvent.onLoginSuccess(member, ip);
        request.getSession().setAttribute(SysConstant.SESSION_MEMBER, AuthMember.toAuthMember(member));
        String token = request.getHeader("access-auth-token");
        if (!StringUtils.isBlank(token)) {
            member.setToken(token);
        }
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR_OF_DAY, 24 * 7);
        member.setTokenExpireTime(calendar.getTime());
        // 获取登录次数
        int loginCount = member.getLoginCount();
        member.setLoginCount(loginCount+1);
        // 签到活动是否进行
        Sign sign = signService.fetchUnderway();
        LoginInfo loginInfo;
        if (sign == null) {
            loginInfo = LoginInfo.getLoginInfo(member, request.getSession().getId(), false, promotePrefix);
        } else {
            loginInfo = LoginInfo.getLoginInfo(member, request.getSession().getId(), true, promotePrefix);
        }
        return loginInfo;
    }

    /**
     * 登出
     *
     * @return
     */
    @RequestMapping(value = "/loginout")
    @Transactional(rollbackFor = Exception.class)
    public MessageResult loginOut(HttpServletRequest request, @SessionAttribute(SESSION_MEMBER) AuthMember user) {
        MessageResult messageResult = new MessageResult();
        log.info(">>>>>退出登陆接口开始>>>>>");
        try {
            request.getSession().removeAttribute(SysConstant.SESSION_MEMBER);
            Member member = memberService.findOne(user.getId());
            member.setToken(null);
            messageResult= request.getSession().getAttribute(SysConstant.SESSION_MEMBER) != null ? error(messageSourceService.getMessage("LOGOUT_FAILED")) : success(messageSourceService.getMessage("LOGOUT_SUCCESS"));
        } catch (Exception e) {
            e.printStackTrace();
            log.info(">>>>>登出失败>>>>>"+e);
        }
        log.info(">>>>>退出登陆接口结束>>>>>");
        return messageResult;
    }

    /**
     * 检查是否登录
     *
     * @param request
     * @return
     */
    @RequestMapping("/check/login")
    public MessageResult checkLogin(HttpServletRequest request) {
        AuthMember authMember = (AuthMember) request.getSession().getAttribute(SESSION_MEMBER);
        MessageResult result = MessageResult.success();
        if (authMember != null) {
            result.setData(true);
        } else {
            result.setData(false);
        }
        return result;
    }
}
