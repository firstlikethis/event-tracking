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
    <style>
        @keyframes confetti-fall {
            0% { transform: translateY(-100vh) rotate(0deg); }
            100% { transform: translateY(100vh) rotate(720deg); }
        }
        .confetti {
            width: 10px;
            height: 10px;
            position: absolute;
            animation: confetti-fall linear forwards;
        }
    </style>
</head>
<body class="bg-gray-100 font-sans">
    <div id="confetti-container" class="fixed top-0 left-0 w-full h-full pointer-events-none"></div>
    
    <%
        Reward reward = (Reward) request.getAttribute("reward");
        Visitor winner = (Visitor) request.getAttribute("winner");
        Boolean success = (Boolean) request.getAttribute("success");
        Boolean noEligibleParticipants = (Boolean) request.getAttribute("noEligibleParticipants");
        Boolean noMoreRewards = (Boolean) request.getAttribute("noMoreRewards");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ผลการสุ่มรางวัล</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/lucky-draw" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 mr-2">สุ่มอีกครั้ง</a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับหน้าหลัก</a>
                </div>
            </div>
            
            <div class="text-center mb-8">
                <h2 class="text-xl font-bold text-gray-800 mb-4">รางวัล: <%= reward.getRewardName() %></h2>
                <p class="text-gray-600 mb-4"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
            </div>
            
            <% if (noMoreRewards != null && noMoreRewards) { %>
                <div class="bg-yellow-50 p-6 rounded-lg shadow text-center mb-8">
                    <div class="text-yellow-600 text-6xl mb-4">⚠️</div>
                    <h3 class="text-xl font-bold text-yellow-800 mb-2">รางวัลหมดแล้ว</h3>
                    <p class="text-yellow-700">ไม่สามารถสุ่มรางวัลได้เนื่องจากรางวัลหมดแล้ว</p>
                </div>
            <% } else if (noEligibleParticipants != null && noEligibleParticipants) { %>
                <div class="bg-yellow-50 p-6 rounded-lg shadow text-center mb-8">
                    <div class="text-yellow-600 text-6xl mb-4">⚠️</div>
                    <h3 class="text-xl font-bold text-yellow-800 mb-2">ไม่มีผู้มีสิทธิ์ลุ้นรางวัล</h3>
                    <p class="text-yellow-700">ไม่มีผู้เข้าร่วมงานที่มีคะแนนเพียงพอหรือเข้าเงื่อนไขในการลุ้นรางวัลนี้</p>
                </div>
            <% } else if (winner != null && success != null && success) { %>
                <div class="bg-green-50 p-8 rounded-lg shadow text-center mb-8">
                    <div class="text-green-600 text-6xl mb-4">🎉</div>
                    <h3 class="text-2xl font-bold text-green-800 mb-4">ผู้โชคดีได้แก่</h3>
                    <p class="text-3xl font-bold text-green-700 mb-6" id="winner-name"><%= winner.getFullname() %></p>
                    <p class="text-green-600" id="winner-phone">เบอร์โทรศัพท์: <%= winner.getPhoneNumber() %></p>
                    
                    <div class="mt-8 p-4 bg-yellow-50 rounded-md inline-block">
                        <p class="text-yellow-800">กรุณาแจ้งให้ผู้โชคดีติดต่อรับรางวัลที่จุดแลกรางวัล</p>
                    </div>
                </div>
                
                <div class="text-center">
                    <p class="text-gray-500 mb-4">รางวัลคงเหลือ: <%= reward.getRemaining() - 1 %> รางวัล</p>
                    
                    <a href="${pageContext.request.contextPath}/lucky-draw?rewardId=<%= reward.getRewardId() %>" 
                       class="px-6 py-3 bg-purple-600 text-white font-bold rounded-md hover:bg-purple-700 text-lg inline-block">
                        กลับไปหน้าสุ่มรางวัล
                    </a>
                </div>
            <% } else { %>
                <div class="bg-red-50 p-6 rounded-lg shadow text-center mb-8">
                    <div class="text-red-600 text-6xl mb-4">❌</div>
                    <h3 class="text-xl font-bold text-red-800 mb-2">เกิดข้อผิดพลาด</h3>
                    <p class="text-red-700">ไม่สามารถสุ่มรางวัลได้ กรุณาลองใหม่อีกครั้ง</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <% if (winner != null && success != null && success) { %>
        <script>
            // สร้างเอฟเฟค confetti
            function createConfetti() {
                const confettiContainer = document.getElementById('confetti-container');
                const colors = ['#FFD700', '#FF6347', '#00FF7F', '#FF1493', '#4169E1', '#FFFF00'];
                
                for (let i = 0; i < 150; i++) {
                    const confetti = document.createElement('div');
                    confetti.classList.add('confetti');
                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    confetti.style.left = `${Math.random() * 100}%`;
                    confetti.style.animationDuration = `${Math.random() * 3 + 2}s`;
                    confettiContainer.appendChild(confetti);
                }
            }
            
            // เรียกใช้งาน
            createConfetti();
            
            // Auto redirect after 30 seconds
            setTimeout(function() {
                window.location.href = "${pageContext.request.contextPath}/lucky-draw?rewardId=<%= reward.getRewardId() %>";
            }, 30000);
        </script>
    <% } %>
</body>
</html>