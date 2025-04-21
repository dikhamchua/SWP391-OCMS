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
public class Lesson {
    private Integer id;
    private Integer sectionId;
    private String title;
    private String description;
    private String type; // Enum values: 'video', 'document', 'quiz', 'file', 'text'
    private Integer orderNumber;
    private Integer durationMinutes;
    private String status; // Enum values: 'active', 'inactive'
    private Date createdDate;
    private Date modifiedDate;
} 