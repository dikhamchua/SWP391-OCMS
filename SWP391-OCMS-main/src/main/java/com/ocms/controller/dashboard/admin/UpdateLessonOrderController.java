package com.ocms.controller.dashboard.admin;

import com.ocms.dal.LessonDAO;
import com.ocms.entity.Lesson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/update-lesson-order")
public class UpdateLessonOrderController extends HttpServlet {
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Đọc dữ liệu JSON gửi từ client
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }

            JSONObject json = new JSONObject(jsonBuffer.toString());
            int sectionId = json.getInt("sectionId");
            JSONArray lessonOrder = json.getJSONArray("lessonOrder");

            // Cập nhật orderNumber cho từng lesson
            for (int i = 0; i < lessonOrder.length(); i++) {
                int lessonId = lessonOrder.getInt(i);
                Lesson lesson = lessonDAO.getById(lessonId);

                if (lesson != null) {
                    lesson.setOrderNumber(i + 1);
                    lessonDAO.update(lesson);
                }
            }

            out.print("{\"message\": \"Cập nhật thứ tự thành công!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"message\": \"Lỗi cập nhật: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
