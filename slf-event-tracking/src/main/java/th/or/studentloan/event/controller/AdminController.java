package th.or.studentloan.event.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.model.Admin;
import th.or.studentloan.event.model.Booth;
import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.service.AdminService;
import th.or.studentloan.event.service.BoothService;
import th.or.studentloan.event.service.RewardService;

public class AdminController extends AbstractController {
    private AdminService adminService;
    private BoothService boothService;
    private RewardService rewardService;
    
    public void setAdminService(AdminService adminService) {
        this.adminService = adminService;
    }
    
    public void setBoothService(BoothService boothService) {
        this.boothService = boothService;
    }
    
    public void setRewardService(RewardService rewardService) {
        this.rewardService = rewardService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        System.out.println("Admin Controller Path: " + path);
        
        // Admin Login
        if (path.equals("/admin")) {
            return handleAdminLogin(request);
        } else if (path.equals("/admin/logout")) {
            return handleAdminLogout(request);
        }
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        if (admin == null) {
            return new ModelAndView("redirect:/admin");
        }
        
        // Admin Dashboard
        if (path.equals("/admin/dashboard")) {
            return handleAdminDashboard(request);
        }
        
        // Booth Management
        else if (path.equals("/admin/booths")) {
            return handleBooths(request);
        } else if (path.equals("/admin/booth-form")) {
            return handleBoothForm(request);
        } else if (path.equals("/admin/save-booth")) {
            return handleSaveBooth(request);
        } else if (path.equals("/admin/delete-booth")) {
            return handleDeleteBooth(request);
        } else if (path.equals("/admin/regenerate-qr")) {
            return handleRegenerateQR(request);
        } else if (path.equals("/admin/download-qr")) {
            return handleDownloadQR(request, response);
        }
        
        // Reward Management
        else if (path.equals("/admin/rewards")) {
            return handleRewards(request);
        } else if (path.equals("/admin/reward-form")) {
            return handleRewardForm(request);
        } else if (path.equals("/admin/save-reward")) {
            return handleSaveReward(request);
        } else if (path.equals("/admin/delete-reward")) {
            return handleDeleteReward(request);
        }
        
        // Claim Management
        else if (path.equals("/admin/claims")) {
            return handleClaims(request);
        } else if (path.equals("/admin/mark-received")) {
            return handleMarkReceived(request);
        }else if (path.equals("/admin/cancel-claim")) {
            return handleCancelClaim(request);
        }
        
        // Admin Management
        else if (path.equals("/admin/users")) {
            return handleAdmins(request);
        } else if (path.equals("/admin/admin-form")) {
            return handleAdminForm(request);
        } else if (path.equals("/admin/save-admin")) {
            return handleSaveAdmin(request);
        } else if (path.equals("/admin/delete-admin")) {
            return handleDeleteAdmin(request);
        }

        

        
        return new ModelAndView("redirect:/admin/dashboard");
    }
    
    private ModelAndView handleAdminLogin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        
        // If already logged in, redirect to dashboard
        if (session.getAttribute("admin") != null) {
            return new ModelAndView("redirect:/admin/dashboard");
        }
        
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            System.out.println("Login attempt: " + username);
            
            Admin admin = adminService.login(username, password);
            
            if (admin != null) {
                session.setAttribute("admin", admin);
                return new ModelAndView("redirect:/admin/dashboard");
            }
            
