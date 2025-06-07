<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Reward" %>
<%@ page import="th.or.studentloan.event.model.Visitor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ผลการสุ่มรางวัล - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-gray-100 min-h-screen">
    <% 
        Reward reward = (Reward) request.getAttribute("reward");
        Visitor winner = (Visitor) request.getAttribute("winner");
        Boolean success = (Boolean) request.getAttribute("success");
        Boolean noMoreRewards = (Boolean) request.getAttribute("noMoreRewards");
        Boolean noEligibleParticipants = (Boolean) request.getAttribute("noEligibleParticipants");
    %>

    <jsp:include page="include/nav.jsp" />
    
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6 mb-8 max-w-2xl mx-auto">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">ผลการสุ่มรางวัล</h1>
                <a href="<%=request.getContextPath()%>/lucky-draw" class="text-purple-600 hover:text-purple-800">
                    กลับไปหน้าสุ่มรางวัล
                </a>
            </div>
            
            <% if (reward != null) { %>
                <div class="mb-6 p-4 bg-purple-50 rounded-lg">
                    <h2 class="text-xl font-semibold text-purple-800 mb-2"><%= reward.getRewardName() %></h2>
                    <p class="text-gray-600"><%= reward.getRewardDescription() != null ? reward.getRewardDescription() : "" %></p>
                    <div class="mt-2 flex space-x-4">
                        <div class="text-sm text-gray-500">คะแนนที่ต้องใช้: <span class="font-medium text-gray-700"><%= reward.getPointsRequired() %></span></div>
                        <div class="text-sm text-gray-500">คงเหลือ: <span class="font-medium text-gray-700"><%= reward.getRemaining() - 1 %>/<%= reward.getQuantity() %></span></div>
                    </div>
                </div>
            <% } %>
            
            <% if (noMoreRewards != null && noMoreRewards) { %>
                <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700">
                                รางวัลนี้หมดแล้ว ไม่สามารถสุ่มได้อีก
                            </p>
                        </div>
                    </div>
                </div>
            <% } else if (noEligibleParticipants != null && noEligibleParticipants) { %>
                <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 mb-6">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-yellow-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-yellow-700">
                                ไม่พบผู้เข้าร่วมที่มีสิทธิ์รับรางวัลนี้ (อาจมีคะแนนไม่ถึงเกณฑ์ หรือไม่อยู่ในประเภทที่กำหนด)
                            </p>
                        </div>
                    </div>
                </div>
            <% } else if (winner != null) { %>
                <div class="bg-green-50 p-6 rounded-lg text-center mb-6">
                    <h3 class="text-lg font-medium text-green-800 mb-4">ผู้โชคดีได้แก่</h3>
                    <div class="bg-white rounded-lg border border-green-200 p-6 shadow-sm">
                        <div class="text-3xl font-bold text-green-700 mb-2"><%= winner.getFullname() %></div>
                        <div class="text-lg text-gray-600 mb-4">
                            <% 
                                String phone = winner.getPhoneNumber();
                                String maskedPhone = phone.substring(0, phone.length() - 4).replaceAll("\\d", "x") + 
                                                   phone.substring(phone.length() - 4);
                            %>
                            <%= maskedPhone %>
                        </div>
                        <div class="flex justify-center">
                            <div class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full">
                                ผู้เข้าร่วมประเภท: <%= getVisitorTypeName(winner.getVisitorType()) %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-6">
                        <div class="text-sm text-gray-500 mb-2">สถานะการบันทึกผล:</div>
                        <% if (success != null && success) { %>
                            <div class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full inline-block">
                                บันทึกข้อมูลเรียบร้อยแล้ว
                            </div>
                        <% } else { %>
                            <div class="bg-red-100 text-red-800 text-sm font-medium px-3 py-1 rounded-full inline-block">
                                เกิดข้อผิดพลาดในการบันทึกข้อมูล
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <div class="flex justify-center mt-8">
                    <a href="<%=request.getContextPath()%>/lucky-draw" class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded mr-2">
                        กลับไปหน้าสุ่มรางวัล
                    </a>
                    <button onclick="markAsReceived(<%= reward.getRewardId() %>, <%= winner.getVisitorId() %>)" class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded">
                        บันทึกว่าได้รับรางวัลแล้ว
                    </button>
                </div>
            <% } else { %>
                <div class="bg-red-50 border-l-4 border-red-500 p-4">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700">
                                เกิดข้อผิดพลาดในการสุ่มรางวัล กรุณาลองใหม่อีกครั้ง
                            </p>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function markAsReceived(rewardId, visitorId) {
            Swal.fire({
                title: 'ยืนยันการรับรางวัล',
                text: 'คุณต้องการบันทึกว่าผู้โชคดีได้รับรางวัลแล้วใช่หรือไม่?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'ใช่, บันทึกการรับรางวัล',
                cancelButtonText: 'ยกเลิก',
                confirmButtonColor: '#10B981',
                cancelButtonColor: '#6B7280'
            }).then((result) => {
                if (result.isConfirmed) {
                    // ส่งข้อมูลไปยัง API เพื่อบันทึกการรับรางวัล
                    fetch('<%=request.getContextPath()%>/api/mark-reward-received', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `rewardId=${rewardId}&visitorId=${visitorId}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire(
                                'สำเร็จ!',
                                'บันทึกการรับรางวัลเรียบร้อยแล้ว',
                                'success'
                            ).then(() => {
                                window.location.href = '<%=request.getContextPath()%>/lucky-draw';
                            });
                        } else {
                            Swal.fire(
                                'เกิดข้อผิดพลาด',
                                data.message || 'ไม่สามารถบันทึกการรับรางวัลได้',
                                'error'
                            );
                        }
                    })
                    .catch(error => {
                        console.error('Error marking reward as received:', error);
                        Swal.fire(
                            'เกิดข้อผิดพลาด',
                            'ไม่สามารถบันทึกการรับรางวัลได้ กรุณาลองใหม่อีกครั้ง',
                            'error'
                        );
                    });
                }
            });
        }
    </script>
    
    <%!
        // Helper method to get visitor type name
        private String getVisitorTypeName(String visitorType) {
            switch (visitorType) {
                case "1": return "นักเรียน/นักศึกษา (ทั่วไป)";
                case "2": return "นักเรียน/นักศึกษา (ผู้กู้ยืม กยศ.)";
                case "3": return "บุคคลทั่วไป";
                case "4": return "อาจารย์/บุคลากรทางการศึกษา";
                case "5": return "องค์กรนายจ้าง";
                case "6": return "ผู้บริหาร";
                default: return "ไม่ระบุ";
            }
        }
    %>
</body>
</html>