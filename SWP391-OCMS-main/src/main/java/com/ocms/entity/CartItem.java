package com.ocms.entity;

import java.math.BigDecimal;
import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Entity class for cart_item table
 */
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CartItem {
    private Integer id;
    private Integer cartId;
    private Integer courseId;
    private BigDecimal price;
    private Date addedDate;
} 