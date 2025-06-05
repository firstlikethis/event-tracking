<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="th.or.studentloan.event.model.Visitor" %>
<%@ page import="th.or.studentloan.event.model.VisitorLog" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="container mx-auto px-4 py-8">
        <% 
            Visitor visitor = (Visitor) session.getAttribute("visitor");
            List<VisitorLog> activityLogs = (List<VisitorLog>) request.getAttribute("activityLogs");
        %>
        
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ยินดีต้อนรับ คุณ <%= visitor.getFullname() %></h1>
                <a href="${pageContext.request.contextPath}/logout" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">ออกจากระบบ</a>
            </div>
            
            <div class="mb-6">
                <h2 class="text-lg font-semibold text-gray-700 mb-2">ข้อมูลผู้เข้าร่วม</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 p-4 bg-gray-50 rounded-md">
                    <div>
                        <p class="text-gray-600">ชื่อ-นามสกุล:</p>
                        <p class="font-medium"><%= visitor.getFullname() %></p>
                    </div>
                    <div>
                        <p class="text-gray-600">เบอร์โทรศัพท์:</p>
                        <p class="font-medium"><%= visitor.getPhoneNumber() %></p>
                    </div>
                    <div>
                        <p class="text-gray-600">อีเมล:</p>
                        <p class="font-medium"><%= visitor.getEmail() != null ? visitor.getEmail() : "-" %></p>
                    </div>
                    <div>
                        <p class="text-gray-600">ประเภทผู้เข้าร่วม:</p>
                        <p class="font-medium">
                            <% 
                                String visitorType = "";
                                switch(visitor.getVisitorType()) {
                                    case "1": visitorType = "นักเรียน/นักศึกษา (ทั่วไป)"; break;
                                    case "2": visitorType = "นักเรียน/นักศึกษา (ผู้กู้ยืม กยศ.)"; break;
                                    case "3": visitorType = "บุคคลทั่วไป"; break;
                                    case "4": visitorType = "อาจารย์/บุคลากรทางการศึกษา"; break;
                                    case "5": visitorType = "องค์กรนายจ้าง"; break;
                                    case "6": visitorType = "ผู้บริหาร"; break;
                                    default: visitorType = "-";
                                }
                                out.print(visitorType);
                            %>
                        </p>
                    </div>
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
            
            <div class="grid grid-cols-2 gap-4 mb-6">
                <a href="${pageContext.request.contextPath}/scan-qr" class="bg-blue-600 text-white py-3 px-4 rounded-md text-center font-semibold hover:bg-blue-700">
                    สแกน QR Code
                </a>
                <a href="${pageContext.request.contextPath}/rewards" class="bg-green-600 text-white py-3 px-4 rounded-md text-center font-semibold hover:bg-green-700">
                    แลกรางวัล
                </a>
            </div>
        </div>
        
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-bold text-gray-800 mb-4">ประวัติการร่วมกิจกรรม</h2>
            
            <% if (activityLogs == null || activityLogs.isEmpty()) { %>
                <p class="text-gray-500 text-center py-4">ยังไม่มีประวัติการร่วมกิจกรรม</p>
            <% } else { %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="py-2 px-4 border-b text-left">บูธ</th>
                                <th class="py-2 px-4 border-b text-center">คะแนนที่ได้</th>
                                <th class="py-2 px-4 border-b text-right">วันที่</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (VisitorLog log : activityLogs) { %>
                                <tr class="hover:bg-gray-50">
                                    <td class="py-2 px-4 border-b"><%= log.getBoothName() %></td>
                                    <td class="py-2 px-4 border-b text-center"><%= log.getPointsEarned() %></td>
                                    <td class="py-2 px-4 border-b text-right"><%= log.getScanDate() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>