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
public class LessonVideo {
    private Integer lessonId;        // INT, Primary Key
    private String videoUrl;         // TEXT
    private String videoProvider;    // ENUM('youtube', 'vimeo', etc.)
    private Integer videoDuration;   // INT
} 