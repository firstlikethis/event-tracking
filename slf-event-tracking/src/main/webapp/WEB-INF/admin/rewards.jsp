<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>จัดการรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        List<Reward> rewards = (List<Reward>) request.getAttribute("rewards");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">จัดการรางวัล</h1>
                <a href="${pageContext.request.contextPath}/admin/reward-form" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">เพิ่มรางวัลใหม่</a>
            </div>
            
            <% if (rewards == null || rewards.isEmpty()) { %>
                <p class="text-gray-500 text-center py-4">ยังไม่มีรางวัลในระบบ</p>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="py-3 px-4 border-b text-left">ชื่อรางวัล</th>
                                <th class="py-3 px-4 border-b text-center">ประเภท</th>
                                <th class="py-3 px-4 border-b text-center">คะแนนที่ใช้</th>
                                <th class="py-3 px-4 border-b text-center">จำนวนคงเหลือ</th>
                                <th class="py-3 px-4 border-b text-center">สถานะ</th>
                                <th class="py-3 px-4 border-b text-center">การจัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reward reward : rewards) { %>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-2 px-4 border-b">
                                        <div>
                                            <p class="font-medium"><%= reward.getRewardName() %></p>
                                            <p class="text-gray-500 text-sm"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
                                        </div>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <% if ("1".equals(reward.getRewardType())) { %>
                                            <span class="px-2 py-1 bg-purple-100 text-purple-800 rounded-full text-xs">สำหรับลุ้น</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">แลกทันที</span>
                                        <% } %>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center"><%= reward.getPointsRequired() %></td>
                                    <td class="py-2 px-4 border-b text-center"><%= reward.getRemaining() %>/<%= reward.getQuantity() %></td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <% if ("1".equals(reward.getIsActive())) { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs">ใช้งาน</span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs">ไม่ใช้งาน</span>
                                        <% } %>
                                    </td>
                                    <td class="py-2 px-4 border-b text-center">
                                        <div class="flex justify-center space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/reward-form?id=<%= reward.getRewardId() %>" 
                                               class="px-3 py-1 bg-blue-100 text-blue-800 rounded hover:bg-blue-200">
                                                แก้ไข
                                            </a>
                                            <a href="#" onclick="confirmDelete(<%= reward.getRewardId() %>, '<%= reward.getRewardName() %>')" 
                                               class="px-3 py-1 bg-red-100 text-red-800 rounded hover:bg-red-200">
                                                ลบ
                                            </a>
                                        </div>
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
        function confirmDelete(id, name) {
            if (confirm("คุณต้องการลบรางวัล '" + name + "' ใช่หรือไม่?")) {
                window.location.href = "${pageContext.request.contextPath}/admin/delete-reward?id=" + id;
            }
        }
    </script>
</body>
</html>