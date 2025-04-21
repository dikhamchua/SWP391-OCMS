package com.ocms.entity;

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
public class QuizAnswer {
    private Integer id;
    private Integer questionId;
    private String answerText;
    private Boolean isCorrect;
    private Integer orderNumber;
} 