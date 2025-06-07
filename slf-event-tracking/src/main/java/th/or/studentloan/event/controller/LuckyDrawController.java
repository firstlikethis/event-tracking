package th.or.studentloan.event.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.fasterxml.jackson.databind.ObjectMapper;

import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.service.RewardService;

public class LuckyDrawController extends AbstractController {
    private RewardService rewardService;
    
    // เก็บข้อมูลผู้โชคดีล่าสุดสำหรับแต่ละรางวัล
    private Map<Long, Visitor> latestWinners = new HashMap<>();
    
    // เพิ่มตัวแปรใหม่เพื่อเก็บข้อมูลการสุ่มปัจจุบัน
    private static CurrentDrawingInfo currentDrawing = null;
    
    // Inner class เพื่อเก็บข้อมูลการสุ่มปัจจุบัน
    private static class CurrentDrawingInfo {
        private Long rewardId;
        private String rewardName;
        private String rewardDescription;
        private Integer pointsRequired;
        private boolean isActive = false;
        private Visitor winner = null;
        
        public CurrentDrawingInfo(Reward reward) {
            this.rewardId = reward.getRewardId();
            this.rewardName = reward.getRewardName();
            this.rewardDescription = reward.getRewardDescription();
            this.pointsRequired = reward.getPointsRequired();
        }

        public Long getRewardId() {
            return rewardId;
        }

        public String getRewardName() {
            return rewardName;
        }

        public String getRewardDescription() {
            return rewardDescription;
        }

        public Integer getPointsRequired() {
            return pointsRequired;
        }

        public boolean isActive() {
            return isActive;
        }

        public void setActive(boolean isActive) {
            this.isActive = isActive;
        }

        public Visitor getWinner() {
            return winner;
        }

        public void setWinner(Visitor winner) {
            this.winner = winner;
        }
    }
    
    public void setRewardService(RewardService rewardService) {
        this.rewardService = rewardService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (path.equals("/lucky-draw")) {
            return handleLuckyDraw(request);
        } else if (path.equals("/lucky-draw-result")) {
            return handleLuckyDrawResult(request);
        } else if (path.equals("/lucky-draw-display")) {
            return handleLuckyDrawDisplay(request);
        } else if (path.equals("/api/get-winner")) {
            return handleGetWinner(request, response);
        } else if (path.equals("/api/start-draw")) {
            return handleStartDraw(request, response);
        } else if (path.equals("/api/get-winners")) {
            return handleGetWinners(request, response);
        } else if (path.equals("/api/current-drawing")) {
            return handleCurrentDrawing(request, response);
        }
        
        return new ModelAndView("redirect:/admin");
    }

    // เพิ่มเมธอดใหม่สำหรับดึงข้อมูลการสุ่มปัจจุบัน
    private ModelAndView handleCurrentDrawing(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();
        
        if (currentDrawing != null) {
            result.put("success", true);
            result.put("isActive", currentDrawing.isActive());
            result.put("rewardId", currentDrawing.getRewardId());
            result.put("rewardName", currentDrawing.getRewardName());
            result.put("rewardDescription", currentDrawing.getRewardDescription());
            result.put("pointsRequired", currentDrawing.getPointsRequired());
            
            if (currentDrawing.getWinner() != null) {
                Map<String, Object> winnerInfo = new HashMap<>();
                winnerInfo.put("name", currentDrawing.getWinner().getFullname());
                winnerInfo.put("phone", currentDrawing.getWinner().getPhoneNumber());
                result.put("winner", winnerInfo);
            }
        } else {
            result.put("success", false);
            result.put("message", "No active drawing");
        }
        
        response.getWriter().write(mapper.writeValueAsString(result));
        return null;
    }

    // เพิ่มเมธอดใหม่สำหรับดึงรายชื่อผู้โชคดีทั้งหมด
    private ModelAndView handleGetWinners(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String rewardIdStr = request.getParameter("rewardId");
        if (rewardIdStr == null || rewardIdStr.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing reward ID\"}");
            return null;
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        List<RewardClaim> winners = rewardService.getWinnersByRewardId(rewardId);
        
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();
        
        if (winners != null && !winners.isEmpty()) {
            result.put("success", true);
            
            // สร้างข้อมูลผู้โชคดีในรูปแบบที่ JavaScript เข้าใจได้
            List<Map<String, Object>> winnersList = new ArrayList<>();
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            for (RewardClaim winner : winners) {
                Map<String, Object> winnerMap = new HashMap<>();
                winnerMap.put("visitorName", winner.getVisitorName());
                winnerMap.put("isReceived", winner.getIsReceived());
                winnerMap.put("claimDate", dateFormat.format(winner.getClaimDate()));
                winnersList.add(winnerMap);
            }
            
            result.put("winners", winnersList);
        } else {
            result.put("success", false);
            result.put("message", "No winners found for this reward");
        }
        
        response.getWriter().write(mapper.writeValueAsString(result));
        return null;
    }
    
