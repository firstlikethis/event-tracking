<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>จอแสดงผลการสุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body, html {
            height: 100%;
            margin: 0;
            overflow: hidden;
            background-color: #1a1a2e;
            color: white;
        }
        
        .lottery-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        .name-display {
            font-size: 5rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 2rem;
            min-height: 8rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .reward-info {
            font-size: 2rem;
            text-align: center;
            margin-bottom: 1rem;
        }
        
        .animation-container {
            width: 100%;
            max-width: 800px;
            text-align: center;
            perspective: 1000px;
        }
        
        .spinner {
            display: inline-block;
            padding: 2rem;
            margin: 0 auto;
            width: 100%;
            height: 150px;
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .name-scroll {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            transition: transform 0.1s;
            font-size: 2.5rem;
            font-weight: bold;
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .winner-display {
            margin-top: 3rem;
            text-align: center;
            opacity: 0;
            transition: opacity 1s;
        }
        
        .winner-display.show {
            opacity: 1;
        }
        
        .winner-name {
            font-size: 4rem;
            font-weight: bold;
            color: #ffd700;
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background-color: #f00;
            opacity: 0.8;
            animation: confetti-fall 5s linear forwards;
        }
        
        @keyframes confetti-fall {
            0% { transform: translateY(-100vh) rotate(0deg); }
            100% { transform: translateY(100vh) rotate(360deg); }
        }
        
        .winners-history {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 10px;
            padding: 1rem;
            max-width: 300px;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .winners-history h3 {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            padding-bottom: 0.5rem;
        }
        
        .winners-history ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .winners-history li {
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
        }
        
        .winners-history .winner-name {
            font-size: 1rem;
            color: #ffd700;
            animation: none;
            text-shadow: none;
        }
        
        .winners-history .reward-name {
            font-size: 0.8rem;
            color: #fff;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="lottery-container">
        <h1 class="text-4xl font-bold mb-8 text-center">การสุ่มรางวัล</h1>
        
        <div id="rewardInfo" class="reward-info">
            รอการสุ่มรางวัล...
        </div>
        
        <div class="animation-container">
            <div id="spinner" class="spinner">
                <div id="nameScroll" class="name-scroll">
                    รอการสุ่มรางวัล...
                </div>
            </div>
        </div>
        
        <div id="winnerDisplay" class="winner-display">
            <div class="text-xl mb-2">ผู้โชคดี</div>
            <div id="winnerName" class="winner-name"></div>
        </div>
        
        <div id="winnersHistory" class="winners-history">
            <h3>รายชื่อผู้โชคดีล่าสุด</h3>
            <ul id="winnersHistoryList">
                <!-- รายชื่อผู้โชคดีจะถูกเพิ่มที่นี่ -->
            </ul>
        </div>
    </div>
    
    <script>
        // รายชื่อตัวอย่างสำหรับแสดงระหว่างการสุ่ม
        const dummyNames = [
            "สมชาย ใจดี",
            "สมหญิง รักเรียน",
            "วิชัย สุขสันต์",
            "มานี มานะ",
            "สมศรี มีทรัพย์",
            "ประเสริฐ รุ่งโรจน์",
            "นารี สดใส",
            "พิชัย ชัยมงคล",
            "วิไล แสงจันทร์",
            "สมบูรณ์ พูนสุข",
            "อภิชาติ ใจเย็น",
            "จารุวรรณ รักสงบ",
            "อนันต์ มั่นคง",
            "สุนันทา ยิ้มแย้ม",
            "ธีระ ตั้งใจ",
            "กมลา รักษาสัตย์",
            "บุญมี ศรีสุข",
            "กรองแก้ว ใจบุญ",
            "ธงชัย ชัยชนะ",
            "มณฑา ทองดี"
        ];
        
        // รายชื่อผู้โชคดีล่าสุด
        const winners = [];
        
        let isSpinning = false;
        let spinInterval;
        let spinSpeed = 100; // มิลลิวินาที
        let currentNameIndex = 0;
        let finalWinnerName = "";
        let finalRewardName = "";
        
        // ฟังก์ชันสุ่มรายชื่อในขณะที่รอผลการสุ่ม
        function startSpinning() {
            if (isSpinning) return;
            
            isSpinning = true;
            document.getElementById('winnerDisplay').classList.remove('show');
            
            // สลับชื่อสำหรับแสดงระหว่างรอผล
            spinInterval = setInterval(() => {
                currentNameIndex = (currentNameIndex + 1) % dummyNames.length;
                document.getElementById('nameScroll').textContent = dummyNames[currentNameIndex];
            }, spinSpeed);
        }
        
        // ฟังก์ชันหยุดการสุ่มและแสดงผู้โชคดี
        function stopSpinning(winnerName) {
            if (!isSpinning) return;
            
            // หยุดการสุ่มอย่างช้าๆ
            const slowDown = () => {
                spinSpeed += 20;
                if (spinSpeed >= 500) {
                    clearInterval(spinInterval);
                    
                    // แสดงชื่อผู้โชคดี
                    document.getElementById('nameScroll').textContent = winnerName;
                    document.getElementById('winnerName').textContent = winnerName;
                    document.getElementById('winnerDisplay').classList.add('show');
                    
                    // สร้าง confetti
                    createConfetti();
                    
                    isSpinning = false;
                } else {
                    clearInterval(spinInterval);
                    spinInterval = setInterval(() => {
                        currentNameIndex = (currentNameIndex + 1) % dummyNames.length;
                        document.getElementById('nameScroll').textContent = dummyNames[currentNameIndex];
                    }, spinSpeed);
                    
                    setTimeout(slowDown, 100);
                }
            };
            
            slowDown();
        }
        
        // ฟังก์ชันสร้าง confetti
        function createConfetti() {
            const confettiContainer = document.body;
            const colors = ['#ffd700', '#ff0000', '#00ff00', '#0000ff', '#ff00ff', '#00ffff'];
            
            for (let i = 0; i < 100; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = `${Math.random() * 100}%`;
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.width = `${Math.random() * 10 + 5}px`;
                confetti.style.height = `${Math.random() * 10 + 5}px`;
                confetti.style.animationDuration = `${Math.random() * 3 + 2}s`;
                confetti.style.animationDelay = `${Math.random() * 2}s`;
                
                confettiContainer.appendChild(confetti);
                
                // ลบ confetti หลังจากจบแอนิเมชัน
                setTimeout(() => {
                    confetti.remove();
                }, 5000);
            }
        }
        
        // ฟังก์ชันเพิ่มผู้โชคดีในรายการ
        function addWinnerToHistory(winner, reward) {
            // เพิ่มผู้โชคดีใหม่ไว้ด้านบน
            winners.unshift({ name: winner, reward: reward });
            
            // แสดงเฉพาะ 5 รายการล่าสุด
            if (winners.length > 5) {
                winners.pop();
            }
            
            // อัปเดตรายการผู้โชคดี
            const historyList = document.getElementById('winnersHistoryList');
            historyList.innerHTML = '';
            
            winners.forEach(win => {
                const li = document.createElement('li');
                li.innerHTML = `
                    <div class="winner-name">${win.name}</div>
                    <div class="reward-name">${win.reward}</div>
                `;
                historyList.appendChild(li);
            });
        }
        
        // รับข้อมูลจากหน้า Admin
        window.addEventListener('message', function(event) {
            if (event.data && event.data.type === 'winner') {
                const data = event.data.data;
                
                if (data.success) {
                    finalWinnerName = data.winner.name;
                    finalRewardName = data.reward.name;
                    
                    // แสดงข้อมูลรางวัล
                    document.getElementById('rewardInfo').textContent = `รางวัล: ${finalRewardName}`;
                    
                    // เริ่มการสุ่ม
                    startSpinning();
                    
                    // หยุดการสุ่มหลังจาก 3 วินาที
                    setTimeout(() => {
                        stopSpinning(finalWinnerName);
                        
                        // เพิ่มผู้โชคดีในรายการ
                        addWinnerToHistory(finalWinnerName, finalRewardName);
                    }, 3000);
                }
            }
        });
        
        // เริ่มต้นด้วยการแสดงข้อความรอการสุ่ม
        document.getElementById('nameScroll').textContent = "รอการสุ่มรางวัล...";
    </script>
</body>
</html>