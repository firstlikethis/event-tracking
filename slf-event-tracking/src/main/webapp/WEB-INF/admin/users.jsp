<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Admin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>จัดการผู้ดูแลระบบ - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        List<Admin> admins = (List<Admin>) request.getAttribute("admins");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">จัดการผู้ดูแลระบบ</h1>
                <a href="${pageContext.request.contextPath}/admin/admin-form" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">เพิ่มผู้ดูแลใหม่</a>
            </div>
            
            <% if (admins == null || admins.isEmpty()) { %>
                <p class="text-gray-500 text-center py-4">ยังไม่มีผู้ดูแลในระบบ</p>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="py-3 px-4 border-b text-left">ชื่อผู้ใช้</th>
                                <th class="py-3 px-4 border-b text-left">ชื่อ-นามสกุล</th>
                                <th class="py-3 px-4 border-b text-center">บทบาท</th>
                                <th class="py-3 px-4 border-b text-center">สถานะ</th>
                                <th class="py-3 px-4 border-b text-center">เข้าสู่ระบบล่าสุด</th>
                                <th class="py-3 px-4 border-b text-center">การจัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Admin admin : admins) { %>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-2 px-4 border-b"><%= admin.getUsername() %></td>
                                    <td class="py-2 px-4 border-b"><%= admin.getFullname() %></td>
                                    <td class="py-2 px-4 border-b text-center"><%= admin.getRole() %></td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <% if ("1".equals(admin.getIsActive())) { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">ใช้งาน</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs">ไม่ใช้งาน</span>
                                        <% } %>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <%= admin.getLastLoginDate() != null ? dateFormat.format(admin.getLastLoginDate()) : "-" %>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <div class="flex justify-center space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/admin-form?id=<%= admin.getAdminId() %>" 
                                               class="px-3 py-1 bg-blue-100 text-blue-800 rounded hover:bg-blue-200">
                                                แก้ไข
                                            </a>
                                            <a href="#" onclick="confirmDelete(<%= admin.getAdminId() %>, '<%= admin.getUsername() %>')" 
                                               class="px-3 py-1 bg-red-100 text-red-800 rounded hover:bg-red-200">
                                                ลบ
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function confirmDelete(id, username) {
            if (confirm("คุณต้องการลบผู้ดูแล '" + username + "' ใช่หรือไม่?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/delete-admin?id=" + id;
            }
        }
    </script>
</body>
</html>