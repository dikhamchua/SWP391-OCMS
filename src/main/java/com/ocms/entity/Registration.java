package com.ocms.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor


public class Registration {
    private int id;
    private String email;
    private int accountId;
    private Timestamp registrationTime;
    private int courseId;
    private String packages;
    private BigDecimal totalCost;
    private String status;
    private Timestamp validFrom;
    private Timestamp validTo;
    private int lastUpdateByPerson;
}
