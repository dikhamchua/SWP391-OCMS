package com.ocms.entity;

import lombok.*;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Blog {

    private Integer id; // INT, Primary Key, Auto Increment
    private String title; // VARCHAR(255), Not Null
    private String thumbnail; // TEXT
    private String briefInfo; // TEXT, Not Null
    private String content; // LONGTEXT, Not Null
    private Integer categoryId; // INT
    private Integer author; // VARCHAR(100), Not Null
    private LocalDateTime updatedDate; // DATETIME, Default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    private LocalDateTime createdDate; // DATETIME, Default CURRENT_TIMESTAMP
    private String status; // ENUM('Active', 'Inactive'), Default 'Active'
}