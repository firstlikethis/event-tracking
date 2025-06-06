<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="th.or.studentloan.event.model.RewardClaim" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>หน้าจอสุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Confetti Effect -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
</head>
<body class="bg-purple-900 text-white min-h-screen overflow-hidden">
    <% 
        Reward reward = (Reward) request.getAttribute("reward");
        List<RewardClaim> winners = (List<RewardClaim>) request.getAttribute("winners");
    %>
    
    <div class="fixed top-0 right-0 p-4 z-30">
        <div class="bg-white rounded-lg shadow-lg p-4 max-h-96 overflow-y-auto max-w-md">
            <h3 class="text-lg font-bold text-purple-800 mb-3">ผู้โชคดีที่ผ่านมา</h3>
            
            <% if (winners != null && !winners.isEmpty()) { %>
                <ul class="divide-y divide-gray-200" id="winnersList">
                    <% for (RewardClaim winner : winners) { %>
                        <tr class="hover:bg-gray-50">
                            <td class="py-2 px-4 border-b">${winner.visitorName}</td>
                            <td class="py-2 px-4 border-b text-center">${winner.claimDate}</td>
                            <td class="py-2 px-4 border-b text-center">
                                <c:if test="${winner.isReceived == '1'}">
                                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">รับแล้ว</span>
                                </c:if>
                                <c:if test="${winner.isReceived != '1'}">
                                    <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">รอรับ</span>
                                </c:if>
                            </td>
                        </tr>
                    <% } %>
                </ul>
            <% } else { %>
                <p class="text-gray-500" id="noWinnersMessage">ยังไม่มีผู้โชคดีได้รับรางวัลนี้</p>
                <ul class="divide-y divide-gray-200 hidden" id="winnersList"></ul>
            <% } %>
        </div>
    </div>
    
    <div class="container mx-auto px-4 py-10 flex flex-col justify-center items-center min-h-screen relative z-10">
        <% if (reward != null) { %>
            <div class="text-center mb-10">
                <h1 class="text-5xl font-bold mb-4 animate-pulse">การสุ่มรางวัล</h1>
                <div class="bg-purple-800 rounded-lg p-6 inline-block">
                    <h2 class="text-3xl font-bold text-white mb-2"><%= reward.getRewardName() %></h2>
                    <% if (reward.getRewardDescription() != null && !reward.getRewardDescription().isEmpty()) { %>
                        <p class="text-purple-200 text-xl"><%= reward.getRewardDescription() %></p>
                    <% } %>
                </div>
            </div>
            
            <div id="drawingContainer" class="w-full max-w-4xl">
                <div id="waitingSection" class="text-center">
                    <div class="bg-black bg-opacity-50 rounded-2xl p-10">
                        <div class="flex flex-col items-center justify-center min-h-[300px]">
                            <div class="text-3xl font-bold text-white mb-6">รอการเริ่มสุ่มรางวัล</div>
                            <div class="animate-bounce text-yellow-400 text-5xl mb-6">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-20 w-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                                </svg>
                            </div>
                            <p class="text-gray-300">กรุณารอสักครู่ ระบบจะเริ่มสุ่มอัตโนมัติเมื่อได้รับคำสั่ง</p>
                        </div>
                    </div>
                </div>
                
                <div id="drawingSection" class="hidden">
                    <div class="bg-black bg-opacity-50 rounded-2xl p-10 relative overflow-hidden">
                        <div id="nameScrollContainer" class="min-h-[300px] flex items-center justify-center">
                            <div id="nameScroller" class="text-6xl font-bold text-center transition-all transform">
                                <!-- Names will be inserted here dynamically -->
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-6 text-center">
                        <div id="progressBar" class="h-4 bg-gray-700 rounded-full overflow-hidden">
                            <div id="progressFill" class="h-full bg-green-500 transition-all" style="width: 0%"></div>
                        </div>
                        <p id="drawingMessage" class="mt-2 text-xl">กำลังสุ่มรางวัล...</p>
                    </div>
                </div>
                
                <div id="winnerSection" class="hidden text-center">
                    <div class="bg-gradient-to-r from-yellow-400 via-yellow-500 to-yellow-600 p-1 rounded-2xl shadow-xl">
                        <div class="bg-white rounded-xl p-10">
                            <h2 class="text-4xl font-bold text-purple-900 mb-6">ผู้โชคดีได้แก่</h2>
                            <div class="mb-6">
                                <span id="winnerName" class="text-6xl font-extrabold text-yellow-600 block mb-4"></span>
                                <span id="winnerPhone" class="text-2xl text-gray-700"></span>
                            </div>
                            <div id="winnerConfetti"></div>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="text-center">
                <h1 class="text-4xl font-bold mb-6">ไม่พบข้อมูลรางวัล</h1>
                <p class="text-xl mb-8">ไม่พบข้อมูลรางวัลที่ต้องการสุ่ม กรุณาลองใหม่อีกครั้ง</p>
                <a href="${pageContext.request.contextPath}/lucky-draw" class="px-6 py-3 bg-purple-600 hover:bg-purple-700 text-white font-bold rounded-lg transition-colors">
                    กลับไปหน้าสุ่มรางวัล
                </a>
            </div>
        <% } %>
    </div>
    
    <!-- Background Animation -->
    <div class="fixed inset-0 z-0">
        <div class="absolute inset-0 bg-gradient-to-br from-purple-900 via-indigo-800 to-purple-900"></div>
        <div id="stars" class="absolute inset-0"></div>
    </div>
    
    <% if (reward != null) { %>
    <script>
        // Sample data for drawing animation
        const sampleNames = [
            "สมหญิง รักเรียน", "สมชาย ใจดี", "วิชัย มานะ", "สุดา เรียนเก่ง", 
            "จิตรา ใจเย็น", "พิมพ์ใจ รักการอ่าน", "ภานุ ชอบกีฬา", "นภา ชอบดนตรี",
            "สมศักดิ์ ทำงานเก่ง", "สุภาพร รักครอบครัว", "ธนา มีน้ำใจ", "มานี มีศิลปะ",
            "กานดา ชอบท่องเที่ยว", "สมพร ช่างคิด", "ไพศาล ช่างสังเกต", "ณัฐา มุ่งมั่น"
        ];
        
        // Elements
        const waitingSection = document.getElementById('waitingSection');
        const drawingSection = document.getElementById('drawingSection');
        const nameScroller = document.getElementById('nameScroller');
        const progressFill = document.getElementById('progressFill');
        const drawingMessage = document.getElementById('drawingMessage');
        const winnerSection = document.getElementById('winnerSection');
        const winnerName = document.getElementById('winnerName');
        const winnerPhone = document.getElementById('winnerPhone');
        const noWinnersMessage = document.getElementById('noWinnersMessage');
        const winnersList = document.getElementById('winnersList');
        
        // Drawing states
        let isDrawing = false;
        let drawingInterval;
        let progressInterval;
        let pollingInterval;
        let currentProgress = 0;
        let drawingSpeed = 100; // ms between name changes
        let drawingDuration = 8000; // total drawing time in ms
        let winnerData = null;
        
        // Create stars
        function createStars() {
            const stars = document.getElementById('stars');
            for (let i = 0; i < 200; i++) {
                const star = document.createElement('div');
                star.className = 'absolute rounded-full';
                
                // Random size
                const size = Math.random() * 3 + 1;
                star.style.width = `${size}px`;
                star.style.height = `${size}px`;
                
                // Random position
                star.style.left = `${Math.random() * 100}%`;
                star.style.top = `${Math.random() * 100}%`;
                
                // Random opacity and color
                star.style.opacity = Math.random() * 0.8 + 0.2;
                star.style.backgroundColor = i % 5 === 0 ? '#f0f0f0' : '#ffffff';
                
                // Animation
                const duration = Math.random() * 3 + 2;
                star.style.animation = `twinkle ${duration}s infinite alternate`;
                
                stars.appendChild(star);
            }
        }
        
        // Animate name scrolling
        function animateNameScroller() {
            let index = 0;
            
            drawingInterval = setInterval(() => {
                if (drawingSpeed > 30) {
                    drawingSpeed -= 1; // Speed up gradually
                }
                
                // Get random name
                const randomIndex = Math.floor(Math.random() * sampleNames.length);
                nameScroller.textContent = sampleNames[randomIndex];
                
                // Apply random transform
                const yPos = Math.random() * 20 - 10;
                nameScroller.style.transform = `translateY(${yPos}px)`;
                
                index++;
            }, drawingSpeed);
        }
        
        // Animate progress bar
        function animateProgressBar() {
            currentProgress = 0;
            progressFill.style.width = '0%';
            
            const step = 100 / (drawingDuration / 100); // Update every 100ms
            
            progressInterval = setInterval(() => {
                currentProgress += step;
                if (currentProgress >= 100) {
                    currentProgress = 100;
                    clearInterval(progressInterval);
                    finishDrawing();
                }
                progressFill.style.width = `${currentProgress}%`;
                
                // Update message based on progress
                if (currentProgress < 30) {
                    drawingMessage.textContent = "กำลังสุ่มรางวัล...";
                } else if (currentProgress < 60) {
                    drawingMessage.textContent = "ใกล้ได้ผู้โชคดีแล้ว...";
                } else if (currentProgress < 90) {
                    drawingMessage.textContent = "อีกนิดเดียว...";
                } else {
                    drawingMessage.textContent = "เตรียมพบผู้โชคดี!";
                }
            }, 100);
        }
        
        // Fetch winner data
        async function fetchWinnerData() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/get-winner?rewardId=${reward.getRewardId()}');
                const data = await response.json();
                
                if (data.success) {
                    return {
                        name: data.winnerName,
                        phone: data.winnerPhone,
                        visitorId: data.visitorId
                    };
                } else {
                    return null;
                }
            } catch (error) {
                console.error('Error fetching winner:', error);
                return null;
            }
        }
        
        // Check if we should start drawing
        async function checkDrawingStatus() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/get-winner?rewardId=${reward.getRewardId()}');
                const data = await response.json();
                
                // If winner data exists and we're not already drawing, start drawing
                if (data.success && !isDrawing) {
                    winnerData = {
                        name: data.winnerName,
                        phone: data.winnerPhone,
                        visitorId: data.visitorId
                    };
                    
                    startDrawing();
                }
            } catch (error) {
                console.error('Error checking drawing status:', error);
            }
        }
        
        // Start drawing animation
        async function startDrawing() {
            if (isDrawing) return;
            isDrawing = true;
            
            // Stop polling when we start drawing
            if (pollingInterval) {
                clearInterval(pollingInterval);
            }
            
            // Hide waiting section, show drawing section
            waitingSection.classList.add('hidden');
            drawingSection.classList.remove('hidden');
            
            // Start animations
            animateNameScroller();
            animateProgressBar();
        }
        
        // Finish drawing and show winner
        function finishDrawing() {
            // Stop animations
            clearInterval(drawingInterval);
            clearInterval(progressInterval);
            isDrawing = false;
            
            // Hide drawing section, show winner section
            drawingSection.classList.add('hidden');
            winnerSection.classList.remove('hidden');
            
            // Display winner info
            winnerName.textContent = winnerData.name;
            winnerPhone.textContent = formatPhoneNumber(winnerData.phone);
            
            // Update winners list
            updateWinnersList(winnerData);
            
            // Launch confetti
            launchConfetti();
            
            // Restart polling after 10 seconds
            setTimeout(() => {
                resetToWaiting();
            }, 30000); // 30 seconds
        }
        
        // Reset to waiting screen
        function resetToWaiting() {
            // Hide winner section, show waiting section
            winnerSection.classList.add('hidden');
            waitingSection.classList.remove('hidden');
            
            // Reset state
            isDrawing = false;
            drawingSpeed = 100;
            currentProgress = 0;
            progressFill.style.width = '0%';
            
            // Start polling again
            startPolling();
        }
        
        // Update winners list in sidebar
        function updateWinnersList(winner) {
            if (noWinnersMessage) {
                noWinnersMessage.classList.add('hidden');
            }
            
            winnersList.classList.remove('hidden');
            
            // Create new winner item
            const listItem = document.createElement('li');
            listItem.className = 'py-2';
            
            const nameElement = document.createElement('p');
            nameElement.className = 'text-gray-800 font-medium';
            nameElement.textContent = winner.name;
            
            const dateElement = document.createElement('p');
            dateElement.className = 'text-gray-500 text-sm';
            
            // Format current date
            const now = new Date();
            const day = String(now.getDate()).padStart(2, '0');
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const year = now.getFullYear();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            
            dateElement.textContent = `${day}/${month}/${year} ${hours}:${minutes}`;
            
            listItem.appendChild(nameElement);
            listItem.appendChild(dateElement);
            
            // Add to the top of the list
            winnersList.insertBefore(listItem, winnersList.firstChild);
        }
        
        // Format phone number (e.g., 08x-xxx-xxxx)
        function formatPhoneNumber(phone) {
            if (!phone || phone.length < 10) return phone;
            
            return `${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6)}`;
        }
        
        // Launch confetti animation
        function launchConfetti() {
            const duration = 5 * 1000;
            const animationEnd = Date.now() + duration;
            
            function randomInRange(min, max) {
                return Math.random() * (max - min) + min;
            }
            
            // Run confetti
            (function frame() {
                const timeLeft = animationEnd - Date.now();
                
                if (timeLeft <= 0) return;
                
                const particleCount = 50 * (timeLeft / duration);
                
                // Launch confetti from both sides
                confetti({
                    particleCount: particleCount,
                    angle: randomInRange(55, 125),
                    spread: randomInRange(50, 70),
                    origin: { x: 0 },
                    colors: ['#FFD700', '#FFC107', '#FFEB3B', '#9C27B0', '#673AB7']
                });
                
                confetti({
                    particleCount: particleCount,
                    angle: randomInRange(55, 125),
                    spread: randomInRange(50, 70),
                    origin: { x: 1 },
                    colors: ['#FFD700', '#FFC107', '#FFEB3B', '#9C27B0', '#673AB7']
                });
                
                requestAnimationFrame(frame);
            }());
        }
        
        // Start polling for winner data
        function startPolling() {
            // Check immediately when the page loads
            checkDrawingStatus();
            
            // Then poll every 2 seconds
            pollingInterval = setInterval(checkDrawingStatus, 2000);
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', () => {
            createStars();
            
            // Add CSS for star animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes twinkle {
                    0% { opacity: 0.2; }
                    100% { opacity: 1; }
                }
            `;
            document.head.appendChild(style);
            
            // Start polling
            startPolling();
        });
    </script>
    <% } %>
</body>
</html>