            ModelAndView mv = new ModelAndView("admin/login");
            mv.addObject("error", "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง");
            return mv;
        }
        
        return new ModelAndView("admin/login");
    }
    
    private ModelAndView handleAdminLogout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        
        return new ModelAndView("redirect:/admin");
    }
    
    private ModelAndView handleAdminDashboard(HttpServletRequest request) {
        // Get counts for dashboard
        List<Booth> booths = boothService.getAllActiveBooths();
        List<Reward> rewards = rewardService.getAllActiveRewards();
        List<RewardClaim> pendingClaims = rewardService.getPendingClaims();
        
        ModelAndView mv = new ModelAndView("admin/dashboard");
        mv.addObject("boothCount", booths.size());
        mv.addObject("rewardCount", rewards.size());
        mv.addObject("pendingClaimCount", pendingClaims.size());
        
        return mv;
    }
    
    // Booth Management
    private ModelAndView handleBooths(HttpServletRequest request) {
        List<Booth> booths = boothService.getAllActiveBooths();
        
        ModelAndView mv = new ModelAndView("admin/booths");
        mv.addObject("booths", booths);
        
        return mv;
    }
    
    private ModelAndView handleBoothForm(HttpServletRequest request) {
        String boothIdStr = request.getParameter("id");
        Booth booth = null;
        
        if (boothIdStr != null && !boothIdStr.isEmpty()) {
            Long boothId = Long.parseLong(boothIdStr);
            booth = boothService.getBoothById(boothId);
        }
        
        ModelAndView mv = new ModelAndView("admin/booth-form");
        mv.addObject("booth", booth);
        
        return mv;
    }
    
    private ModelAndView handleSaveBooth(HttpServletRequest request) {
        String boothIdStr = request.getParameter("boothId");
        String boothName = request.getParameter("boothName");
        String boothDescription = request.getParameter("boothDescription");
        String pointsStr = request.getParameter("points");
        String isActive = request.getParameter("isActive");
        
        if (boothName == null || boothName.trim().isEmpty() || pointsStr == null || pointsStr.trim().isEmpty()) {
            ModelAndView mv = new ModelAndView("admin/booth-form");
            mv.addObject("error", "กรุณากรอกข้อมูลให้ครบถ้วน");
            return mv;
        }
        
        Integer points = Integer.parseInt(pointsStr);
        
        Booth booth = new Booth();
        
        if (boothIdStr != null && !boothIdStr.isEmpty()) {
            Long boothId = Long.parseLong(boothIdStr);
            booth = boothService.getBoothById(boothId);
        }
        
        booth.setBoothName(boothName);
        booth.setBoothDescription(boothDescription);
        booth.setPoints(points);
        booth.setIsActive(isActive != null ? "1" : "0");
        
        if (booth.getBoothId() == null) {
            boothService.createBooth(booth);
        } else {
            boothService.updateBooth(booth);
        }
        
        return new ModelAndView("redirect:/admin/booths");
    }
    
    private ModelAndView handleDeleteBooth(HttpServletRequest request) {
        String boothIdStr = request.getParameter("id");
        
        if (boothIdStr != null && !boothIdStr.isEmpty()) {
            Long boothId = Long.parseLong(boothIdStr);
            boothService.deleteBooth(boothId);
        }
        
        return new ModelAndView("redirect:/admin/booths");
    }
    
    // เพิ่มเมธอดสำหรับสร้าง QR Code ใหม่
    private ModelAndView handleRegenerateQR(HttpServletRequest request) {
        String boothIdStr = request.getParameter("id");
        
        if (boothIdStr != null && !boothIdStr.isEmpty()) {
            Long boothId = Long.parseLong(boothIdStr);
            Booth booth = boothService.getBoothById(boothId);
            
            if (booth != null) {
                String qrCodeUrl = boothService.regenerateQRCode(boothId);
                booth.setQrCodeUrl(qrCodeUrl);
                boothService.updateBooth(booth);
            }
        }
        
        // ถ้ามาจากหน้าฟอร์ม กลับไปที่ฟอร์ม
        String fromForm = request.getParameter("fromForm");
        if (fromForm != null && fromForm.equals("true") && boothIdStr != null) {
            return new ModelAndView("redirect:/admin/booth-form?id=" + boothIdStr);
        }
        
        // ถ้าไม่ได้มาจากฟอร์ม ให้กลับไปที่หน้ารายการบูธ
        return new ModelAndView("redirect:/admin/booths");
    }
    
    // เพิ่มเมธอดสำหรับดาวน์โหลด QR Code
    private ModelAndView handleDownloadQR(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String boothIdStr = request.getParameter("id");
        
        if (boothIdStr != null && !boothIdStr.isEmpty()) {
            Long boothId = Long.parseLong(boothIdStr);
            Booth booth = boothService.getBoothById(boothId);
            
            if (booth != null && booth.getQrCodeUrl() != null) {
                String qrCodePath = request.getServletContext().getRealPath(booth.getQrCodeUrl());
                File file = new File(qrCodePath);
                
                if (file.exists()) {
                    response.setContentType("image/png");
                    response.setHeader("Content-Disposition", "attachment; filename=booth_" + boothId + ".png");
                    
                    try (FileInputStream fis = new FileInputStream(file);
                         OutputStream os = response.getOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        
                        while ((bytesRead = fis.read(buffer)) != -1) {
                            os.write(buffer, 0, bytesRead);
                        }
                    }
                    
                    return null; // ไม่ต้องส่งกลับ ModelAndView เพราะเขียน response โดยตรงแล้ว
                }
            }
        }
        
        // กรณีไม่พบไฟล์หรือเกิดข้อผิดพลาด
        return new ModelAndView("redirect:/admin/booths");
    }
    
    // Reward Management
    private ModelAndView handleRewards(HttpServletRequest request) {
        List<Reward> rewards = rewardService.getAllRewards();
        
        ModelAndView mv = new ModelAndView("admin/rewards");
        mv.addObject("rewards", rewards);
        
        return mv;
    }
    
    private ModelAndView handleRewardForm(HttpServletRequest request) {
        String rewardIdStr = request.getParameter("id");
        Reward reward = null;
        
        if (rewardIdStr != null && !rewardIdStr.isEmpty()) {
            Long rewardId = Long.parseLong(rewardIdStr);
            reward = rewardService.getRewardById(rewardId);
        }
        
        ModelAndView mv = new ModelAndView("admin/reward-form");
        mv.addObject("reward", reward);
        
        return mv;
    }
    
    private ModelAndView handleSaveReward(HttpServletRequest request) {
        String rewardIdStr = request.getParameter("rewardId");
        String rewardName = request.getParameter("rewardName");
        String rewardDescription = request.getParameter("rewardDescription");
        String rewardType = request.getParameter("rewardType");
        String pointsRequiredStr = request.getParameter("pointsRequired");
        String quantityStr = request.getParameter("quantity");
        String remainingStr = request.getParameter("remaining");
        String isActive = request.getParameter("isActive");
        
        if (rewardName == null || rewardName.trim().isEmpty() || 
            rewardType == null || rewardType.trim().isEmpty() ||
            pointsRequiredStr == null || pointsRequiredStr.trim().isEmpty() ||
            quantityStr == null || quantityStr.trim().isEmpty()) {
            
            ModelAndView mv = new ModelAndView("admin/reward-form");
            mv.addObject("error", "กรุณากรอกข้อมูลให้ครบถ้วน");
            return mv;
        }
        
        Integer pointsRequired;
        Integer quantity;
        Integer remaining;
        
        try {
            pointsRequired = Integer.parseInt(pointsRequiredStr);
            quantity = Integer.parseInt(quantityStr);
            
            // ถ้าไม่ได้ระบุค่า remaining ให้ใช้ค่าเดียวกับ quantity
            if (remainingStr != null && !remainingStr.isEmpty()) {
                remaining = Integer.parseInt(remainingStr);
            } else {
                remaining = quantity;
            }
        } catch (NumberFormatException e) {
            ModelAndView mv = new ModelAndView("admin/reward-form");
            mv.addObject("error", "กรุณากรอกข้อมูลตัวเลขให้ถูกต้อง");
            return mv;
        }
        
        Reward reward = new Reward();
        
        if (rewardIdStr != null && !rewardIdStr.isEmpty()) {
            try {
                Long rewardId = Long.parseLong(rewardIdStr);
                reward = rewardService.getRewardById(rewardId);
                
                // ถ้าไม่พบรางวัลให้สร้างใหม่
                if (reward == null) {
                    reward = new Reward();
                }
            } catch (NumberFormatException e) {
                reward = new Reward(); // สร้างใหม่ถ้าแปลงค่าไม่ได้
            }
        }
        
        reward.setRewardName(rewardName);
        reward.setRewardDescription(rewardDescription);
        reward.setRewardType(rewardType);
        reward.setPointsRequired(pointsRequired);
        reward.setQuantity(quantity);
        reward.setRemaining(remaining);
        reward.setIsActive(isActive != null ? "1" : "0");
        
        try {
            if (reward.getRewardId() == null) {
                rewardService.createReward(reward);
            } else {
                rewardService.updateReward(reward);
            }
            return new ModelAndView("redirect:/admin/rewards");
        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mv = new ModelAndView("admin/reward-form");
            mv.addObject("error", "เกิดข้อผิดพลาดในการบันทึกข้อมูล: " + e.getMessage());
            mv.addObject("reward", reward); // ส่งข้อมูลเดิมกลับไปเพื่อให้ผู้ใช้แก้ไข
            return mv;
        }
    }
    
    private ModelAndView handleDeleteReward(HttpServletRequest request) {
        String rewardIdStr = request.getParameter("id");
        
        if (rewardIdStr != null && !rewardIdStr.isEmpty()) {
            Long rewardId = Long.parseLong(rewardIdStr);
            rewardService.deleteReward(rewardId);
        }
        
        return new ModelAndView("redirect:/admin/rewards");
    }
    
    // Claim Management
    private ModelAndView handleClaims(HttpServletRequest request) {
        List<RewardClaim> claims = rewardService.getPendingClaims();
        
        ModelAndView mv = new ModelAndView("admin/claims");
        mv.addObject("claims", claims);
        
        return mv;
    }
    
    private ModelAndView handleMarkReceived(HttpServletRequest request) {
        String claimIdStr = request.getParameter("id");
        
        if (claimIdStr != null && !claimIdStr.isEmpty()) {
            Long claimId = Long.parseLong(claimIdStr);
            rewardService.markClaimAsReceived(claimId);
        }
        
        return new ModelAndView("redirect:/admin/claims");
    }
    
    // Admin Management
    private ModelAndView handleAdmins(HttpServletRequest request) {
        List<Admin> admins = adminService.getAllAdmins();
        
        ModelAndView mv = new ModelAndView("admin/users");
        mv.addObject("admins", admins);
        
        return mv;
    }
    
    private ModelAndView handleAdminForm(HttpServletRequest request) {
        String adminIdStr = request.getParameter("id");
        Admin admin = null;
        
        if (adminIdStr != null && !adminIdStr.isEmpty()) {
            Long adminId = Long.parseLong(adminIdStr);
            admin = adminService.getAdminById(adminId);
            
            // ไม่ส่งรหัสผ่านกลับไปที่ฟอร์ม
            if (admin != null) {
                admin.setPassword("");
            }
        }
        
        ModelAndView mv = new ModelAndView("admin/admin-form");
        mv.addObject("admin", admin);
        
        return mv;
    }
    
    private ModelAndView handleSaveAdmin(HttpServletRequest request) {
        String adminIdStr = request.getParameter("adminId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String role = request.getParameter("role");
        String isActive = request.getParameter("isActive");
        
        if (username == null || username.trim().isEmpty() || 
            fullname == null || fullname.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            
            ModelAndView mv = new ModelAndView("admin/admin-form");
            mv.addObject("error", "กรุณากรอกข้อมูลให้ครบถ้วน");
            return mv;
        }
        
        // ตรวจสอบว่าเป็นการสร้างใหม่หรือแก้ไข
        boolean isNewAdmin = adminIdStr == null || adminIdStr.isEmpty();
        
        // ถ้าเป็นการสร้างใหม่ ต้องมีรหัสผ่าน
        if (isNewAdmin && (password == null || password.trim().isEmpty())) {
            ModelAndView mv = new ModelAndView("admin/admin-form");
            mv.addObject("error", "กรุณากรอกรหัสผ่าน");
            return mv;
        }
        
        Admin admin = new Admin();
        
        if (!isNewAdmin) {
            Long adminId = Long.parseLong(adminIdStr);
            admin = adminService.getAdminById(adminId);
        }
        
        admin.setUsername(username);
        admin.setFullname(fullname);
        admin.setRole(role);
        admin.setIsActive(isActive != null ? "1" : "0");
        
        // กำหนดรหัสผ่านเฉพาะเมื่อมีการกรอก (สำหรับการแก้ไข)
        if (password != null && !password.trim().isEmpty()) {
            admin.setPassword(password);
        }
        
        if (isNewAdmin) {
            adminService.createAdmin(admin);
        } else {
            adminService.updateAdmin(admin);
        }
        
        return new ModelAndView("redirect:/admin/users");
    }
    
    private ModelAndView handleDeleteAdmin(HttpServletRequest request) {
        String adminIdStr = request.getParameter("id");
        
        if (adminIdStr != null && !adminIdStr.isEmpty()) {
            Long adminId = Long.parseLong(adminIdStr);
            adminService.deleteAdmin(adminId);
        }
        
        return new ModelAndView("redirect:/admin/users");
    }

    // เพิ่มเมธอดใหม่
    private ModelAndView handleCancelClaim(HttpServletRequest request) {
        String claimIdStr = request.getParameter("id");
        
        if (claimIdStr != null && !claimIdStr.isEmpty()) {
            try {
                Long claimId = Long.parseLong(claimIdStr);
                rewardService.cancelRewardClaim(claimId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return new ModelAndView("redirect:/admin/claims");
    }
}