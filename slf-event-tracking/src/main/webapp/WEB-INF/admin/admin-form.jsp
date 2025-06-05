<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Admin" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ฟอร์มผู้ดูแล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        Admin admin = (Admin) request.getAttribute("admin");
        boolean isEdit = admin != null && admin.getAdminId() != null;
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800"><%= isEdit ? "แก้ไขผู้ดูแล" : "เพิ่มผู้ดูแลใหม่" %></h1>
                <a href="${pageContext.request.contextPath}/admin/users" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับ</a>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/admin/save-admin" method="post" class="space-y-4">
                <% if (isEdit) { %>
                    <input type="hidden" name="adminId" value="<%= admin.getAdminId() %>">
                <% } %>
                
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700">ชื่อผู้ใช้ *</label>
                    <input type="text" id="username" name="username" required
                           value="<%= isEdit ? admin.getUsername() : "" %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700"><%= isEdit ? "รหัสผ่าน (เว้นว่างถ้าไม่ต้องการเปลี่ยน)" : "รหัสผ่าน *" %></label>
                    <input type="password" id="password" name="password" <%= isEdit ? "" : "required" %>
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="fullname" class="block text-sm font-medium text-gray-700">ชื่อ-นามสกุล *</label>
                    <input type="text" id="fullname" name="fullname" required
                           value="<%= isEdit ? admin.getFullname() : "" %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="role" class="block text-sm font-medium text-gray-700">บทบาท *</label>
                    <select id="role" name="role" required
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="">-- เลือกบทบาท --</option>
                        <option value="ADMIN" <%= isEdit && "ADMIN".equals(admin.getRole()) ? "selected" : "" %>>ผู้ดูแลระบบ</option>
                        <option value="STAFF" <%= isEdit && "STAFF".equals(admin.getRole()) ? "selected" : "" %>>เจ้าหน้าที่</option>
                    </select>
                </div>
                
                <div class="flex items-center">
                    <input type="checkbox" id="isActive" name="isActive"
                           <%= isEdit && "1".equals(admin.getIsActive()) ? "checked" : "" %>
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="isActive" class="ml-2 block text-sm text-gray-700">
                        ใช้งาน
                    </label>
                </div>
                
                <div class="pt-4">
                    <button type="submit" 
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                        <%= isEdit ? "บันทึกการแก้ไข" : "สร้างผู้ดูแล" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>