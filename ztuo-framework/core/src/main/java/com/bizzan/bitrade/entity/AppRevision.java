package com.bizzan.bitrade.entity;

import com.bizzan.bitrade.constant.Platform;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.util.Date;

/**
 * @author Hevin QQ:390330302 E-mail:xunibidev@gmail.com
 * @date 2020年04月24日
 */
@Entity
@Data
public class AppRevision {

    @GeneratedValue(strategy = GenerationType.AUTO)
    @Id
    private Long id;

    @CreationTimestamp
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date publishTime;

    private String remark;

    private String version;

    private String downloadUrl;

    @Enumerated(EnumType.ORDINAL)
    private Platform platform;

}
