package com.ocms.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import java.sql.Date;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Question {
    private Integer id;
    private Integer quizId;
    private String questionText;
    private Integer points;
    private Integer orderNumber;
    private String status;
    private Date createdDate;
    private Date modifiedDate;
} 