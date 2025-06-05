<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Booth" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ฟอร์มบูธ - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        Booth booth = (Booth) request.getAttribute("booth");
        boolean isEdit = booth != null && booth.getBoothId() != null;
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800"><%= isEdit ? "แก้ไขบูธ" : "เพิ่มบูธใหม่" %></h1>
                <a href="${pageContext.request.contextPath}/admin/booths" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับ</a>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/admin/save-booth" method="post" class="space-y-4">
                <% if (isEdit) { %>
                    <input type="hidden" name="boothId" value="<%= booth.getBoothId() %>">
                <% } %>
                
                <div>
                    <label for="boothName" class="block text-sm font-medium text-gray-700">ชื่อบูธ *</label>
                    <input type="text" id="boothName" name="boothName" required
                           value="<%= isEdit ? booth.getBoothName() : "" %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="boothDescription" class="block text-sm font-medium text-gray-700">รายละเอียด</label>
                    <textarea id="boothDescription" name="boothDescription" rows="3"
                              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"><%= isEdit && booth.getBoothDescription() != null ? booth.getBoothDescription() : "" %></textarea>
                </div>
                
                <div>
                    <label for="points" class="block text-sm font-medium text-gray-700">คะแนนที่ได้รับ *</label>
                    <input type="number" id="points" name="points" required min="1"
                           value="<%= isEdit ? booth.getPoints() : 1 %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div class="flex items-center">
                    <input type="checkbox" id="isActive" name="isActive"
                           <%= isEdit && "1".equals(booth.getIsActive()) ? "checked" : "" %>
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="isActive" class="ml-2 block text-sm text-gray-700">
                        ใช้งาน
                    </label>
                </div>
                
                <div class="pt-4">
                    <button type="submit" 
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                        <%= isEdit ? "บันทึกการแก้ไข" : "สร้างบูธ" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>