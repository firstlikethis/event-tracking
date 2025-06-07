<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>สุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- SweetAlert2 สำหรับการแสดง Dialog สวยงาม -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        List<Reward> rewards = (List<Reward>) request.getAttribute("rewards");
        Map<Long, Object[]> winnersMap = (Map<Long, Object[]>) request.getAttribute("winnersMap");
    %>
    
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ระบบสุ่มรางวัล</h1>
                <div class="flex space-x-2">
                    <!-- เปลี่ยนแปลงตรงนี้: ไม่ส่ง rewardId ในลิงก์เปิดหน้าจอสุ่มรางวัล -->
                    <a href="${pageContext.request.contextPath}/lucky-draw-display" target="_blank" 
                       class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                        เปิดหน้าจอสุ่มรางวัล
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" 
                       class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">
                        กลับหน้าหลัก
                    </a>
                </div>
            </div>
            
            <div class="mb-6">
                <p class="text-lg text-gray-700 mb-4">เลือกรางวัลที่ต้องการสุ่มจากรายการด้านล่าง</p>
                
                <% if (rewards == null || rewards.isEmpty()) { %>
                    <div class="bg-yellow-100 text-yellow-800 p-4 rounded-md">
                        <p>ไม่พบรางวัลที่สามารถสุ่มได้ กรุณาเพิ่มรางวัลประเภท "สำหรับลุ้น" ก่อน</p>
                    </div>
                <% } else { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% for (Reward reward : rewards) { %>
                            <div class="bg-white border rounded-lg shadow-sm p-6 hover:shadow-md transition-shadow">
                                <h3 class="text-xl font-semibold mb-2 text-purple-700"><%= reward.getRewardName() %></h3>
                                <p class="text-gray-600 mb-3"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
                                
                                <div class="flex items-center justify-between mb-3">
                                    <span class="text-sm font-medium text-gray-600">คะแนนที่ต้องใช้:</span>
                                    <span class="text-lg font-bold text-purple-600"><%= reward.getPointsRequired() %></span>
                                </div>
                                
                                <div class="flex items-center justify-between mb-4">
                                    <span class="text-sm font-medium text-gray-600">จำนวนคงเหลือ:</span>
                                    <span class="text-lg font-bold <%= reward.getRemaining() > 0 ? "text-green-600" : "text-red-600" %>">
                                        <%= reward.getRemaining() %>/<%= reward.getQuantity() %>
                                    </span>
                                </div>
                                
                                <% 
                                    boolean hasWinners = winnersMap != null && winnersMap.containsKey(reward.getRewardId());
                                    String latestWinnerName = "";
                                    int winnersCount = 0;
                                    
                                    if (hasWinners) {
                                        Object[] winnerInfo = winnersMap.get(reward.getRewardId());
                                        latestWinnerName = (String) winnerInfo[0];
                                        winnersCount = (Integer) winnerInfo[1];
                                    }
                                %>
                                
                                <% if (hasWinners) { %>
                                    <div class="bg-blue-50 p-3 rounded-md mb-4">
                                        <p class="text-sm text-blue-800">
                                            <span class="font-medium">ผู้โชคดีล่าสุด:</span> <%= latestWinnerName %>
                                        </p>
                                        <p class="text-xs text-blue-600">
                                            มีผู้ได้รับรางวัลนี้แล้ว <%= winnersCount %> คน
                                        </p>
                                    </div>
                                <% } %>
                                
                                <% if (reward.getRemaining() > 0) { %>
                                    <div class="flex flex-col space-y-2">
                                        <!-- เปลี่ยนจาก <a> เป็น <button> และเรียกใช้ฟังก์ชัน startLuckyDraw แทน -->
                                        <button onclick="startLuckyDraw(<%= reward.getRewardId() %>)" 
                                                class="px-4 py-2 bg-purple-600 text-white text-center rounded-md hover:bg-purple-700 transition-colors">
                                            สุ่มผู้โชคดี
                                        </button>
                                        
                                        <button onclick="viewWinners(<%= reward.getRewardId() %>, '<%= reward.getRewardName() %>')" 
                                                class="px-4 py-2 bg-green-500 text-white text-center rounded-md hover:bg-green-600 transition-colors">
                                            ดูรายชื่อผู้โชคดี
                                        </button>
                                    </div>
                                <% } else { %>
                                    <div class="flex flex-col space-y-2">
                                        <button disabled class="px-4 py-2 bg-gray-300 text-gray-500 text-center rounded-md cursor-not-allowed">
                                            หมดรางวัลแล้ว
                                        </button>
                                        
                                        <button onclick="viewWinners(<%= reward.getRewardId() %>, '<%= reward.getRewardName() %>')" 
                                                class="px-4 py-2 bg-green-500 text-white text-center rounded-md hover:bg-green-600 transition-colors">
                                            ดูรายชื่อผู้โชคดี
                                        </button>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Modal สำหรับแสดงรายชื่อผู้โชคดี -->
    <div id="winnersModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
        <div class="bg-white rounded-lg shadow-lg max-w-lg w-full p-6">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold" id="modalTitle">รายชื่อผู้โชคดี</h3>
                <button onclick="closeModal()" class="text-gray-500 hover:text-gray-700">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
            
            <div class="max-h-96 overflow-y-auto" id="modalContent">
                <div class="flex justify-center items-center h-32">
                    <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-purple-500"></div>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end">
                <button onclick="closeModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">
                    ปิด
                </button>
            </div>
        </div>
    </div>
    
    <script>
        // ฟังก์ชันใหม่สำหรับเริ่มการสุ่มรางวัล
        function startLuckyDraw(rewardId) {
            Swal.fire({
                title: 'ยืนยันการสุ่มรางวัล',
                text: 'คุณต้องการเริ่มการสุ่มรางวัลนี้ใช่หรือไม่?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'ใช่, เริ่มสุ่มรางวัล',
                cancelButtonText: 'ยกเลิก',
                confirmButtonColor: '#10B981',
                cancelButtonColor: '#EF4444'
            }).then((result) => {
                if (result.isConfirmed) {
                    // แจ้ง API ว่าเริ่มการสุ่ม
                    fetch('${pageContext.request.contextPath}/api/start-draw?rewardId=' + rewardId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                // ไปยังหน้าผลการสุ่มรางวัล
                                window.location.href = '${pageContext.request.contextPath}/lucky-draw-result?rewardId=' + rewardId;
                            } else {
                                Swal.fire(
                                    'เกิดข้อผิดพลาด',
                                    data.message || 'ไม่สามารถเริ่มการสุ่มรางวัลได้',
                                    'error'
                                );
                            }
                        })
                        .catch(error => {
                            console.error('Error starting draw:', error);
                            Swal.fire(
                                'เกิดข้อผิดพลาด',
                                'ไม่สามารถเริ่มการสุ่มรางวัลได้ กรุณาลองใหม่อีกครั้ง',
                                'error'
                            );
                        });
                }
            });
        }

        function viewWinners(rewardId, rewardName) {
                const modal = document.getElementById('winnersModal');
                const modalTitle = document.getElementById('modalTitle');
                const modalContent = document.getElementById('modalContent');
                
                // แสดง Modal
                modal.classList.remove('hidden');
                
                // กำหนดชื่อรางวัล
                modalTitle.textContent = `รายชื่อผู้โชคดี - ${rewardName}`;
                
                // แสดง Loading
                modalContent.innerHTML = `
                    <div class="flex justify-center items-center h-32">
                        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-purple-500"></div>
                    </div>
                `;
                
                // ดึงข้อมูลผู้โชคดี
                fetch(`${pageContext.request.contextPath}/api/get-winners?rewardId=${rewardId}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.winners && data.winners.length > 0) {
                            let html = `
                                <div class="overflow-x-auto">
                                    <table class="min-w-full bg-white">
                                        <thead class="bg-gray-100">
                                            <tr>
                                                <th class="py-2 px-4 border-b text-left">ชื่อผู้โชคดี</th>
                                                <th class="py-2 px-4 border-b text-center">วันที่ได้รับ</th>
                                                <th class="py-2 px-4 border-b text-center">สถานะ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            `;
                            
                            data.winners.forEach(winner => {
                                html += `
                                    <tr class="hover:bg-gray-50">
                                        <td class="py-2 px-4 border-b">${winner.visitorName}</td>
                                        <td class="py-2 px-4 border-b text-center">${winner.claimDate}</td>
                                        <td class="py-2 px-4 border-b text-center">
                                            ${winner.isReceived == '1' 
                                                ? '<span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">รับแล้ว</span>' 
                                                : '<span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">รอรับ</span>'}
                                        </td>
                                    </tr>
                                `;
                            });
                            
                            html += `
                                        </tbody>
                                    </table>
                                </div>
                            `;
                            
                            modalContent.innerHTML = html;
                        } else {
                            modalContent.innerHTML = `
                                <div class="p-4 bg-yellow-100 text-yellow-800 rounded-md">
                                    <p>ยังไม่มีผู้โชคดีได้รับรางวัลนี้</p>
                                </div>
                            `;
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        modalContent.innerHTML = `
                            <div class="p-4 bg-red-100 text-red-800 rounded-md">
                                <p>เกิดข้อผิดพลาดในการดึงข้อมูล</p>
                            </div>
                        `;
                    });
            }
        
        function closeModal() {
            const modal = document.getElementById('winnersModal');
            modal.classList.add('hidden');
        }
    </script>
</body>
</html>