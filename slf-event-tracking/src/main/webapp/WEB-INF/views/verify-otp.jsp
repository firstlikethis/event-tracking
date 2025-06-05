<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ยืนยัน OTP - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-2xl font-bold text-gray-800">ยืนยันรหัส OTP</h1>
                <p class="text-gray-600 mt-2">กรุณากรอกรหัส OTP ที่ได้รับทาง SMS</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="space-y-4">
                <div>
                    <label for="otpCode" class="block text-sm font-medium text-gray-700">รหัส OTP</label>
                    <input type="text" id="otpCode" name="otpCode" required
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div class="pt-4">
                    <button type="submit" 
                            class="w-full py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                        ยืนยัน OTP
                    </button>
                </div>
            </form>
            
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">ไม่ได้รับรหัส? <a href="#" onclick="window.location.reload();" class="text-blue-600 hover:underline">ส่งรหัสใหม่</a></p>
            </div>
        </div>
    </div>
</body>
</html>