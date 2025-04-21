package com.ocms.entity;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class QuizQuestion {
    private Integer id;             // INT, Primary Key
    private Integer quizId;         // INT, Not Null
    private String questionText;    // TEXT, Not Null
    private Integer points;         // INT, Default '1'
    private Integer orderNumber;    // INT, Default '1'
    private String status;          // ENUM('active', 'inactive'), Default 'active'
    private Date createdDate;       // DATETIME, Default CURRENT_TIMESTAMP
    private Date modifiedDate;      // DATETIME, Default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
} 