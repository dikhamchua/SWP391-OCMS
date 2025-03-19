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
public class LessonQuiz {
    private Integer id;                // INT, Primary Key
    private Integer passPercentage;    // INT, Default '70'
    private Integer timeLimitMinutes;  // INT, Default NULL
    private Integer attemptsAllowed;   // INT, Default NULL
    private Integer lessonId;          // INT, Default NULL
} 