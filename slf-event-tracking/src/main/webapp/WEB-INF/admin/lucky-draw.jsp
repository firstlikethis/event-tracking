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
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        List<Reward> rewards = (List<Reward>) request.getAttribute("rewards");
        Integer minPoints = (Integer) request.getAttribute("minPoints");
        List<RewardClaim> winnersHistory = (List<RewardClaim>) request.getAttribute("winnersHistory");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">สุ่มรางวัล</h1>
                <button id="openDisplayBtn" class="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700">
                    เปิดหน้าจอแสดงผล
                </button>
            </div>
            
            <div id="alertContainer" class="mb-6 hidden">
                <!-- Alert messages will be displayed here -->
            </div>
            
            <% if (rewards == null || rewards.isEmpty()) { %>
                <div class="bg-yellow-100 text-yellow-800 p-4 rounded-md mb-6">
                    <p>ไม่พบรางวัลสำหรับการสุ่ม กรุณาตรวจสอบการตั้งค่ารางวัลในระบบ</p>
                    <p class="mt-2">1. ต้องเป็นรางวัลประเภท "สำหรับลุ้น" (ประเภท 1)</p>
                    <p>2. ต้องมีจำนวนรางวัลคงเหลือมากกว่า 0</p>
                    <p>3. ต้องเป็นรางวัลที่เปิดใช้งาน</p>
                </div>
            <% } else { %>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- รางวัลที่จะสุ่ม -->
                    <div class="bg-white border rounded-lg shadow p-6">
                        <h2 class="text-lg font-semibold text-gray-800 mb-4">รางวัลที่จะสุ่ม</h2>
                        
                        <div class="space-y-4">
                            <div class="mb-4">
                                <label for="rewardSelect" class="block text-sm font-medium text-gray-700 mb-2">เลือกรางวัล:</label>
                                <select id="rewardSelect" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                                    <% for (Reward reward : rewards) { %>
                                        <option value="<%= reward.getRewardId() %>" data-points="<%= reward.getPointsRequired() %>">
                                            <%= reward.getRewardName() %> (เหลือ <%= reward.getRemaining() %> รางวัล)
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            
                            <div class="mb-4">
                                <label for="minPointsInput" class="block text-sm font-medium text-gray-700 mb-2">คะแนนขั้นต่ำในการลุ้นรางวัล:</label>
                                <input type="number" id="minPointsInput" value="<%= minPoints %>" min="0" 
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                                <p class="mt-1 text-sm text-gray-500">ผู้เข้าร่วมที่มีคะแนนมากกว่าหรือเท่ากับคะแนนขั้นต่ำนี้จะมีสิทธิ์ลุ้นรางวัล</p>
                            </div>

                            <div class="mb-4">
                                <p class="text-sm text-gray-500 mb-2">หมายเหตุ: เฉพาะผู้เข้าร่วมประเภทต่อไปนี้เท่านั้นที่มีสิทธิ์ลุ้นรางวัล</p>
                                <ul class="list-disc pl-5 text-sm text-gray-500">
                                    <li>นักเรียน/นักศึกษา (ทั่วไป)</li>
                                    <li>นักเรียน/นักศึกษา (ผู้กู้ยืม กยศ.)</li>
                                    <li>บุคคลทั่วไป</li>
                                    <li>อาจารย์/บุคลากรทางการศึกษา</li>
                                </ul>
                            </div>
                            
                            <button id="drawBtn" class="w-full py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                                สุ่มผู้โชคดี
                            </button>
                        </div>
                    </div>
                    
                    <!-- ผู้โชคดีล่าสุด -->
                    <div class="bg-white border rounded-lg shadow p-6">
                        <h2 class="text-lg font-semibold text-gray-800 mb-4">ผู้โชคดีล่าสุด</h2>
                        
                        <div id="latestWinnerContainer" class="p-4 bg-gray-50 rounded-md mb-4">
                            <p class="text-gray-500 text-center">ยังไม่มีการสุ่มรางวัล</p>
                        </div>
                    </div>
                </div>
                
                <!-- ประวัติการสุ่มรางวัล -->
                <div class="bg-white border rounded-lg shadow p-6">
                    <h2 class="text-lg font-semibold text-gray-800 mb-4">ประวัติการสุ่มรางวัล</h2>
                    
                    <div id="winnersHistoryContainer" class="overflow-x-auto">
                        <table class="min-w-full bg-white">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="py-2 px-4 border-b text-left">ผู้โชคดี</th>
                                    <th class="py-2 px-4 border-b text-left">รางวัล</th>
                                    <th class="py-2 px-4 border-b text-center">คะแนนที่ใช้</th>
                                    <th class="py-2 px-4 border-b text-center">เวลา</th>
                                    <th class="py-2 px-4 border-b text-center">สถานะ</th>
                                </tr>
                            </thead>
                            <tbody id="winnersHistoryBody">
                                <% if (winnersHistory == null || winnersHistory.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="py-4 text-center text-gray-500">ไม่พบประวัติการสุ่มรางวัล</td>
                                    </tr>
                                <% } else { %>
                                    <% for (RewardClaim claim : winnersHistory) { %>
                                        <tr class="hover:bg-gray-50">
                                            <td class="py-2 px-4 border-b"><%= claim.getVisitorName() %></td>
                                            <td class="py-2 px-4 border-b"><%= claim.getRewardName() %></td>
                                            <td class="py-2 px-4 border-b text-center"><%= claim.getPointsUsed() %></td>
                                            <td class="py-2 px-4 border-b text-center"><%= dateFormat.format(claim.getClaimDate()) %></td>
                                            <td class="py-2 px-4 border-b text-center">
                                                <% if ("1".equals(claim.getIsReceived())) { %>
                                                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">รับแล้ว</span>
                                                <% } else { %>
                                                    <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">รอรับรางวัล</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        let displayWindow = null;
        
        // เปิดหน้าจอแสดงผล
        document.getElementById('openDisplayBtn').addEventListener('click', function() {
            // เปิดหน้าจอแสดงผลในแท็บใหม่
            displayWindow = window.open("${pageContext.request.contextPath}/admin/lucky-draw-display", "display", "width=1024,height=768");
        });
        
        // สุ่มผู้โชคดี
        document.getElementById('drawBtn').addEventListener('click', function() {
            // ตรวจสอบว่าเปิดหน้าจอแสดงผลแล้วหรือยัง
            if (!displayWindow || displayWindow.closed) {
                alert("กรุณาเปิดหน้าจอแสดงผลก่อนสุ่มรางวัล");
                return;
            }
            
            const rewardId = document.getElementById('rewardSelect').value;
            const minPoints = document.getElementById('minPointsInput').value;
            
            // ปิดปุ่มระหว่างการสุ่ม
            document.getElementById('drawBtn').disabled = true;
            document.getElementById('drawBtn').textContent = "กำลังสุ่ม...";
            
            // ส่งข้อมูลไปยัง Controller
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/perform-lucky-draw",
                type: "POST",
                data: {
                    rewardId: rewardId,
                    minPoints: minPoints
                },
                success: function(response) {
                    if (response.success) {
                        // แสดงผู้โชคดีล่าสุด
                        document.getElementById('latestWinnerContainer').innerHTML = `
                            <div class="text-center">
                                <h3 class="text-xl font-bold text-green-800 mb-2">ยินดีด้วย!</h3>
                                <p class="text-lg font-semibold mb-1">${response.winner.name}</p>
                                <p class="text-gray-600 mb-2">เบอร์โทร: ${response.winner.phone}</p>
                                <div class="bg-blue-50 p-3 rounded-md">
                                    <p class="font-medium">รางวัล: ${response.reward.name}</p>
                                    <p>คะแนนที่ใช้: ${response.reward.points} คะแนน</p>
                                </div>
                            </div>
                        `;
                        
                        // แสดงข้อความแจ้งเตือน
                        document.getElementById('alertContainer').innerHTML = `
                            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded" role="alert">
                                <p class="font-bold">สุ่มรางวัลสำเร็จ!</p>
                                <p>ผู้โชคดี: ${response.winner.name}</p>
                            </div>
                        `;
                        document.getElementById('alertContainer').classList.remove('hidden');
                        
                        // ส่งข้อมูลไปยังหน้าจอแสดงผล
                        if (displayWindow && !displayWindow.closed) {
                            displayWindow.postMessage({
                                type: 'winner',
                                data: response
                            }, '*');
                        }
                        
                        // โหลดหน้าเพื่ออัปเดตประวัติการสุ่มรางวัล
                        setTimeout(function() {
                            window.location.reload();
                        }, 3000);
                        
                    } else {
                        // แสดงข้อความแจ้งเตือนกรณีสุ่มไม่สำเร็จ
                        document.getElementById('alertContainer').innerHTML = `
                            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded" role="alert">
                                <p class="font-bold">สุ่มรางวัลไม่สำเร็จ!</p>
                                <p>${response.message}</p>
                            </div>
                        `;
                        document.getElementById('alertContainer').classList.remove('hidden');
                        
                        // เปิดปุ่มอีกครั้ง
                        document.getElementById('drawBtn').disabled = false;
                        document.getElementById('drawBtn').textContent = "สุ่มผู้โชคดี";
                    }
                },
                error: function(xhr, status, error) {
                    // แสดงข้อความแจ้งเตือนกรณีเกิดข้อผิดพลาด
                    document.getElementById('alertContainer').innerHTML = `
                        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded" role="alert">
                            <p class="font-bold">เกิดข้อผิดพลาด!</p>
                            <p>ไม่สามารถสุ่มรางวัลได้ กรุณาลองใหม่อีกครั้ง</p>
                        </div>
                    `;
                    document.getElementById('alertContainer').classList.remove('hidden');
                    
                    // เปิดปุ่มอีกครั้ง
                    document.getElementById('drawBtn').disabled = false;
                    document.getElementById('drawBtn').textContent = "สุ่มผู้โชคดี";
                }
            });
        });
    </script>
</body>
</html>