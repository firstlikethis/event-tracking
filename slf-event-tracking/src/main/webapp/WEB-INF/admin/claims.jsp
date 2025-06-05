<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.RewardClaim" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>จัดการการรับรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        List<RewardClaim> claims = (List<RewardClaim>) request.getAttribute("claims");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">จัดการการรับรางวัล</h1>
            </div>
            
            <% if (claims == null || claims.isEmpty()) { %>
                <p class="text-gray-500 text-center py-4">ไม่มีรางวัลที่รอรับในขณะนี้</p>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="py-3 px-4 border-b text-left">ผู้รับรางวัล</th>
                                <th class="py-3 px-4 border-b text-left">รางวัล</th>
                                <th class="py-3 px-4 border-b text-center">ประเภท</th>
                                <th class="py-3 px-4 border-b text-center">คะแนนที่ใช้</th>
                                <th class="py-3 px-4 border-b text-center">วันที่แลก</th>
                                <th class="py-3 px-4 border-b text-center">การจัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (RewardClaim claim : claims) { %>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-2 px-4 border-b"><%= claim.getVisitorName() %></td>
                                    <td class="py-2 px-4 border-b"><%= claim.getRewardName() %></td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <% if ("1".equals(claim.getIsLuckyDraw())) { %>
                                            <span class="px-2 py-1 bg-purple-100 text-purple-800 rounded-full text-xs">ลุ้นรางวัล</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">แลกทันที</span>
                                        <% } %>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center"><%= claim.getPointsUsed() %></td>
                                    <td class="py-2 px-4 border-b text-center"><%= dateFormat.format(claim.getClaimDate()) %></td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <a href="#" onclick="confirmMarkReceived(<%= claim.getClaimId() %>, '<%= claim.getVisitorName() %>', '<%= claim.getRewardName() %>')" 
                                           class="px-3 py-1 bg-green-100 text-green-800 rounded hover:bg-green-200">
                                            บันทึกการรับรางวัล
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function confirmMarkReceived(id, visitorName, rewardName) {
            if (confirm("ยืนยันว่า " + visitorName + " ได้รับรางวัล '" + rewardName + "' แล้ว?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/mark-received?id=" + id;
            }
        }
    </script>
</body>
</html>