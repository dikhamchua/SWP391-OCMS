package com.ocms.entity;

import java.sql.Timestamp;
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
public class QuizAttempt {
    private Integer id;
    private Integer accountId;
    private Integer quizId;
    private Double score;
    private Boolean passed;
    private Timestamp startTime;
    private Timestamp endTime;
    private Integer lessonId;
} 