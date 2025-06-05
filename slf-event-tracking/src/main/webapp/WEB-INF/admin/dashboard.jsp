<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Admin" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>หน้าควบคุม - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        Admin admin = (Admin) session.getAttribute("admin");
        Integer boothCount = (Integer) request.getAttribute("boothCount");
        Integer rewardCount = (Integer) request.getAttribute("rewardCount");
        Integer pendingClaimCount = (Integer) request.getAttribute("pendingClaimCount");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">หน้าควบคุม</h1>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <!-- สถิติบูธ -->
                <div class="bg-blue-50 p-6 rounded-lg shadow">
                    <h2 class="text-lg font-semibold text-blue-800 mb-2">บูธทั้งหมด</h2>
                    <p class="text-3xl font-bold text-blue-600"><%= boothCount %></p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin/booths" class="text-blue-600 hover:underline">จัดการบูธ</a>
                    </div>
                </div>
                
                <!-- สถิติรางวัล -->
                <div class="bg-green-50 p-6 rounded-lg shadow">
                    <h2 class="text-lg font-semibold text-green-800 mb-2">รางวัลทั้งหมด</h2>
                    <p class="text-3xl font-bold text-green-600"><%= rewardCount %></p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin/rewards" class="text-green-600 hover:underline">จัดการรางวัล</a>
                    </div>
                </div>
                
                <!-- สถิติการรับรางวัล -->
                <div class="bg-yellow-50 p-6 rounded-lg shadow">
                    <h2 class="text-lg font-semibold text-yellow-800 mb-2">รางวัลที่รอรับ</h2>
                    <p class="text-3xl font-bold text-yellow-600"><%= pendingClaimCount %></p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin/claims" class="text-yellow-600 hover:underline">จัดการการรับรางวัล</a>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- ระบบสุ่มรางวัล -->
                <div class="bg-purple-50 p-6 rounded-lg shadow">
                    <h2 class="text-lg font-semibold text-purple-800 mb-4">ระบบสุ่มรางวัล</h2>
                    <p class="text-gray-600 mb-4">ใช้สำหรับสุ่มรางวัลให้กับผู้เข้าร่วมกิจกรรม</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/lucky-draw" 
                           class="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 inline-block">
                            ไปยังหน้าสุ่มรางวัล
                        </a>
                    </div>
                </div>
                
                <!-- จัดการผู้ดูแล -->
                <div class="bg-gray-50 p-6 rounded-lg shadow">
                    <h2 class="text-lg font-semibold text-gray-800 mb-4">จัดการผู้ดูแลระบบ</h2>
                    <p class="text-gray-600 mb-4">เพิ่ม แก้ไข หรือลบบัญชีผู้ดูแลระบบ</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/users" 
                           class="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 inline-block">
                            จัดการผู้ดูแล
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>