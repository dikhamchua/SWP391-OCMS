package com.ocms.controller.dashboard.admin;

import com.ocms.dal.LessonDAO;
import com.ocms.entity.Lesson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/change-lesson-order")
public class ChangeLessonOrderController extends HttpServlet {
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
            // Read JSON data from request
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }

            JSONObject json = new JSONObject(jsonBuffer.toString());
            int lessonId = json.getInt("lessonId");
            int sectionId = json.getInt("sectionId");
            String direction = json.getString("direction");

            // Get the lesson to move
            Lesson lessonToMove = lessonDAO.getById(lessonId);
            if (lessonToMove == null) {
                out.print("{\"message\": \"Không tìm thấy bài học\"}");
                return;
            }

            // Get all lessons in the section
            List<Lesson> lessonsInSection = lessonDAO.getBySectionId(sectionId);
            
            // Sort lessons by order number
            lessonsInSection.sort((a, b) -> a.getOrderNumber() - b.getOrderNumber());
            
            // Find the current index of the lesson to move
            int currentIndex = -1;
            for (int i = 0; i < lessonsInSection.size(); i++) {
                if (lessonsInSection.get(i).getId().equals(lessonId)) {
                    currentIndex = i;
                    break;
                }
            }
            
            if (currentIndex == -1) {
                out.print("{\"message\": \"Không tìm thấy bài học trong phần này\"}");
                return;
            }
            
            // Calculate target index based on direction
            int targetIndex;
            if ("up".equals(direction)) {
                targetIndex = currentIndex - 1;
                if (targetIndex < 0) {
                    out.print("{\"message\": \"Bài học đã ở vị trí đầu tiên\"}");
                    return;
                }
            } else if ("down".equals(direction)) {
                targetIndex = currentIndex + 1;
                if (targetIndex >= lessonsInSection.size()) {
                    out.print("{\"message\": \"Bài học đã ở vị trí cuối cùng\"}");
                    return;
                }
            } else {
                out.print("{\"message\": \"Hướng di chuyển không hợp lệ\"}");
                return;
            }
            
            // Swap order numbers
            Lesson targetLesson = lessonsInSection.get(targetIndex);
            int tempOrder = lessonToMove.getOrderNumber();
            lessonToMove.setOrderNumber(targetLesson.getOrderNumber());
            targetLesson.setOrderNumber(tempOrder);
            
            // Update both lessons
            lessonDAO.update(lessonToMove);
            lessonDAO.update(targetLesson);
            
            out.print("{\"message\": \"Thay đổi thứ tự bài học thành công\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"message\": \"Lỗi: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
} 