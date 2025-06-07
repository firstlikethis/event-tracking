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
    <title>สุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .animate-pulse-custom {
            animation: pulse 1.5s infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .spinner {
            border: 8px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top: 8px solid #3498db;
            width: 80px;
            height: 80px;
            animation: spin 1s linear infinite;
        }
        
        .winner-appear {
            animation: appear 0.5s ease-out;
        }
        
        @keyframes appear {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        body {
            background-color: #111827;
            color: white;
            overflow: hidden;
        }
        
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background-color: #f00;
            animation: fall linear;
            top: -10px;
        }
        
        @keyframes fall {
            0% { transform: translateY(0) rotate(0deg); }
            100% { transform: translateY(100vh) rotate(360deg); }
        }
    </style>
</head>
<body class="bg-gray-900 text-white min-h-screen">
    <% 
        Reward reward = (Reward) request.getAttribute("reward");
        List<RewardClaim> winners = (List<RewardClaim>) request.getAttribute("winners");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <div class="container mx-auto px-4 py-8">
        <!-- หน้าจอสำหรับแสดงผลการสุ่มรางวัล -->
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-white mb-2">ระบบสุ่มรางวัล</h1>
            <p class="text-xl text-blue-400">กองทุนเงินให้กู้ยืมเพื่อการศึกษา</p>
        </div>
        
        <div class="grid grid-cols-3 gap-6 mb-8">
            <!-- แสดงรางวัลปัจจุบัน -->
            <div class="col-span-2 bg-gray-800 rounded-lg shadow-lg p-6">
                <div id="rewardInfo" class="text-center">
                    <% if (reward != null) { %>
                        <h2 class="text-3xl font-bold text-yellow-400 mb-4"><%= reward.getRewardName() %></h2>
                        <p class="text-gray-300 text-lg mb-6"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
                        <div class="flex justify-center space-x-8 mb-6">
                            <div class="text-center">
                                <p class="text-gray-400">คะแนนที่ต้องใช้</p>
                                <p class="text-2xl font-bold text-blue-400"><%= reward.getPointsRequired() %></p>
                            </div>
                            <div class="text-center">
                                <p class="text-gray-400">จำนวนรางวัลที่เหลือ</p>
                                <p class="text-2xl font-bold text-green-400"><%= reward.getRemaining() %>/<%= reward.getQuantity() %></p>
                            </div>
                        </div>
                        <button id="startLuckyDrawBtn" class="px-6 py-3 bg-purple-600 text-white font-bold rounded-lg hover:bg-purple-700 transition-colors mb-4 animate-pulse-custom">
                            เริ่มสุ่มรางวัล
                        </button>
                    <% } else { %>
                        <h2 class="text-3xl font-bold text-yellow-400 mb-4">กรุณาเลือกรางวัลที่ต้องการสุ่ม</h2>
                        <p class="text-gray-300 text-lg mb-6">โปรดเลือกรางวัลในหน้าสุ่มรางวัล</p>
                    <% } %>
                </div>
                
                <!-- ส่วนแสดงการสุ่ม (จะถูกแสดงเมื่อกดปุ่มเริ่มสุ่มรางวัล) -->
                <div id="drawingProcess" class="hidden">
                    <div class="text-center">
                        <div class="spinner mx-auto mb-6"></div>
                        <h3 class="text-2xl font-bold text-white mb-4">กำลังสุ่มรางวัล...</h3>
                        <p class="text-gray-300">กรุณารอสักครู่</p>
                    </div>
                </div>
                
                <!-- ส่วนแสดงผู้โชคดี (จะถูกแสดงเมื่อสุ่มรางวัลเสร็จ) -->
                <div id="winnerDisplay" class="hidden winner-appear">
                    <div class="text-center">
                        <h3 class="text-3xl font-bold text-green-400 mb-6">ผู้โชคดีได้รับรางวัล</h3>
                        <div class="bg-gray-700 rounded-xl p-8 shadow-lg border-2 border-yellow-400">
                            <p id="winnerName" class="text-4xl font-bold text-white mb-4"></p>
                            <p id="winnerPhone" class="text-2xl text-gray-300 mb-4"></p>
                            <p id="winnerType" class="text-xl text-blue-300"></p>
                        </div>
                        <button id="resetDrawBtn" class="mt-8 px-6 py-3 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-700 transition-colors">
                            เริ่มสุ่มใหม่
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- แสดงรายชื่อผู้โชคดีก่อนหน้า -->
            <div class="bg-gray-800 rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-white mb-4 text-center">รายชื่อผู้โชคดีที่ผ่านมา</h3>
                
                <div class="overflow-y-auto max-h-96 pr-2">
                    <% if (winners != null && !winners.isEmpty()) { %>
                        <div class="space-y-4">
                            <% for (RewardClaim claim : winners) { %>
                                <div class="bg-gray-700 rounded-lg p-3 border-l-4 border-green-500">
                                    <p class="font-bold text-white"><%= claim.getVisitorName() %></p>
                                    <div class="flex justify-between text-sm">
                                        <span class="text-gray-300"><%= dateFormat.format(claim.getClaimDate()) %></span>
                                        <span class="<%= "1".equals(claim.getIsReceived()) ? "text-green-400" : "text-yellow-400" %>">
                                            <%= "1".equals(claim.getIsReceived()) ? "รับแล้ว" : "รอรับรางวัล" %>
                                        </span>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p class="text-gray-400 text-center py-8">ยังไม่มีผู้โชคดีสำหรับรางวัลนี้</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <div id="confettiContainer"></div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const startLuckyDrawBtn = document.getElementById('startLuckyDrawBtn');
            const resetDrawBtn = document.getElementById('resetDrawBtn');
            const rewardInfo = document.getElementById('rewardInfo');
            const drawingProcess = document.getElementById('drawingProcess');
            const winnerDisplay = document.getElementById('winnerDisplay');
            
            if (startLuckyDrawBtn) {
                startLuckyDrawBtn.addEventListener('click', function() {
                    // ซ่อนข้อมูลรางวัลและแสดงกระบวนการสุ่ม
                    rewardInfo.classList.add('hidden');
                    drawingProcess.classList.remove('hidden');
                    
                    // จำลองการสุ่มรางวัล (ในระบบจริงควรเรียก API)
                    <% if (reward != null) { %>
                        // เรียกใช้ API เพื่อสุ่มรางวัล
                        setTimeout(function() {
                            fetch('${pageContext.request.contextPath}/api/get-winner?rewardId=<%= reward.getRewardId() %>')
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        // แสดงผู้โชคดี
                                        document.getElementById('winnerName').textContent = data.winner.fullname;
                                        document.getElementById('winnerPhone').textContent = maskPhoneNumber(data.winner.phoneNumber);
                                        document.getElementById('winnerType').textContent = getVisitorTypeName(data.winner.visitorType);
                                        
                                        // ซ่อนกระบวนการสุ่มและแสดงผู้โชคดี
                                        drawingProcess.classList.add('hidden');
                                        winnerDisplay.classList.remove('hidden');
                                        
                                        // แสดง confetti
                                        createConfetti();
                                    } else {
                                        // แสดงข้อความว่าไม่พบผู้โชคดี
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'ไม่พบผู้มีสิทธิ์รับรางวัล',
                                            text: 'ไม่พบผู้เข้าร่วมที่มีสิทธิ์รับรางวัลนี้ กรุณาลองใหม่อีกครั้ง',
                                            confirmButtonText: 'ตกลง'
                                        }).then(() => {
                                            // กลับไปแสดงข้อมูลรางวัล
                                            drawingProcess.classList.add('hidden');
                                            rewardInfo.classList.remove('hidden');
                                        });
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'เกิดข้อผิดพลาด',
                                        text: 'ไม่สามารถสุ่มรางวัลได้ กรุณาลองใหม่อีกครั้ง',
                                        confirmButtonText: 'ตกลง'
                                    }).then(() => {
                                        // กลับไปแสดงข้อมูลรางวัล
                                        drawingProcess.classList.add('hidden');
                                        rewardInfo.classList.remove('hidden');
                                    });
                                });
                        }, 3000); // จำลองการรอ 3 วินาที
                    <% } else { %>
                        // กรณีไม่มีรางวัลที่เลือก
                        setTimeout(function() {
                            Swal.fire({
                                icon: 'warning',
                                title: 'ไม่พบรางวัล',
                                text: 'กรุณาเลือกรางวัลก่อนทำการสุ่ม',
                                confirmButtonText: 'ตกลง'
                            }).then(() => {
                                // กลับไปแสดงข้อมูลรางวัล
                                drawingProcess.classList.add('hidden');
                                rewardInfo.classList.remove('hidden');
                            });
                        }, 1000);
                    <% } %>
                });
            }
            
            if (resetDrawBtn) {
                resetDrawBtn.addEventListener('click', function() {
                    // ซ่อนผู้โชคดีและแสดงข้อมูลรางวัล
                    winnerDisplay.classList.add('hidden');
                    rewardInfo.classList.remove('hidden');
                    
                    // รีเฟรชหน้าเพื่อดึงข้อมูลล่าสุด
                    window.location.reload();
                });
            }
            
            // ฟังก์ชันแสดง confetti
            function createConfetti() {
                const confettiContainer = document.getElementById('confettiContainer');
                const colors = ['#f00', '#0f0', '#00f', '#ff0', '#f0f', '#0ff'];
                
                for (let i = 0; i < 100; i++) {
                    const confetti = document.createElement('div');
                    confetti.className = 'confetti';
                    confetti.style.left = Math.random() * 100 + 'vw';
                    confetti.style.width = Math.random() * 10 + 5 + 'px';
                    confetti.style.height = confetti.style.width;
                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    confetti.style.animationDuration = Math.random() * 3 + 2 + 's';
                    
                    confettiContainer.appendChild(confetti);
                    
                    // ลบ confetti หลังจากการเคลื่อนไหวเสร็จสิ้น
                    setTimeout(() => {
                        confetti.remove();
                    }, 5000);
                }
            }
            
            // ฟังก์ชันปกปิดเบอร์โทรศัพท์
            function maskPhoneNumber(phone) {
                if (!phone) return '';
                return phone.substring(0, phone.length - 4).replace(/\d/g, 'x') + 
                       phone.substring(phone.length - 4);
            }
            
            // ฟังก์ชันแปลงประเภทผู้เข้าร่วม
            function getVisitorTypeName(visitorType) {
                switch (visitorType) {
                    case '1': return 'นักเรียน/นักศึกษา (ทั่วไป)';
                    case '2': return 'นักเรียน/นักศึกษา (ผู้กู้ยืม กยศ.)';
                    case '3': return 'บุคคลทั่วไป';
                    case '4': return 'อาจารย์/บุคลากรทางการศึกษา';
                    case '5': return 'องค์กรนายจ้าง';
                    case '6': return 'ผู้บริหาร';
                    default: return 'ไม่ระบุ';
                }
            }
        });
    </script>
</body>
</html>