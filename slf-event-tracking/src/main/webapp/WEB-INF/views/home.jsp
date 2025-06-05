<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-800">SLF Event Tracking</h1>
                <p class="text-gray-600 mt-2">ลงทะเบียนเพื่อเข้าร่วมกิจกรรมและสะสมคะแนน</p>
            </div>
            
            <div class="space-y-4">
                <a href="${pageContext.request.contextPath}/register" 
                   class="block w-full py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md text-center">
                    ลงทะเบียนใหม่
                </a>
                
                <a href="${pageContext.request.contextPath}/login" 
                   class="block w-full py-3 px-4 bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold rounded-md text-center">
                    เข้าสู่ระบบ (เคยลงทะเบียนแล้ว)
                </a>
            </div>
            
            <div class="mt-8 text-center text-sm text-gray-500">
                <p>สำหรับผู้ดูแลระบบ <a href="${pageContext.request.contextPath}/admin" class="text-blue-600 hover:underline">เข้าสู่ระบบผู้ดูแล</a></p>
            </div>
        </div>
    </div>
</body>
</html>