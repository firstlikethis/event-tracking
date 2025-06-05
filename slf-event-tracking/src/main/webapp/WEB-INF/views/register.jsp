<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ลงทะเบียน - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-800">ลงทะเบียนเข้าร่วมงาน</h1>
                <p class="text-gray-600 mt-2">กรอกข้อมูลเพื่อลงทะเบียนเข้าร่วมกิจกรรม</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-4">
                <div>
                    <label for="fullname" class="block text-sm font-medium text-gray-700">ชื่อ-นามสกุล</label>
                    <input type="text" id="fullname" name="fullname" required
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700">เบอร์โทรศัพท์</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" required
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700">อีเมล (ไม่บังคับ)</label>
                    <input type="email" id="email" name="email"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="visitorType" class="block text-sm font-medium text-gray-700">ประเภทผู้เข้าร่วม</label>
                    <select id="visitorType" name="visitorType" required
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="">-- เลือกประเภท --</option>
                        <option value="1">นักเรียน/นักศึกษา (ทั่วไป)</option>
                        <option value="2">นักเรียน/นักศึกษา (ผู้กู้ยืม กยศ.)</option>
                        <option value="3">บุคคลทั่วไป</option>
                        <option value="4">อาจารย์/บุคลากรทางการศึกษา</option>
                        <option value="5">องค์กรนายจ้าง</option>
                        <option value="6">ผู้บริหาร</option>
                    </select>
                </div>
                
                <div class="pt-4">
                    <button type="submit" 
                            class="w-full py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                        ลงทะเบียน
                    </button>
                </div>
            </form>
            
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">เคยลงทะเบียนแล้ว? <a href="${pageContext.request.contextPath}/login" class="text-blue-600 hover:underline">เข้าสู่ระบบ</a></p>
            </div>
        </div>
    </div>
</body>
</html>