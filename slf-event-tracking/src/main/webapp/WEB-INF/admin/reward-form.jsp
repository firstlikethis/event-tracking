<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ฟอร์มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <% 
        Reward reward = (Reward) request.getAttribute("reward");
        boolean isEdit = reward != null && reward.getRewardId() != null;
    %>
    
    <!-- Admin Navigation -->
    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800"><%= isEdit ? "แก้ไขรางวัล" : "เพิ่มรางวัลใหม่" %></h1>
                <a href="${pageContext.request.contextPath}/admin/rewards" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับ</a>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/admin/save-reward" method="post" class="space-y-4">
                <% if (isEdit) { %>
                    <input type="hidden" name="rewardId" value="<%= reward.getRewardId() %>">
                <% } %>
                
                <div>
                    <label for="rewardName" class="block text-sm font-medium text-gray-700">ชื่อรางวัล *</label>
                    <input type="text" id="rewardName" name="rewardName" required
                           value="<%= isEdit ? reward.getRewardName() : "" %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="rewardDescription" class="block text-sm font-medium text-gray-700">รายละเอียด</label>
                    <textarea id="rewardDescription" name="rewardDescription" rows="3"
                              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"><%= isEdit && reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></textarea>
                </div>
                
                <div>
                    <label for="rewardType" class="block text-sm font-medium text-gray-700">ประเภทรางวัล *</label>
                    <select id="rewardType" name="rewardType" required
                            class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="">-- เลือกประเภท --</option>
                        <option value="1" <%= isEdit && "1".equals(reward.getRewardType()) ? "selected" : "" %>>สำหรับลุ้น</option>
                        <option value="2" <%= isEdit && "2".equals(reward.getRewardType()) ? "selected" : "" %>>สำหรับแลกทันที</option>
                    </select>
                </div>
                
                <div>
                    <label for="pointsRequired" class="block text-sm font-medium text-gray-700">คะแนนที่ต้องใช้ *</label>
                    <input type="number" id="pointsRequired" name="pointsRequired" required min="1"
                           value="<%= isEdit ? reward.getPointsRequired() : 10 %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="quantity" class="block text-sm font-medium text-gray-700">จำนวนทั้งหมด *</label>
                    <input type="number" id="quantity" name="quantity" required min="1"
                           value="<%= isEdit ? reward.getQuantity() : 1 %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label for="remaining" class="block text-sm font-medium text-gray-700">จำนวนคงเหลือ</label>
                    <input type="number" id="remaining" name="remaining" min="0"
                           value="<%= isEdit ? reward.getRemaining() : "" %>"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                    <p class="text-gray-500 text-sm mt-1">หากไม่ระบุ จะใช้ค่าเดียวกับจำนวนทั้งหมด</p>
                </div>
                
                <div class="flex items-center">
                    <input type="checkbox" id="isActive" name="isActive"
                           <%= isEdit && "1".equals(reward.getIsActive()) ? "checked" : "" %>
                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="isActive" class="ml-2 block text-sm text-gray-700">
                        ใช้งาน
                    </label>
                </div>
                
                <div class="pt-4">
                    <button type="submit" 
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-md">
                        <%= isEdit ? "บันทึกการแก้ไข" : "สร้างรางวัล" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>