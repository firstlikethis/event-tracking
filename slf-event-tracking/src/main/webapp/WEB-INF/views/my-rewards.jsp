<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Visitor" %>
<%@ page import="th.or.studentloan.event.model.RewardClaim" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>รางวัลของฉัน - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="container mx-auto px-4 py-8">
        <% 
            Visitor visitor = (Visitor) session.getAttribute("visitor");
            List<RewardClaim> myClaims = (List<RewardClaim>) request.getAttribute("myClaims");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>
        
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">รางวัลของฉัน</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/rewards" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 mr-2">แลกรางวัล</a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับหน้าหลัก</a>
                </div>
            </div>
            
            <div>
                <h2 class="text-xl font-bold text-gray-800 mb-4">ประวัติการแลกรางวัล</h2>
                
                <% if (myClaims == null || myClaims.isEmpty()) { %>
                    <p class="text-gray-500 text-center py-4">ยังไม่มีประวัติการแลกรางวัล</p>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="py-2 px-4 border-b text-left">รางวัล</th>
                                    <th class="py-2 px-4 border-b text-center">คะแนนที่ใช้</th>
                                    <th class="py-2 px-4 border-b text-center">ประเภท</th>
                                    <th class="py-2 px-4 border-b text-center">สถานะ</th>
                                    <th class="py-2 px-4 border-b text-right">วันที่</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (RewardClaim claim : myClaims) { %>
                                    <tr class="hover:bg-gray-50">
                                        <td class="py-2 px-4 border-b"><%= claim.getRewardName() %></td>
                                        <td class="py-2 px-4 border-b text-center"><%= claim.getPointsUsed() %></td>
                                        <td class="py-2 px-4 border-b text-center">
                                            <% if ("1".equals(claim.getIsLuckyDraw())) { %>
                                                <span class="px-2 py-1 bg-purple-100 text-purple-800 rounded-full text-xs">ลุ้นรางวัล</span>
                                            <% } else { %>
                                                <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">แลกทันที</span>
                                            <% } %>
                                        </td>
                                        <td class="py-2 px-4 border-b text-center">
                                            <% if ("1".equals(claim.getIsReceived())) { %>
                                                <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">รับแล้ว</span>
                                            <% } else { %>
                                                <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">รอรับ</span>
                                            <% } %>
                                        </td>
                                        <td class="py-2 px-4 border-b text-right"><%= dateFormat.format(claim.getClaimDate()) %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>