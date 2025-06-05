<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Visitor" %>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>รางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="container mx-auto px-4 py-8">
        <% 
            Visitor visitor = (Visitor) session.getAttribute("visitor");
            List<Reward> exchangeRewards = (List<Reward>) request.getAttribute("exchangeRewards");
            List<Reward> luckyDrawRewards = (List<Reward>) request.getAttribute("luckyDrawRewards");
        %>
        
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">รางวัล</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/my-rewards" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 mr-2">รางวัลของฉัน</a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300">กลับหน้าหลัก</a>
                </div>
            </div>
            
            <div class="mb-6">
                <h2 class="text-lg font-semibold text-gray-700 mb-2">คะแนนสะสม</h2>
                <div class="bg-gray-50 p-4 rounded-md">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-gray-600">คะแนนที่สะสมได้:</span>
                        <span class="text-2xl font-bold text-blue-600"><%= visitor.getTotalPoints() %> คะแนน</span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-4">
                        <div class="bg-blue-600 h-4 rounded-full" style="width: <%= Math.min(100, (visitor.getTotalPoints() / 100.0) * 100) %>%"></div>
                    </div>
                </div>
            </div>
            
            <!-- รางวัลที่สามารถแลกได้ทันที -->
            <div class="mb-8">
                <h2 class="text-xl font-bold text-gray-800 mb-4">รางวัลที่สามารถแลกได้ทันที</h2>
                
                <% if (exchangeRewards == null || exchangeRewards.isEmpty()) { %>
                    <p class="text-gray-500 text-center py-4">ไม่มีรางวัลที่สามารถแลกได้ในขณะนี้</p>
                <% } else { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% for (Reward reward : exchangeRewards) { %>
                            <div class="bg-gray-50 rounded-lg p-4 shadow">
                                <h3 class="text-lg font-semibold text-gray-800 mb-2"><%= reward.getRewardName() %></h3>
                                <p class="text-gray-600 mb-4"><%= reward.getRewardDescription() %></p>
                                <div class="flex justify-between items-center">
                                    <span class="font-bold text-blue-600"><%= reward.getPointsRequired() %> คะแนน</span>
                                    <span class="text-gray-500">เหลือ <%= reward.getRemaining() %> รางวัล</span>
                                </div>
                                
                                <% if (visitor.getTotalPoints() >= reward.getPointsRequired()) { %>
                                    <form action="${pageContext.request.contextPath}/claim-reward" method="post" class="mt-4">
                                        <input type="hidden" name="rewardId" value="<%= reward.getRewardId() %>">
                                        <input type="hidden" name="rewardType" value="<%= reward.getRewardType() %>">
                                        <button type="submit" 
                                                class="w-full py-2 px-4 bg-green-600 hover:bg-green-700 text-white font-semibold rounded-md">
                                            แลกรางวัล
                                        </button>
                                    </form>
                                <% } else { %>
                                    <button disabled 
                                            class="w-full py-2 px-4 bg-gray-400 text-white font-semibold rounded-md mt-4 cursor-not-allowed">
                                        คะแนนไม่เพียงพอ
                                    </button>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <!-- รางวัลสำหรับลุ้น -->
            <div>
                <h2 class="text-xl font-bold text-gray-800 mb-4">รางวัลสำหรับลุ้น</h2>
                
                <% if (luckyDrawRewards == null || luckyDrawRewards.isEmpty()) { %>
                    <p class="text-gray-500 text-center py-4">ไม่มีรางวัลสำหรับลุ้นในขณะนี้ หรือคุณไม่มีสิทธิ์ลุ้นรางวัล</p>
                <% } else { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% for (Reward reward : luckyDrawRewards) { %>
                            <div class="bg-gray-50 rounded-lg p-4 shadow">
                                <h3 class="text-lg font-semibold text-gray-800 mb-2"><%= reward.getRewardName() %></h3>
                                <p class="text-gray-600 mb-4"><%= reward.getRewardDescription() %></p>
                                <div class="flex justify-between items-center">
                                    <span class="font-bold text-blue-600"><%= reward.getPointsRequired() %> คะแนน</span>
                                    <span class="text-gray-500">เหลือ <%= reward.getRemaining() %> รางวัล</span>
                                </div>
                                
                                <% if (visitor.getTotalPoints() >= reward.getPointsRequired()) { %>
                                    <form action="${pageContext.request.contextPath}/claim-reward" method="post" class="mt-4">
                                        <input type="hidden" name="rewardId" value="<%= reward.getRewardId() %>">
                                        <input type="hidden" name="rewardType" value="<%= reward.getRewardType() %>">
                                        <button type="submit" 
                                                class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white font-semibold rounded-md">
                                            ใช้สิทธิ์ลุ้นรางวัล
                                        </button>
                                    </form>
                                <% } else { %>
                                    <button disabled 
                                            class="w-full py-2 px-4 bg-gray-400 text-white font-semibold rounded-md mt-4 cursor-not-allowed">
                                        คะแนนไม่เพียงพอ
                                    </button>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>