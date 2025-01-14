/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.config;

/**
 *
 * @author manhpthe172481
 */
public class GlobalConfig {
    /**
     * SESSION_ACCOUNT: Đối tượng tài khoản được lưu trong phiên làm việc (session)
     */
    public static final String SESSION_ACCOUNT = "account";

    /**
     * USERNAME_EMAIL: Địa chỉ email được sử dụng để gửi email từ ứng dụng
     */
    public static final String USERNAME_EMAIL = "isp1804cardweb3@gmail.com";

    /**
     * PASSWORD_APP_EMAIL: Mật khẩu của địa chỉ email được sử dụng để gửi email từ
     * ứng dụng
     */
    public static final String PASSWORD_APP_EMAIL = "pchn xlef opnr bhca";

    /**
     * GOOGLE_CLIENT_ID: ID của ứng dụng khách (client) được cấp bởi Google để xác
     * thực
     */
    public static String GOOGLE_CLIENT_ID = "257748132214-9811944a5anccchj9egqhg9qci33l5ij.apps.googleusercontent.com";

    /**
     * GOOGLE_CLIENT_SECRET: Khóa bí mật của ứng dụng khách được cấp bởi Google để
     * xác thực
     */
    public static String GOOGLE_CLIENT_SECRET = "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";

    /**
     * GOOGLE_REDIRECT_URI: URI được sử dụng để đổi mã xác thực (authorization code)
     * lấy từ Google thành mã truy cập (access token)
     */
    public static String GOOGLE_REDIRECT_URI = "http://localhost:9998/SWP_OCMS/LoginGoogleHandler";

    /**
     * GOOGLE_LINK_GET_TOKEN: Liên kết để trao đổi mã xác thực từ Google để lấy mã
     * truy cập
     */
    public static String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    /**
     * GOOGLE_LINK_GET_USER_INFO: Liên kết để lấy thông tin người dùng từ Google
     * bằng cách sử dụng mã truy cập
     */
    public static String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    /**
     * GOOGLE_GRANT_TYPE: Loại cấp phép được sử dụng trong quy trình xác thực Google
     * (authorization code)
     */
    public static String GOOGLE_GRANT_TYPE = "authorization_code";


    public static final Integer ROLE_STUDENT = 3;

    public static final Integer ROLE_ADMIN = 1;

    public static final Integer ROLE_TEACHER = 2;

}
