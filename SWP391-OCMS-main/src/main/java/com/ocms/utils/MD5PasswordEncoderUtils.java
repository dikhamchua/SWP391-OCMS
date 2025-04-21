package com.ocms.utils;


import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Scanner;

public class MD5PasswordEncoderUtils {

    public static String encodeMD5(String password) {
        try {
            // Lấy một instance của MessageDigest với thuật toán MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Thêm mật khẩu vào để tính toán
            md.update(password.getBytes());

            // Lấy giá trị băm
            byte[] digest = md.digest();

            // Chuyển đổi byte array thành chuỗi hex
            BigInteger bigInt = new BigInteger(1, digest);
            String hashtext = bigInt.toString(16);

            // Đảm bảo chuỗi hex có đủ 32 ký tự
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }

            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not found", e);
        }
    }

    public static void main(String[] args) {
        String password = new Scanner(System.in).nextLine();
        String encodedPassword = encodeMD5(password);
        System.out.println("Original password: " + password);
        System.out.println("Encoded password: " + encodedPassword);
    }
}
