package com.ocms.entity;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class Slider {
    
    private Integer id;
    private String title;
    private String imageUrl;
    private String backlink;
    private String status;
    private String notes;
    private Integer createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
