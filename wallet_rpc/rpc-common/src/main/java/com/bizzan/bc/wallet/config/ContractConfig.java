package com.bizzan.bc.wallet.config;

import com.bizzan.bc.wallet.entity.Contract;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 自动配置合约参数
 */
@Configuration
@ConditionalOnProperty(name="contract.address")
public class ContractConfig {

    @Bean
    @ConfigurationProperties(prefix = "contract")
    public Contract getContract(){
        return new Contract();
    }

}
