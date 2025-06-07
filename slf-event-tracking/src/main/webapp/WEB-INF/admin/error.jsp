<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>เกิดข้อผิดพลาด - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">เกิดข้อผิดพลาด</h1>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับหน้าหลัก</a>
            </div>
            
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded mb-6" role="alert">
                <p class="font-bold">ข้อผิดพลาด</p>
                <p>${errorMessage != null ? errorMessage : "เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง"}</p>
            </div>
            
            <div>
                <p class="text-gray-600 mb-4">แนวทางการแก้ไข:</p>
                <ul class="list-disc pl-5 text-gray-600">
                    <li>ตรวจสอบการตั้งค่าของรางวัล</li>
                    <li>ตรวจสอบว่ามีรางวัลประเภทสุ่มในระบบหรือไม่</li>
                    <li>ตรวจสอบว่ามีผู้เข้าร่วมที่มีสิทธิ์ลุ้นรางวัลหรือไม่</li>
                    <li>ติดต่อผู้ดูแลระบบ</li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>