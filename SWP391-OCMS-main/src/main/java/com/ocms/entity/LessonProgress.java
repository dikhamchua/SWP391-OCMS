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
public class LessonProgress {
    private Integer id;
    private Integer accountId;
    private Integer lessonId;
    private String status;  // Enum values: 'Not Started', 'In Progress', 'Completed'
    private Integer progressPercent;
    
    // Enum for status values
    public static final class Status {
        public static final String NOT_STARTED = "Not Started";
        public static final String IN_PROGRESS = "In Progress";
        public static final String COMPLETED = "Completed";
    }
} 