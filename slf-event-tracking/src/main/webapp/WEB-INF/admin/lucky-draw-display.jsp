<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="th.or.studentloan.event.model.RewardClaim" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>แสดงผลการสุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes flicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .flicker-animation {
            animation: flicker 0.3s infinite;
        }
        .winner-announcement {
            animation: zoomInOut 2s ease-in-out;
        }
        @keyframes zoomInOut {
            0% { transform: scale(0.5); opacity: 0; }
            50% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
        .confetti {
            width: 10px;
            height: 10px;
            position: absolute;
            animation: confetti-fall linear forwards;
        }
        @keyframes confetti-fall {
            0% { transform: translateY(-100vh) rotate(0deg); }
            100% { transform: translateY(100vh) rotate(720deg); }
        }
        body {
            overflow: hidden;
            background-color: #0f172a;
            color: white;
        }
        .winner-list {
            max-height: 150px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div id="confetti-container" class="fixed top-0 left-0 w-full h-full pointer-events-none"></div>
    
    <div class="container mx-auto px-4 py-8 h-screen flex flex-col">
        <% 
            Reward reward = (Reward) request.getAttribute("reward");
            List<RewardClaim> winners = (List<RewardClaim>) request.getAttribute("winners");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>
        
        <div class="text-center mb-8">
            <h1 class="text-5xl font-bold text-yellow-400 mb-4">การสุ่มรางวัล</h1>
            <h2 class="text-3xl font-bold text-white mb-6">
                <%= reward.getRewardName() %>
            </h2>
            <p class="text-xl text-gray-300 mb-4"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
            <div class="inline-block bg-yellow-600 text-white px-6 py-3 rounded-full text-xl">
                คะแนนที่ใช้: <%= reward.getPointsRequired() %> คะแนน
            </div>
        </div>
        
        <div id="draw-container" class="flex-grow flex flex-col items-center justify-center">
            <div id="random-display" class="text-6xl font-bold text-center mb-8 flicker-animation">
                กำลังสุ่มรางวัล...
            </div>
            
            <div id="winner-display" class="hidden">
                <div class="bg-gradient-to-r from-yellow-600 to-yellow-400 p-12 rounded-lg shadow-2xl text-center winner-announcement">
                    <h3 class="text-3xl font-bold text-white mb-6">ผู้โชคดีได้แก่</h3>
                    <p id="winner-name" class="text-5xl font-bold text-white mb-8"></p>
                    <p id="winner-phone" class="text-2xl text-white"></p>
                </div>
            </div>
            
            <div class="mt-16">
                <button id="start-draw" class="px-8 py-4 bg-green-600 hover:bg-green-700 text-white text-xl font-bold rounded-full">
                    เริ่มสุ่มรางวัล
                </button>
            </div>
        </div>
        
        <div class="bg-gray-800 p-4 rounded-lg mb-4">
            <h3 class="text-xl font-bold text-white mb-4">ผู้โชคดีที่ได้รับรางวัลนี้แล้ว</h3>
            <div class="winner-list">
                <table class="min-w-full bg-gray-700">
                    <thead class="bg-gray-600">
                        <tr>
                            <th class="py-2 px-4 border-b border-gray-500 text-left text-white">ชื่อผู้ได้รับรางวัล</th>
                            <th class="py-2 px-4 border-b border-gray-500 text-center text-white">สถานะ</th>
                            <th class="py-2 px-4 border-b border-gray-500 text-right text-white">วันที่</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (winners != null && !winners.isEmpty()) { %>
                            <% for (RewardClaim winner : winners) { %>
                                <tr class="hover:bg-gray-600">
                                    <td class="py-2 px-4 border-b border-gray-500 text-white"><%= winner.getVisitorName() %></td>
                                    <td class="py-2 px-4 border-b border-gray-500 text-center">
                                        <% if ("1".equals(winner.getIsReceived())) { %>
                                            <span class="px-2 py-1 bg-green-900 text-green-300 rounded-full text-xs">รับแล้ว</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-yellow-900 text-yellow-300 rounded-full text-xs">รอรับ</span>
                                        <% } %>
                                    </td>
                                    <td class="py-2 px-4 border-b border-gray-500 text-white text-right"><%= dateFormat.format(winner.getClaimDate()) %></td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/lucky-draw" class="text-blue-400 hover:underline">กลับไปหน้าสุ่มรางวัล</a>
        </div>
    </div>
    
    <script>
        // ข้อมูลตัวอย่างสำหรับการสุ่ม (จะถูกแทนที่ด้วยข้อมูลจริงจาก AJAX)
        const sampleNames = [
            "สมชาย ใจดี", "วิภา รักเรียน", "ประเสริฐ มานะ", "นภา สดใส",
            "สุรชัย เก่งกล้า", "มานี รักษาศิลป์", "สมหญิง ทองดี", "วิชัย สมบูรณ์",
            "กรรณิการ์ ศรีวิไล", "พิชัย มหาสมบัติ", "สุดา ใจงาม", "ประพนธ์ บัณฑิต"
        ];
        
        // ฟังก์ชันสำหรับการสุ่มรางวัล
        function startLuckyDraw() {
            const randomDisplay = document.getElementById('random-display');
            const winnerDisplay = document.getElementById('winner-display');
            const startButton = document.getElementById('start-draw');
            
            // ซ่อนปุ่มเริ่มสุ่ม
            startButton.classList.add('hidden');
            
            // แสดงการสุ่มชื่อ
            let counter = 0;
            let duration = 50; // เริ่มต้นสุ่มเร็ว
            
            const slowDownInterval = (counter) => {
                // ค่อยๆ ลดความเร็วในการสุ่ม
                if (counter < 10) return 50;
                if (counter < 20) return 100;
                if (counter < 30) return 200;
                if (counter < 40) return 300;
                if (counter < 50) return 400;
                return 500;
            };
            
            const shuffle = () => {
                const randomIndex = Math.floor(Math.random() * sampleNames.length);
                randomDisplay.textContent = sampleNames[randomIndex];
                counter++;
                
                // เปลี่ยนความเร็วในการสุ่ม
                duration = slowDownInterval(counter);
                
                if (counter < 60) {
                    setTimeout(shuffle, duration);
                } else {
                    // เมื่อสุ่มเสร็จแล้ว ให้ดึงผู้ชนะ
                    fetchWinner();
                }
            };
            
            // เริ่มการสุ่ม
            shuffle();
        }
        
        // ฟังก์ชันดึงผู้ชนะจาก API
        function fetchWinner() {
            // สร้าง URL สำหรับการดึงข้อมูล
            const rewardId = <%= reward.getRewardId() %>;
            const apiUrl = `${pageContext.request.contextPath}/lucky-draw-result?rewardId=${rewardId}`;
            
            // เรียก API
            fetch(apiUrl)
                .then(response => {
                    // เมื่อได้รับการตอบกลับ ให้เปลี่ยนการแสดงผล
                    showWinnerAnnouncement();
                })
                .catch(error => {
                    console.error('Error fetching winner:', error);
                    // กรณีเกิดข้อผิดพลาด
                    randomDisplay.textContent = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
                    randomDisplay.classList.remove('flicker-animation');
                    
                    // แสดงปุ่มเริ่มสุ่มอีกครั้ง
                    document.getElementById('start-draw').classList.remove('hidden');
                });
        }
        
        // แสดงผลการประกาศผู้ชนะ
        function showWinnerAnnouncement() {
            const randomDisplay = document.getElementById('random-display');
            const winnerDisplay = document.getElementById('winner-display');
            const winnerName = document.getElementById('winner-name');
            const winnerPhone = document.getElementById('winner-phone');
            
            // หยุดการกระพริบและซ่อนการแสดงการสุ่ม
            randomDisplay.classList.add('hidden');
            
            // ใช้ข้อมูลตัวอย่างถ้าไม่มีผู้ชนะในรายการ
            <% if (winners != null && !winners.isEmpty()) { %>
                winnerName.textContent = "<%= winners.get(0).getVisitorName() %>";
                winnerPhone.textContent = "กรุณาติดต่อรับรางวัลที่จุดบริการ";
            <% } else { %>
                // กรณีไม่มีผู้ชนะในรายการ ใช้ข้อมูลตัวอย่าง
                winnerName.textContent = sampleNames[Math.floor(Math.random() * sampleNames.length)];
                winnerPhone.textContent = "กรุณาติดต่อรับรางวัลที่จุดบริการ";
            <% } %>
            
            // แสดงการประกาศผู้ชนะ
            winnerDisplay.classList.remove('hidden');
            
            // สร้างเอฟเฟค confetti
            createConfetti();
            
            // หลังจาก 20 วินาที ให้รีเฟรชหน้าเพื่อดึงข้อมูลใหม่
            setTimeout(() => {
                window.location.reload();
            }, 20000);
        }
        
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
        
        // ผูกเหตุการณ์คลิกกับปุ่มเริ่มสุ่ม
        document.getElementById('start-draw').addEventListener('click', startLuckyDraw);
    </script>
</body>
</html>