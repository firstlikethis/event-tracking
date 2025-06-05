<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ผลการแลกรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex items-center justify-center p-4">
        <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
            <% 
                Boolean success = (Boolean) request.getAttribute("success");
                if (success != null && success) {
                    Reward reward = (Reward) request.getAttribute("reward");
                    Boolean isLuckyDraw = (Boolean) request.getAttribute("isLuckyDraw");
            %>
                <div class="text-center mb-6">
                    <div class="bg-green-100 p-4 rounded-full inline-block">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-800 mt-4">
                        <%= isLuckyDraw ? "ลงทะเบียนลุ้นรางวัลสำเร็จ!" : "แลกรางวัลสำเร็จ!" %>
                    </h1>
                </div>
                
                <div class="mb-6 p-4 bg-gray-50 rounded-md">
                    <h2 class="font-semibold text-lg mb-2">รายละเอียด:</h2>
                    <p class="mb-2"><span class="font-medium">รางวัล:</span> <%= reward.getRewardName() %></p>
                    <p class="mb-2"><span class="font-medium">รายละเอียด:</span> <%= reward.getRewardDescription() %></p>
                    <p class="text-red-600 font-bold">ใช้ <%= reward.getPointsRequired() %> คะแนน</p>
                    
                    <% if (isLuckyDraw) { %>
                        <div class="mt-4 p-3 bg-yellow-50 text-yellow-800 rounded-md">
                            <p>คุณได้ลงทะเบียนเพื่อลุ้นรางวัลนี้แล้ว กรุณารอติดตามผลการสุ่มรางวัล</p>
                        </div>
                    <% } else { %>
                        <div class="mt-4 p-3 bg-blue-50 text-blue-800 rounded-md">
                            <p>คุณสามารถรับรางวัลได้ที่จุดแลกรางวัล กรุณาแสดงหน้านี้กับเจ้าหน้าที่</p>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="text-center mb-6">
                    <div class="bg-red-100 p-4 rounded-full inline-block">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-800 mt-4">แลกรางวัลไม่สำเร็จ</h1>
                </div>
                
                <div class="mb-6 p-4 bg-red-50 text-red-800 rounded-md">
                    <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง" %></p>
                </div>
            <% } %>
            
            <div class="flex space-x-4">
                <a href="${pageContext.request.contextPath}/rewards" class="flex-1 py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md text-center">
                    ดูรางวัลอื่น
                </a>
                <a href="${pageContext.request.contextPath}/dashboard" class="flex-1 py-3 px-4 bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold rounded-md text-center">
                    กลับหน้าหลัก
                </a>
            </div>
        </div>
    </div>
</body>
</html>