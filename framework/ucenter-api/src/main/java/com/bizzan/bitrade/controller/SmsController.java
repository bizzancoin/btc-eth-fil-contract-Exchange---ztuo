package com.bizzan.bitrade.controller;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.*;

import com.bizzan.bitrade.constant.SysConstant;
import com.bizzan.bitrade.entity.Country;
import com.bizzan.bitrade.entity.Member;
import com.bizzan.bitrade.entity.transform.AuthMember;
import com.bizzan.bitrade.service.CountryService;
import com.bizzan.bitrade.service.LocaleMessageSourceService;
import com.bizzan.bitrade.service.MemberService;
import com.bizzan.bitrade.util.*;
import com.bizzan.bitrade.vendor.provider.SMSProvider;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import static com.bizzan.bitrade.constant.SysConstant.ADD_ADDRESS_CODE_PREFIX;
import static com.bizzan.bitrade.constant.SysConstant.SESSION_MEMBER;
import static com.bizzan.bitrade.util.MessageResult.error;
import static com.bizzan.bitrade.util.MessageResult.success;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @author tg@usdtvps666  E-mail:ovouvogh@gmail.com
 * @date 2020年01月08日
 */
@Slf4j
@RestController
@RequestMapping("/mobile")
public class SmsController {

    @Value("${spring.mail.username}")
    private String from;
    @Value("${spark.system.host}")
    private String host;
    @Value("${spark.system.name}")
    private String company;

    @Autowired
    private SMSProvider smsProvider;
    @Autowired
    private RedisTemplate redisTemplate;
    @Autowired
    private MemberService memberService;
    @Resource
    private LocaleMessageSourceService localeMessageSourceService;
    @Autowired
    private CountryService countryService;

