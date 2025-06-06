<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="th.or.studentloan.event.model.Visitor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ผลการสุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        Reward reward = (Reward) request.getAttribute("reward");
        Visitor winner = (Visitor) request.getAttribute("winner");
        Boolean success = (Boolean) request.getAttribute("success");
        Boolean noMoreRewards = (Boolean) request.getAttribute("noMoreRewards");
        Boolean noEligibleParticipants = (Boolean) request.getAttribute("noEligibleParticipants");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ผลการสุ่มรางวัล</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/lucky-draw" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับไปหน้าสุ่มรางวัล</a>
                </div>
            </div>
            
            <% if (reward != null) { %>
                <div class="mb-6 p-4 bg-purple-50 rounded-lg border border-purple-200">
                    <h2 class="text-xl font-semibold text-purple-800 mb-2">รางวัล: <%= reward.getRewardName() %></h2>
                    <p class="text-purple-700 mb-2">รายละเอียด: <%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "-" %></p>
                    <p class="text-purple-700">คะแนนที่ต้องใช้: <%= reward.getPointsRequired() %> คะแนน</p>
                </div>
                
                <% if (noMoreRewards != null && noMoreRewards) { %>
                    <div class="p-8 bg-yellow-50 text-center rounded-lg mb-6">
                        <div class="inline-block p-4 bg-yellow-100 rounded-full mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-yellow-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-yellow-800 mb-2">ไม่สามารถสุ่มรางวัลได้</h3>
                        <p class="text-yellow-700 mb-4">รางวัลนี้หมดแล้ว ไม่สามารถสุ่มเพิ่มได้</p>
                    </div>
                <% } else if (noEligibleParticipants != null && noEligibleParticipants) { %>
                    <div class="p-8 bg-yellow-50 text-center rounded-lg mb-6">
                        <div class="inline-block p-4 bg-yellow-100 rounded-full mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-yellow-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-yellow-800 mb-2">ไม่มีผู้มีสิทธิ์ลุ้นรางวัล</h3>
                        <p class="text-yellow-700 mb-4">ไม่พบผู้ที่มีคะแนนเพียงพอหรือมีสิทธิ์ในการลุ้นรางวัลนี้</p>
                    </div>
                <% } else if (success != null && success && winner != null) { %>
                    <div class="text-center mb-8">
                        <div class="inline-block p-4 bg-green-100 rounded-full mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                            </svg>
                        </div>
                        <h3 class="text-2xl font-bold text-green-800 mb-4">ผู้โชคดีได้แก่</h3>
                        <div class="max-w-md mx-auto bg-white p-6 rounded-lg border-2 border-green-500 shadow-lg">
                            <p class="text-3xl font-bold text-green-700 mb-2"><%= winner.getFullname() %></p>
                            <p class="text-gray-600">เบอร์โทรศัพท์: <%= winner.getPhoneNumber() %></p>
                        </div>
                    </div>
                    
                    <div class="flex justify-center space-x-4">
                        <a href="${pageContext.request.contextPath}/lucky-draw" 
                           class="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                            กลับไปหน้าสุ่มรางวัล
                        </a>
                    </div>
                <% } else { %>
                    <div class="p-8 bg-red-50 text-center rounded-lg mb-6">
                        <div class="inline-block p-4 bg-red-100 rounded-full mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-red-800 mb-2">เกิดข้อผิดพลาด</h3>
                        <p class="text-red-700 mb-4">ไม่สามารถสุ่มรางวัลได้ในขณะนี้ กรุณาลองใหม่อีกครั้ง</p>
                    </div>
                <% } %>
            <% } else { %>
                <div class="p-8 bg-red-50 text-center rounded-lg mb-6">
                    <div class="inline-block p-4 bg-red-100 rounded-full mb-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold text-red-800 mb-2">ไม่พบรางวัล</h3>
                    <p class="text-red-700 mb-4">ไม่พบข้อมูลรางวัลที่ต้องการสุ่ม กรุณาลองใหม่อีกครั้ง</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>