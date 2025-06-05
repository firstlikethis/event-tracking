<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Database Connection - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans p-6">
    <div class="container mx-auto bg-white rounded-lg shadow-md p-6">
        <h1 class="text-2xl font-bold text-gray-800 mb-6">ทดสอบการเชื่อมต่อฐานข้อมูล</h1>
        
        <div class="mb-8 p-4 rounded-md">
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;
                
                try {
                    // ทดสอบเชื่อมต่อ JNDI
                    Context ctx = new InitialContext();
                    Context envContext = (Context) ctx.lookup("java:/comp/env");
                    DataSource ds = (DataSource) envContext.lookup("jdbc/SLFORA19");
                    
                    if (ds != null) {
                        conn = ds.getConnection();
                        out.println("<div class='p-4 bg-green-100 text-green-800 rounded-md mb-4'>");
                        out.println("<p><strong>✅ เชื่อมต่อ JNDI DataSource สำเร็จ!</strong></p>");
                        out.println("<p>DataSource: jdbc/SLFORA19</p>");
                        out.println("</div>");
                        
                        // ทดสอบดึงข้อมูลจากตาราง
                        stmt = conn.createStatement();
                        
                        // ทดสอบตาราง tb_admin (ถ้ามี)
                        try {
                            rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM slf_deb3.tb_admin");
                            if (rs.next()) {
                                int count = rs.getInt("count");
                                out.println("<div class='p-4 bg-blue-100 text-blue-800 rounded-md mb-4'>");
                                out.println("<p><strong>ตาราง tb_admin:</strong> พบข้อมูล " + count + " รายการ</p>");
                                out.println("</div>");
                            }
                        } catch (SQLException e) {
                            out.println("<div class='p-4 bg-yellow-100 text-yellow-800 rounded-md mb-4'>");
                            out.println("<p><strong>⚠️ ไม่พบตาราง tb_admin หรือเกิดข้อผิดพลาด</strong></p>");
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                            out.println("</div>");
                        }
                        
                        // ทดสอบตาราง tb_visitor (ถ้ามี)
                        try {
                            rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM slf_deb3.tb_visitor");
                            if (rs.next()) {
                                int count = rs.getInt("count");
                                out.println("<div class='p-4 bg-blue-100 text-blue-800 rounded-md mb-4'>");
                                out.println("<p><strong>ตาราง tb_visitor:</strong> พบข้อมูล " + count + " รายการ</p>");
                                out.println("</div>");
                            }
                        } catch (SQLException e) {
                            out.println("<div class='p-4 bg-yellow-100 text-yellow-800 rounded-md mb-4'>");
                            out.println("<p><strong>⚠️ ไม่พบตาราง tb_visitor หรือเกิดข้อผิดพลาด</strong></p>");
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                            out.println("</div>");
                        }
                        
                        // ทดสอบตาราง tb_otp (ถ้ามี)
                        try {
                            rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM slf_deb3.tb_otp");
                            if (rs.next()) {
                                int count = rs.getInt("count");
                                out.println("<div class='p-4 bg-blue-100 text-blue-800 rounded-md mb-4'>");
                                out.println("<p><strong>ตาราง tb_otp:</strong> พบข้อมูล " + count + " รายการ</p>");
                                out.println("</div>");
                            }
                        } catch (SQLException e) {
                            out.println("<div class='p-4 bg-yellow-100 text-yellow-800 rounded-md mb-4'>");
                            out.println("<p><strong>⚠️ ไม่พบตาราง tb_otp หรือเกิดข้อผิดพลาด</strong></p>");
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                            out.println("</div>");
                        }
                        
                        // ทดสอบ Database Metadata
                        DatabaseMetaData dbmd = conn.getMetaData();
                        out.println("<div class='p-4 bg-blue-100 text-blue-800 rounded-md mb-4'>");
                        out.println("<p><strong>Database Information:</strong></p>");
                        out.println("<p>Database: " + dbmd.getDatabaseProductName() + " " + dbmd.getDatabaseProductVersion() + "</p>");
                        out.println("<p>Driver: " + dbmd.getDriverName() + " " + dbmd.getDriverVersion() + "</p>");
                        out.println("<p>URL: " + dbmd.getURL() + "</p>");
                        out.println("</div>");
                        
                    } else {
                        out.println("<div class='p-4 bg-red-100 text-red-800 rounded-md mb-4'>");
                        out.println("<p><strong>❌ ไม่พบ DataSource!</strong></p>");
                        out.println("</div>");
                    }
                } catch (NamingException e) {
                    out.println("<div class='p-4 bg-red-100 text-red-800 rounded-md mb-4'>");
                    out.println("<p><strong>❌ เกิดข้อผิดพลาดในการค้นหา JNDI!</strong></p>");
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                    out.println("</div>");
                    e.printStackTrace();
                } catch (SQLException e) {
                    out.println("<div class='p-4 bg-red-100 text-red-800 rounded-md mb-4'>");
                    out.println("<p><strong>❌ เกิดข้อผิดพลาดในการเชื่อมต่อฐานข้อมูล!</strong></p>");
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                    out.println("</div>");
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) { }
                    try { if (stmt != null) stmt.close(); } catch (Exception e) { }
                    try { if (conn != null) conn.close(); } catch (Exception e) { }
                }
            %>
        </div>
        
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                กลับหน้าหลัก
            </a>
        </div>
    </div>
</body>
</html>