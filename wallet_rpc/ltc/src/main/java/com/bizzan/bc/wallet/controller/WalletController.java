package com.bizzan.bc.wallet.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;

import com.bizzan.bc.wallet.service.AccountService;
import com.bizzan.bc.wallet.util.HttpClientUtil;
import com.bizzan.bc.wallet.util.MessageResult;
import org.litecoinj.core.Address;
import org.litecoinj.core.ECKey;
import org.litecoinj.core.NetworkParameters;
import org.litecoinj.params.MainNetParams;
import org.litecoinj.wallet.UnreadableWalletException;
import org.litecoinj.wallet.Wallet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

@RestController
@RequestMapping("/rpc")
public class WalletController {
	
	@Value("${bizzan.wallet}")
	private String walletPath;
	
	@Value("${bizzan.blockApi}")
	private String blockApi;
	
	@Autowired
    private AccountService accountService;
	
	private Logger logger = LoggerFactory.getLogger(WalletController.class);
	
	@GetMapping("address/{account}")
    public MessageResult getNewAddress(@PathVariable String account){
        logger.info("create new address: "+account);
        
        NetworkParameters params  = MainNetParams.get(); 
        
        final File walletFile = new File(walletPath);
        
        Wallet wallet = null;
		try {
			wallet = Wallet.loadFromFile(walletFile);
		} catch (UnreadableWalletException e) {
			e.printStackTrace();
			return MessageResult.error(500,"error:" + e.getMessage());
		}
        
        ECKey key = new ECKey();
        
        Address address = key.toAddress(params);
        
        wallet.importKey(key);
        
        try {
			wallet.saveToFile(walletFile);
			accountService.saveOne(account, address.toBase58());
			MessageResult result = new MessageResult(0,"success");
	        result.setData(address.toBase58());
	        
	        return result;
		} catch (IOException e) {
			e.printStackTrace();
			return MessageResult.error(500,"error:" + e.getMessage());
		}
    }
	
	/**
	 * 钱包总余额（非节点服务，直接返回0，后面如果有空闲可以追加获取总体余额）
	 * @return
	 */
	@GetMapping("balance")
    public MessageResult balance(){
		MessageResult result = new MessageResult(0,"success");
        result.setData(0);
        return result;
    }
	
	/**
	 * 获取地址余额
	 * @param address
	 * @return
	 */
	@GetMapping("balance/{address}")
    public MessageResult balance(@PathVariable String address){
        try {
        	String retStr = HttpClientUtil.doHttpsGet(blockApi + "addr/" + address + "/balance", null, null);
        	if(!StringUtils.isEmpty(retStr)){
        		BigDecimal balance = new BigDecimal(retStr);
        		if(balance.compareTo(BigDecimal.ZERO) > 0) {
        			balance = balance.divide(BigDecimal.valueOf(100000000), 8, BigDecimal.ROUND_HALF_DOWN);
        		}
        		MessageResult result = new MessageResult(0,"success");
                result.setData(balance);
                return result;
        	}
        	return MessageResult.error(500,"获取余额失败");
        }
        catch (Exception e){
            e.printStackTrace();
            return MessageResult.error(500,"error:"+e.getMessage());
        }
    }
	
	@GetMapping("height")
    public MessageResult getHeight(){
        try {
        	String retStr = HttpClientUtil.doHttpsGet(blockApi + "status?q=getInfo", null, null);
        	if(!StringUtils.isEmpty(retStr)){
        		JSONObject json = JSON.parseObject(retStr);
        		JSONObject info = json.getJSONObject("info");
        		Long height = json.getJSONObject("info").getLong("blocks");
        		MessageResult result = new MessageResult(0,"success");
                result.setData(height);
                return result;
        	}
        	return MessageResult.error(500,"获取高度失败");
        }
        catch (Exception e){
            e.printStackTrace();
            return MessageResult.error(500,"查询失败,error:"+e.getMessage());
        }
    }
	
	/**
	 * TODO 增加转账功能
	 * @param address
	 * @param amount
	 * @param fee
	 * @return
	 */
	@GetMapping({"transfer","withdraw"})
    public MessageResult withdraw(String address, BigDecimal amount,BigDecimal fee){
		return MessageResult.error(500, "暂未实现该功能");
    }
}
