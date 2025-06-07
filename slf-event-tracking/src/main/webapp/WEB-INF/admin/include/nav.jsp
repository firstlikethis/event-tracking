<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="th.or.studentloan.event.model.Admin" %>

<% Admin currentAdmin = (Admin) session.getAttribute("admin"); %>

<nav class="bg-white shadow">
    <div class="container mx-auto px-4">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <div class="flex-shrink-0 flex items-center">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-xl font-bold text-blue-600">SLF Event Admin</a>
                </div>
                <div class="ml-6 flex space-x-4">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="px-3 py-2 text-gray-700 hover:text-blue-600">หน้าหลัก</a>
                    <a href="${pageContext.request.contextPath}/admin/booths" class="px-3 py-2 text-gray-700 hover:text-blue-600">บูธ</a>
                    <a href="${pageContext.request.contextPath}/admin/rewards" class="px-3 py-2 text-gray-700 hover:text-blue-600">รางวัล</a>
                    <a href="${pageContext.request.contextPath}/admin/claims" class="px-3 py-2 text-gray-700 hover:text-blue-600">การรับรางวัล</a>
                    <a href="${pageContext.request.contextPath}/admin/lucky-draw" class="px-3 py-2 text-gray-700 hover:text-blue-600">สุ่มรางวัล</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="px-3 py-2 text-gray-700 hover:text-blue-600">ผู้ดูแลระบบ</a>
                </div>
            </div>
            <div class="flex items-center">
                <div class="flex items-center">
                    <span class="text-gray-700 mr-2"><%= currentAdmin.getFullname() %></span>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="px-3 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </div>
</nav>