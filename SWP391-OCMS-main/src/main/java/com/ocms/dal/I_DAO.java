/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.dal;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author ADMIN
 * @param <T>
 */
public interface I_DAO<T> {
    
    public List<T> findAll();
    
    public boolean update(T t);
    
    public boolean delete(T t);
    
    public int insert(T t);
    
    public T getFromResultSet(ResultSet resultSet) throws SQLException;
}