    @Autowired
    private JavaMailSender javaMailSender;
    /**
     * 注册验证码发送
     *
     * @return
     */
    @PostMapping("/code")
    public MessageResult sendCheckCode(String phone, String country) throws Exception {
        Assert.isTrue(!memberService.phoneIsExist(phone), localeMessageSourceService.getMessage("PHONE_ALREADY_EXISTS"));
        Assert.notNull(country, localeMessageSourceService.getMessage("REQUEST_ILLEGAL"));
        Country country1 = countryService.findOne(country);
        Assert.notNull(country1, localeMessageSourceService.getMessage("REQUEST_ILLEGAL"));
        ValueOperations valueOperations = redisTemplate.opsForValue();
        String key = SysConstant.PHONE_REG_CODE_PREFIX + phone;
        Object code = valueOperations.get(key);
        if (code != null) {
            //判断如果请求间隔小于一分钟则请求失败
            if (!BigDecimalUtils.compare(DateUtil.diffMinute((Date) (valueOperations.get(key + "Time"))), BigDecimal.ONE)) {
                return error(localeMessageSourceService.getMessage("FREQUENTLY_REQUEST"));
            }
        }
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        MessageResult result;
        if ("86".equals(country1.getAreaCode())) {
            Assert.isTrue(ValidateUtil.isMobilePhone(phone.trim()), localeMessageSourceService.getMessage("PHONE_EMPTY_OR_INCORRECT"));
            result = smsProvider.sendVerifyMessage(phone, randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, country1.getAreaCode() + phone);
        }
        if (result.getCode() == 0) {
            valueOperations.getOperations().delete(key);
            valueOperations.getOperations().delete(key + "Time");
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            valueOperations.set(key + "Time", new Date(), 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }

    /**
     * 重置交易密码验证码
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/transaction/code", method = RequestMethod.POST)
    public MessageResult sendResetTransactionCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        //判断是绑定了手机还是邮箱
        String email = member.getEmail();
        String mobile = member.getMobilePhone();
        ValueOperations valueOperations = redisTemplate.opsForValue();
        if(!StringUtils.isEmpty(email)){
            //发送邮件验证码
            sentEmailAddCode(valueOperations, email, randomCode,SysConstant.PHONE_RESET_TRANS_CODE_PREFIX);
        }else if(!StringUtils.isEmpty(mobile)){
            MessageResult result;
            if ("86".equals(member.getCountry().getAreaCode())) {
                result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
            } else {
                result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
            }
            if (result.getCode() == 0) {
                String key = SysConstant.PHONE_RESET_TRANS_CODE_PREFIX + member.getMobilePhone();
                valueOperations.getOperations().delete(key);
                // 缓存验证码
                valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            } else {
                return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
            }
        }else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
        return success(localeMessageSourceService.getMessage("SENT_SUCCESS_TEN"));
    }

    /**
     * 绑定手机号验证码
     *
     * @param phone
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/bind/code", method = RequestMethod.POST)
    public MessageResult setBindPhoneCode(String country, String phone, @SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        Assert.isNull(member.getMobilePhone(), localeMessageSourceService.getMessage("REPEAT_PHONE_REQUEST"));
        MessageResult result;
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));

        // 修改所在国家
        if (StringUtils.isNotBlank(country)) {
            Country one = countryService.findOne(country);
            if (one != null) {
                member.setCountry(one);
                memberService.saveAndFlush(member);
            }
        }


        if ("86".equals(member.getCountry().getAreaCode())) {
//            if (!ValidateUtil.isMobilePhone(phone.trim())) {
//                return error(localeMessageSourceService.getMessage("PHONE_EMPTY_OR_INCORRECT"));
//            }
            result = smsProvider.sendVerifyMessage(phone, randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + phone);
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.PHONE_BIND_CODE_PREFIX + phone;
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }

    /**
     * 更改登录密码验证码
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/update/password/code", method = RequestMethod.POST)
    public MessageResult updatePasswordCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
//        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        ValueOperations valueOperations = redisTemplate.opsForValue();

        //判断是绑定了手机还是邮箱
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        String email = member.getEmail();
        String mobile = member.getMobilePhone();
        if(!StringUtils.isEmpty(email)){
            //发送邮件验证码
            String key = SysConstant.PHONE_UPDATE_PASSWORD_PREFIX + email;
            Object code = valueOperations.get(key);
            if (code != null) {
                //判断如果请求间隔小于一分钟则请求失败
                if (!BigDecimalUtils.compare(DateUtil.diffMinute((Date) (valueOperations.get(key + "Time"))), BigDecimal.ONE)) {
                    return error(localeMessageSourceService.getMessage("FREQUENTLY_REQUEST"));
                }
            }
            sentEmailAddCode(valueOperations, email, randomCode,SysConstant.PHONE_UPDATE_PASSWORD_PREFIX);

        }else if(!StringUtils.isEmpty(mobile)) {

            String key = SysConstant.PHONE_UPDATE_PASSWORD_PREFIX + mobile;
            Object code = valueOperations.get(key);
            if (code != null) {
                //判断如果请求间隔小于一分钟则请求失败
                if (!BigDecimalUtils.compare(DateUtil.diffMinute((Date) (valueOperations.get(key + "Time"))), BigDecimal.ONE)) {
                    return error(localeMessageSourceService.getMessage("FREQUENTLY_REQUEST"));
                }
            }
            MessageResult result;

            if ("86".equals(member.getCountry().getAreaCode())) {
                result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
            } else {
                result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
            }
            if (result.getCode() == 0) {
                valueOperations.getOperations().delete(key);
                valueOperations.getOperations().delete(key + "Time");
                // 缓存验证码
                valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
                valueOperations.set(key + "Time", new Date(), 10, TimeUnit.MINUTES);
                return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
            } else {
                return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
            }
        }else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
        return success(localeMessageSourceService.getMessage("SENT_SUCCESS_TEN"));

    }

    @RequestMapping(value = "/add/address/code", method = RequestMethod.POST)
    public MessageResult addAddressCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        MessageResult result;
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        if ("86".equals(member.getCountry().getAreaCode())) {
            result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.PHONE_ADD_ADDRESS_PREFIX + member.getMobilePhone();
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }

    @RequestMapping(value = "/activity/code", method = RequestMethod.POST)
    public MessageResult attendActivityCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
//        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        MessageResult result;
        //判断是绑定了手机还是邮箱
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        String email = member.getEmail();
        String mobile = member.getMobilePhone();
        ValueOperations valueOperations = redisTemplate.opsForValue();
        if(!StringUtils.isEmpty(email)){
            //发送邮件验证码
            String key = SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + email;
            Object code = valueOperations.get(key);
            if (code != null) {
                //判断如果请求间隔小于一分钟则请求失败
                if (!BigDecimalUtils.compare(DateUtil.diffMinute((Date) (valueOperations.get(key + "Time"))), BigDecimal.ONE)) {
                    return error(localeMessageSourceService.getMessage("FREQUENTLY_REQUEST"));
                }
            }
            sentEmailAddCode(valueOperations, email, randomCode,SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX);

        }else if(!StringUtils.isEmpty(mobile)) {

            if ("86".equals(member.getCountry().getAreaCode())) {
                result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
            } else {
                result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
            }
            if (result.getCode() == 0) {
                String key = SysConstant.PHONE_ATTEND_ACTIVITY_PREFIX + member.getMobilePhone();
                valueOperations.getOperations().delete(key);
                // 缓存验证码
                valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
                return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
            } else {
                return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
            }
        }else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
        return success(localeMessageSourceService.getMessage("SENT_SUCCESS_TEN"));

    }

    @RequestMapping(value = "/withdraw/code", method = RequestMethod.POST)
    public MessageResult withdrawCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        //判断是绑定了手机还是邮箱
        String email = member.getEmail();
        String mobile = member.getMobilePhone();
        ValueOperations valueOperations = redisTemplate.opsForValue();
        if(!StringUtils.isEmpty(email)){
            //发送邮件验证码
            sentEmailAddCode(valueOperations, email, randomCode,SysConstant.PHONE_WITHDRAW_MONEY_CODE_PREFIX);
        }else if(!StringUtils.isEmpty(mobile)){
            //发送手机验证码
            MessageResult result;
            log.info("===提币验证码发送===mobile："+member.getMobilePhone());
            if ("86".equals(member.getCountry().getAreaCode())) {
                result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
            } else {
                result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
            }
            if (result.getCode() == 0) {
                String key = SysConstant.PHONE_WITHDRAW_MONEY_CODE_PREFIX + member.getMobilePhone();
                valueOperations.getOperations().delete(key);
                // 缓存验证码
                valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            } else {
                return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
            }
        }else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
        return success(localeMessageSourceService.getMessage("SENT_SUCCESS_TEN"));
    }

    @Async
    public void sentEmailAddCode(ValueOperations valueOperations, String email, String code,String key) throws MessagingException, IOException, TemplateException {
        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = null;
        helper = new MimeMessageHelper(mimeMessage, true);
        helper.setFrom(from);
        helper.setTo(email);
        helper.setSubject(company);
        Map<String, Object> model = new HashMap<>(16);
        model.put("code", code);
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_26);
        cfg.setClassForTemplateLoading(this.getClass(), "/templates");
        Template template = cfg.getTemplate("addAddressCodeEmail.ftl");
        String html = FreeMarkerTemplateUtils.processTemplateIntoString(template, model);
        helper.setText(html, true);
        //发送邮件
        javaMailSender.send(mimeMessage);
        valueOperations.set(key + email, code, 10, TimeUnit.MINUTES);
        valueOperations.set(key + email + "Time", new Date(), 10, TimeUnit.MINUTES);
    }

    @RequestMapping(value = "/ctc/code", method = RequestMethod.POST)
    public MessageResult ctcCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        MessageResult result;
        log.info("===C2C验证码发送===mobile："+member.getMobilePhone());
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        if ("86".equals(member.getCountry().getAreaCode())) {
            result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.PHONE_CTC_TRADE_CODE_PREFIX + member.getMobilePhone();
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SENT_SUCCESS_TEN"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_FAILED"));
        }
    }

    /**
     * 忘记密码验证码
     */
    @RequestMapping(value = "/reset/code", method = RequestMethod.POST)
    public MessageResult resetPasswordCode(String account) throws Exception {
        Member member = memberService.findByPhone(account);
        Assert.notNull(member, localeMessageSourceService.getMessage("MEMBER_NOT_EXISTS"));
        MessageResult result;
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        if ("86".equals(member.getCountry().getAreaCode())) {
            result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.RESET_PASSWORD_CODE_PREFIX + member.getMobilePhone();
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }

    /**
     * 更改手机验证码
     */
    @RequestMapping(value = "/change/code", method = RequestMethod.POST)
    public MessageResult resetPhoneCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        MessageResult result;
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        if ("86".equals(member.getCountry().getAreaCode())) {
            result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.PHONE_CHANGE_CODE_PREFIX + member.getMobilePhone();
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }

    /**
     * 绑定API发送验证码
     * @param user
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "api/code", method = RequestMethod.POST)
    public MessageResult bindApiSendCode(@SessionAttribute(SESSION_MEMBER) AuthMember user) throws Exception {
        Member member = memberService.findOne(user.getId());
        Assert.hasText(member.getMobilePhone(), localeMessageSourceService.getMessage("NOT_BIND_PHONE"));
        MessageResult result;
        log.info("===API密钥验证码发送===mobile："+member.getMobilePhone());
        String randomCode = String.valueOf(GeneratorUtil.getRandomNumber(100000, 999999));
        if ("86".equals(member.getCountry().getAreaCode())) {
            result = smsProvider.sendVerifyMessage(member.getMobilePhone(), randomCode);
        } else {
            result = smsProvider.sendInternationalMessage(randomCode, member.getCountry().getAreaCode() + member.getMobilePhone());
        }
        if (result.getCode() == 0) {
            ValueOperations valueOperations = redisTemplate.opsForValue();
            String key = SysConstant.API_BIND_CODE_PREFIX + member.getMobilePhone();
            valueOperations.getOperations().delete(key);
            // 缓存验证码
            valueOperations.set(key, randomCode, 10, TimeUnit.MINUTES);
            return success(localeMessageSourceService.getMessage("SEND_SMS_SUCCESS"));
        } else {
            return error(localeMessageSourceService.getMessage("SEND_SMS_FAILED"));
        }
    }
}
