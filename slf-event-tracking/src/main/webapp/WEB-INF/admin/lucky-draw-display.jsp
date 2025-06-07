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
            
            <div id="noWinnersMessage" class="text-gray-500">กำลังโหลดข้อมูล...</div>
            <ul class="divide-y divide-gray-200 hidden" id="winnersList"></ul>
        </div>
    </div>
    
    <div class="container mx-auto px-4 py-10 flex flex-col justify-center items-center min-h-screen relative z-10">
        <div id="mainContent">
            <div class="text-center mb-10">
                <h1 class="text-5xl font-bold mb-4 animate-pulse">การสุ่มรางวัล</h1>
                <div class="bg-purple-800 rounded-lg p-6 inline-block">
                    <h2 id="rewardName" class="text-3xl font-bold text-white mb-2">รอการเริ่มสุ่มรางวัล</h2>
                    <p id="rewardDescription" class="text-purple-200 text-xl">กรุณารอเจ้าหน้าที่เริ่มการสุ่มรางวัล</p>
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
        </div>
        
        <div id="noActiveDrawing" class="text-center hidden">
            <h1 class="text-4xl font-bold mb-6">ยังไม่มีการสุ่มรางวัล</h1>
            <p class="text-xl mb-8">กรุณารอการเริ่มการสุ่มรางวัลจากเจ้าหน้าที่</p>
            <div class="animate-bounce text-yellow-400 text-5xl mb-6">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-20 w-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                </svg>
            </div>
        </div>
    </div>
    
    <!-- Background Animation -->
    <div class="fixed inset-0 z-0">
        <div class="absolute inset-0 bg-gradient-to-br from-purple-900 via-indigo-800 to-purple-900"></div>
        <div id="stars" class="absolute inset-0"></div>
    </div>
    
    <script>
        // Sample data for drawing animation
        const sampleNames = [
            "สมหญิง รักเรียน", "สมชาย ใจดี", "วิชัย มานะ", "สุดา เรียนเก่ง", 
            "จิตรา ใจเย็น", "พิมพ์ใจ รักการอ่าน", "ภานุ ชอบกีฬา", "นภา ชอบดนตรี",
            "สมศักดิ์ ทำงานเก่ง", "สุภาพร รักครอบครัว", "ธนา มีน้ำใจ", "มานี มีศิลปะ",
            "กานดา ชอบท่องเที่ยว", "สมพร ช่างคิด", "ไพศาล ช่างสังเกต", "ณัฐา มุ่งมั่น"
        ];
        
        // Elements
        const mainContent = document.getElementById('mainContent');
        const noActiveDrawing = document.getElementById('noActiveDrawing');
        const waitingSection = document.getElementById('waitingSection');
        const drawingSection = document.getElementById('drawingSection');
        const nameScroller = document.getElementById('nameScroller');
        const progressFill = document.getElementById('progressFill');
        const drawingMessage = document.getElementById('drawingMessage');
        const winnerSection = document.getElementById('winnerSection');
        const winnerName = document.getElementById('winnerName');
        const winnerPhone = document.getElementById('winnerPhone');
        const rewardNameElement = document.getElementById('rewardName');
        const rewardDescriptionElement = document.getElementById('rewardDescription');
        const noWinnersMessage = document.getElementById('noWinnersMessage');
        const winnersList = document.getElementById('winnersList');
        
        // Drawing states
        let isDrawing = false;
        let drawingInterval;
        let progressInterval;
        let pollingInterval;
        let winnersPollingInterval;
        let currentProgress = 0;
        let drawingSpeed = 100; // ms between name changes
        let drawingDuration = 8000; // total drawing time in ms
        let winnerData = null;
        let currentRewardId = null;
        
        // Create stars
        function createStars() {
            const stars = document.getElementById('stars');
            for (let i = 0; i < 200; i++) {
                const star = document.createElement('div');
                star.classList.add('star');
                star.style.width = `${Math.random() * 3}px`;
                star.style.height = star.style.width;
                star.style.left = `${Math.random() * 100}%`;
                star.style.top = `${Math.random() * 100}%`;
                star.style.animationDuration = `${Math.random() * 3 + 1}s`;
                star.style.animationDelay = `${Math.random() * 3}s`;
                stars.appendChild(star);
            }
        }
        
        // Add CSS for stars
        const starStyle = document.createElement('style');
        starStyle.textContent = `
            .star {
                position: absolute;
                background-color: white;
                border-radius: 50%;
                opacity: 0;
                animation: twinkle ease-in-out infinite;
            }
            @keyframes twinkle {
                0%, 100% { opacity: 0; }
                50% { opacity: 0.8; }
            }
        `;
        document.head.appendChild(starStyle);
        createStars();
        
        // Function to poll for current drawing
        function pollCurrentDrawing() {
            fetch('api/current-drawing')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 更新页面上的奖品信息
                        currentRewardId = data.rewardId;
                        rewardNameElement.textContent = data.rewardName || "รอการเริ่มสุ่มรางวัล";
                        rewardDescriptionElement.textContent = data.rewardDescription || "";
                        
                        // ตรวจสอบสถานะการสุ่ม
                        if (data.isActive) {
                            // แสดงส่วนเนื้อหาหลัก
                            mainContent.classList.remove('hidden');
                            noActiveDrawing.classList.add('hidden');
                            
                            // ตรวจสอบว่ามีผู้ชนะหรือไม่
                            if (data.winner) {
                                // ถ้ามีผู้ชนะแล้ว แสดงผลผู้ชนะทันที
                                if (!isDrawing && !winnerData) {
                                    winnerData = data.winner;
                                    startDrawingAnimation();
                                }
                            } else {
                                // กำลังอยู่ในโหมดรอหรือกำลังสุ่ม
                                waitingSection.classList.remove('hidden');
                                drawingSection.classList.add('hidden');
                                winnerSection.classList.add('hidden');
                            }
                            
                            // โหลดรายชื่อผู้โชคดีที่เคยถูกรางวัลนี้
                            loadWinners(currentRewardId);
                        } else {
                            // ไม่มีการสุ่มที่กำลังดำเนินอยู่
                            resetDisplay();
                        }
                    } else {
                        // ไม่มีการสุ่มที่กำลังดำเนินอยู่
                        resetDisplay();
                    }
                })
                .catch(error => {
                    console.error('Error polling current drawing:', error);
                });
        }
        
        // Function to load winners for the current reward
        function loadWinners(rewardId) {
            if (!rewardId) return;
            
            fetch(`api/get-winners?rewardId=${rewardId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.winners && data.winners.length > 0) {
                        // Clear previous list
                        winnersList.innerHTML = '';
                        noWinnersMessage.classList.add('hidden');
                        winnersList.classList.remove('hidden');
                        
                        // Add winners to the list
                        data.winners.forEach(winner => {
                            const listItem = document.createElement('li');
                            listItem.className = 'py-2';
                            
                            const nameSpan = document.createElement('span');
                            nameSpan.className = 'font-medium text-gray-800';
                            nameSpan.textContent = winner.visitorName;
                            
                            const dateSpan = document.createElement('span');
                            dateSpan.className = 'text-sm text-gray-500 ml-2';
                            dateSpan.textContent = winner.claimDate;
                            
                            listItem.appendChild(nameSpan);
                            listItem.appendChild(dateSpan);
                            
                            if (winner.isReceived === '1') {
                                const badge = document.createElement('span');
                                badge.className = 'ml-2 px-2 py-1 text-xs rounded bg-green-100 text-green-800';
                                badge.textContent = 'รับแล้ว';
                                listItem.appendChild(badge);
                            }
                            
                            winnersList.appendChild(listItem);
                        });
                    } else {
                        // No winners yet
                        noWinnersMessage.textContent = 'ยังไม่มีผู้ได้รับรางวัลนี้';
                        noWinnersMessage.classList.remove('hidden');
                        winnersList.classList.add('hidden');
                    }
                })
                .catch(error => {
                    console.error('Error loading winners:', error);
                });
        }
        
        // Function to reset display to waiting state
        function resetDisplay() {
            mainContent.classList.add('hidden');
            noActiveDrawing.classList.remove('hidden');
            waitingSection.classList.remove('hidden');
            drawingSection.classList.add('hidden');
            winnerSection.classList.add('hidden');
            
            // Reset variables
            isDrawing = false;
            currentProgress = 0;
            winnerData = null;
            
            // Clear intervals
            if (drawingInterval) clearInterval(drawingInterval);
            if (progressInterval) clearInterval(progressInterval);
            
            // Reset progress bar
            progressFill.style.width = '0%';
        }
        
        // Function to start the drawing animation
        function startDrawingAnimation() {
            // Reset state
            isDrawing = true;
            currentProgress = 0;
            
            // Hide waiting section, show drawing section
            waitingSection.classList.add('hidden');
            drawingSection.classList.remove('hidden');
            winnerSection.classList.add('hidden');
            
            // Start the name scrolling animation
            drawingInterval = setInterval(() => {
                // Pick a random name from the sample names
                const randomName = sampleNames[Math.floor(Math.random() * sampleNames.length)];
                nameScroller.textContent = randomName;
                
                // Add a visual effect
                nameScroller.classList.add('scale-110');
                setTimeout(() => {
                    nameScroller.classList.remove('scale-110');
                }, 50);
            }, drawingSpeed);
            
            // Update progress bar
            progressInterval = setInterval(() => {
                currentProgress += (100 * 100 / drawingDuration);
                if (currentProgress >= 100) {
                    currentProgress = 100;
                    
                    // Clear intervals
                    clearInterval(drawingInterval);
                    clearInterval(progressInterval);
                    
                    // Show winner
                    showWinner();
                }
                progressFill.style.width = `${currentProgress}%`;
                
                // Update message based on progress
                if (currentProgress < 30) {
                    drawingMessage.textContent = "กำลังสุ่มรางวัล...";
                } else if (currentProgress < 60) {
                    drawingMessage.textContent = "ใกล้จะได้ผลแล้ว...";
                } else if (currentProgress < 90) {
                    drawingMessage.textContent = "อีกนิดเดียว...";
                } else {
                    drawingMessage.textContent = "ได้ผู้โชคดีแล้ว!";
                }
            }, 100);
        }
        
        // Function to show the winner
        function showWinner() {
            // Set the winner name and phone
            if (winnerData) {
                winnerName.textContent = winnerData.name;
                
                // Format phone number to show only last 4 digits
                const phone = winnerData.phone;
                const maskedPhone = phone ? 
                    phone.substring(0, phone.length - 4).replace(/\d/g, 'x') + 
                    phone.substring(phone.length - 4) : '';
                winnerPhone.textContent = maskedPhone;
            } else {
                winnerName.textContent = "ไม่พบผู้โชคดี";
                winnerPhone.textContent = "";
            }
            
            // Hide drawing section, show winner section
            drawingSection.classList.add('hidden');
            winnerSection.classList.remove('hidden');
            
            // Trigger confetti effect
            triggerConfetti();
            
            // Reset drawing state
            isDrawing = false;
        }
        
        // Function to trigger confetti effect
        function triggerConfetti() {
            // Use canvas-confetti library
            const duration = 5 * 1000;
            const animationEnd = Date.now() + duration;
            const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };
            
            function randomInRange(min, max) {
                return Math.random() * (max - min) + min;
            }
            
            const interval = setInterval(function() {
                const timeLeft = animationEnd - Date.now();
                
                if (timeLeft <= 0) {
                    return clearInterval(interval);
                }
                
                const particleCount = 50 * (timeLeft / duration);
                
                // since particles fall down, start a bit higher than random
                confetti(
                    Object.assign({}, defaults, {
                        particleCount,
                        origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 }
                    })
                );
                confetti(
                    Object.assign({}, defaults, {
                        particleCount,
                        origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 }
                    })
                );
            }, 250);
        }
        
        // Start polling for current drawing and winners
        pollingInterval = setInterval(pollCurrentDrawing, 2000);
        pollCurrentDrawing(); // Initial poll
    </script>
</body>
</html>