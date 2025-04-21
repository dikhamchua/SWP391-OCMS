/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 *
 * @author ADMIN
 */

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Setting {
    private Integer id;       // ID của cài đặt
    private String type;      // Loại cài đặt (System, User, Payment, etc.)
    private String value;     // Giá trị cụ thể của cài đặt
    private Integer order;    // Thứ tự hiển thị
    private String status;    // Trạng thái: "Active" hoặc "Inactive"
    private String createdAt; // Thời gian tạo
    private String updatedAt; // Thời gian cập nhật
}
