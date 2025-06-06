<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="th.or.studentloan.event.model.RewardClaim" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>สุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <%
        List<Reward> rewards = (List<Reward>) request.getAttribute("rewards");
        Reward selectedReward = (Reward) request.getAttribute("selectedReward");
        List<RewardClaim> winners = (List<RewardClaim>) request.getAttribute("winners");
        Boolean noMoreRewards = (Boolean) request.getAttribute("noMoreRewards");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ระบบสุ่มรางวัล</h1>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับหน้าหลัก</a>
            </div>
            
            <div class="mb-8">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">เลือกรางวัลที่ต้องการสุ่ม</h2>
                <form action="${pageContext.request.contextPath}/lucky-draw" method="get" class="mb-6">
                    <div class="flex flex-col md:flex-row space-y-4 md:space-y-0 md:space-x-4">
                        <div class="flex-grow">
                            <select id="rewardId" name="rewardId" required
                                   class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                                <option value="">-- เลือกรางวัล --</option>
                                <% if (rewards != null) { %>
                                    <% for (Reward reward : rewards) { %>
                                        <option value="<%= reward.getRewardId() %>" <%= selectedReward != null && selectedReward.getRewardId().equals(reward.getRewardId()) ? "selected" : "" %>>
                                            <%= reward.getRewardName() %> (<%= reward.getPointsRequired() %> คะแนน) - เหลือ <%= reward.getRemaining() %>
                                        </option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">เลือก</button>
                        </div>
                    </div>
                </form>
            </div>
            
            <% if (selectedReward != null) { %>
                <div class="bg-gray-50 p-6 rounded-lg shadow mb-8">
                    <h2 class="text-xl font-bold text-gray-800 mb-4">รางวัล: <%= selectedReward.getRewardName() %></h2>
                    <div class="mb-4">
                        <p class="text-gray-600 mb-2"><%= selectedReward.getRewardDescription() != null ? selectedReward.getRewardDescription() : "" %></p>
                        <p class="font-medium">คะแนนที่ต้องใช้: <span class="text-blue-600"><%= selectedReward.getPointsRequired() %> คะแนน</span></p>
                        <p class="font-medium">จำนวนคงเหลือ: <span class="text-green-600"><%= selectedReward.getRemaining() %> รางวัล</span></p>
                    </div>
                    
                    <!-- เพิ่มส่วนของปุ่มสำหรับเปิดหน้าจอ Display -->
                    <div class="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
                        <h3 class="text-lg font-semibold text-blue-800 mb-2">เตรียมหน้าจอแสดงผล</h3>
                        <p class="text-blue-600 mb-4">กดปุ่มด้านล่างเพื่อเปิดหน้าจอแสดงผลสำหรับการสุ่มรางวัลบนจอใหญ่</p>
                        <a href="${pageContext.request.contextPath}/lucky-draw-display?rewardId=<%= selectedReward.getRewardId() %>" 
                           target="_blank" 
                           class="px-6 py-3 bg-blue-600 text-white font-bold rounded-md hover:bg-blue-700 text-lg inline-flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                            </svg>
                            เปิดหน้าจอแสดงผลบนจอใหญ่
                        </a>
                        <p class="text-sm text-gray-500 mt-2">*เปิดหน้าจอนี้ไว้บนจอแสดงผลขนาดใหญ่ก่อนทำการสุ่มรางวัล</p>
                    </div>
                    
                    <% if (noMoreRewards != null && noMoreRewards) { %>
                        <p class="text-red-600 font-bold">รางวัลหมดแล้ว ไม่สามารถสุ่มได้</p>
                    <% } else if (selectedReward.getRemaining() > 0) { %>
                        <form action="${pageContext.request.contextPath}/lucky-draw-result" method="get">
                            <input type="hidden" name="rewardId" value="<%= selectedReward.getRewardId() %>">
                            <button type="submit" class="px-6 py-3 bg-purple-600 text-white font-bold rounded-md hover:bg-purple-700 text-lg">
                                สุ่มผู้โชคดี
                            </button>
                        </form>
                    <% } else { %>
                        <p class="text-red-600 font-bold">รางวัลหมดแล้ว ไม่สามารถสุ่มได้</p>
                    <% } %>
                </div>
                
                <% if (winners != null && !winners.isEmpty()) { %>
                    <div>
                        <h2 class="text-xl font-bold text-gray-800 mb-4">ผู้ที่ได้รับรางวัลนี้แล้ว</h2>
                        <div class="overflow-x-auto">
                            <table class="min-w-full bg-white">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="py-2 px-4 border-b text-left">ชื่อผู้ได้รับรางวัล</th>
                                        <th class="py-2 px-4 border-b text-center">สถานะ</th>
                                        <th class="py-2 px-4 border-b text-right">วันที่</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (RewardClaim winner : winners) { %>
                                        <tr class="hover:bg-gray-50">
                                            <td class="py-2 px-4 border-b"><%= winner.getVisitorName() %></td>
                                            <td class="py-2 px-4 border-b text-center">
                                                <% if ("1".equals(winner.getIsReceived())) { %>
                                                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">รับแล้ว</span>
                                                <% } else { %>
                                                    <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">รอรับ</span>
                                                <% } %>
                                            </td>
                                            <td class="py-2 px-4 border-b text-right"><%= winner.getClaimDate() %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>