    private ModelAndView handleLuckyDraw(HttpServletRequest request) {
        // ดึงรายการรางวัลที่สามารถสุ่มได้ (ประเภท 1)
        List<Reward> luckyDrawRewards = rewardService.getAllActiveRewards().stream()
                .filter(reward -> "1".equals(reward.getRewardType()))
                .collect(Collectors.toList());
        
        // สร้าง Map เก็บข้อมูลผู้โชคดีล่าสุดของแต่ละรางวัล
        Map<Long, Object[]> winnersMap = new HashMap<>();
        
        // ดึงข้อมูลผู้โชคดีล่าสุดของแต่ละรางวัล
        for (Reward reward : luckyDrawRewards) {
            List<RewardClaim> winners = rewardService.getWinnersByRewardId(reward.getRewardId());
            if (winners != null && !winners.isEmpty()) {
                String latestWinnerName = winners.get(0).getVisitorName();
                winnersMap.put(reward.getRewardId(), new Object[] { latestWinnerName, winners.size() });
            }
        }
        
        // ส่งข้อมูลไปยัง view
        ModelAndView mv = new ModelAndView("admin/lucky-draw");
        mv.addObject("rewards", luckyDrawRewards);
        mv.addObject("winnersMap", winnersMap);
        
        return mv;
    }
    
    private ModelAndView handleLuckyDrawResult(HttpServletRequest request) {
        String rewardIdStr = request.getParameter("rewardId");
        
        if (rewardIdStr == null || rewardIdStr.isEmpty()) {
            return new ModelAndView("redirect:/lucky-draw");
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        Reward reward = rewardService.getRewardById(rewardId);
        
        // ตรวจสอบว่ารางวัลยังเหลืออยู่หรือไม่
        if (reward == null || reward.getRemaining() <= 0) {
            // แก้ไขเส้นทางไปยัง admin/lucky-draw-result
            ModelAndView mv = new ModelAndView("admin/lucky-draw-result");
            mv.addObject("reward", reward);
            mv.addObject("noMoreRewards", true);
            return mv;
        }
        
        // เตรียมข้อมูลการสุ่มปัจจุบัน
        currentDrawing = new CurrentDrawingInfo(reward);
        currentDrawing.setActive(true);
        
        // สุ่มผู้โชคดี
        Visitor winner = rewardService.selectRandomWinner(rewardId, reward.getPointsRequired());
        
        // เก็บผู้โชคดีล่าสุดสำหรับรางวัลนี้
        if (winner != null) {
            latestWinners.put(rewardId, winner);
            currentDrawing.setWinner(winner);
        }
        
        // ถ้าไม่มีผู้มีสิทธิ์ลุ้นรางวัล
        if (winner == null) {
            // แก้ไขเส้นทางไปยัง admin/lucky-draw-result
            ModelAndView mv = new ModelAndView("admin/lucky-draw-result");
            mv.addObject("reward", reward);
            mv.addObject("noEligibleParticipants", true);
            
            // อัพเดทสถานะ
            if (currentDrawing != null) {
                currentDrawing.setActive(false);
            }
            
            return mv;
        }
        
        // บันทึกการแลกรางวัล
        boolean success = rewardService.claimReward(winner.getVisitorId(), rewardId, true);
        
        // แก้ไขเส้นทางไปยัง admin/lucky-draw-result
        ModelAndView mv = new ModelAndView("admin/lucky-draw-result");
        mv.addObject("reward", reward);
        mv.addObject("winner", winner);
        mv.addObject("success", success);
        
        return mv;
    }
    
    private ModelAndView handleLuckyDrawDisplay(HttpServletRequest request) {
        // ไม่จำเป็นต้องใช้ rewardId จาก parameter อีกต่อไป
        ModelAndView mv = new ModelAndView("admin/lucky-draw-display");
        
        // ส่งข้อมูลเริ่มต้นไปยัง view (ถ้ามี)
        if (currentDrawing != null) {
            Reward reward = rewardService.getRewardById(currentDrawing.getRewardId());
            if (reward != null) {
                mv.addObject("reward", reward);
                
                // ดึงรายชื่อผู้โชคดีที่เคยถูกรางวัลนี้
                List<RewardClaim> winners = rewardService.getWinnersByRewardId(currentDrawing.getRewardId());
                mv.addObject("winners", winners);
            }
        }
        
        return mv;
    }
    
    private ModelAndView handleGetWinner(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String rewardIdStr = request.getParameter("rewardId");
        if (rewardIdStr == null || rewardIdStr.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing reward ID\"}");
            return null;
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        Visitor winner = latestWinners.get(rewardId);
        
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();
        
        if (winner != null) {
            result.put("success", true);
            result.put("winnerName", winner.getFullname());
            result.put("winnerPhone", winner.getPhoneNumber());
            result.put("visitorId", winner.getVisitorId());
        } else {
            result.put("success", false);
            result.put("message", "No winner found for this reward");
        }
        
        response.getWriter().write(mapper.writeValueAsString(result));
        return null;
    }
    
    private ModelAndView handleStartDraw(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String rewardIdStr = request.getParameter("rewardId");
        if (rewardIdStr == null || rewardIdStr.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing reward ID\"}");
            return null;
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        Reward reward = rewardService.getRewardById(rewardId);
        
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<>();
        
        // ตรวจสอบว่ารางวัลยังเหลืออยู่หรือไม่
        if (reward == null || reward.getRemaining() <= 0) {
            result.put("success", false);
            result.put("message", "No more rewards available");
            response.getWriter().write(mapper.writeValueAsString(result));
            return null;
        }
        
        // อัพเดทข้อมูลการสุ่มปัจจุบัน
        currentDrawing = new CurrentDrawingInfo(reward);
        currentDrawing.setActive(true);
        
        // ส่งข้อมูลว่าเริ่มสุ่มแล้ว
        result.put("success", true);
        result.put("message", "Drawing started");
        response.getWriter().write(mapper.writeValueAsString(result));
        
        return null;
    }
}