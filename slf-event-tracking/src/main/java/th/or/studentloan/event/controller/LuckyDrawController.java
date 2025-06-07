package th.or.studentloan.event.controller;

import java.text.SimpleDateFormat;
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
    private ObjectMapper objectMapper = new ObjectMapper();
    
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
        }
        
        return new ModelAndView("redirect:/admin");
    }
    
    private ModelAndView handleLuckyDraw(HttpServletRequest request) {
        try {
            // ดึงรายการรางวัลที่สามารถสุ่มได้ (ประเภท 1)
            List<Reward> luckyDrawRewards = rewardService.getAllActiveRewards().stream()
                    .filter(reward -> "1".equals(reward.getRewardType()) && reward.getRemaining() > 0)
                    .collect(Collectors.toList());
            
            // สร้าง Map สำหรับเก็บข้อมูลผู้โชคดีล่าสุดของแต่ละรางวัล
            Map<Long, Object[]> winnersMap = new HashMap<>();
            
            // ดึงข้อมูลผู้โชคดีล่าสุดของแต่ละรางวัล
            for (Reward reward : luckyDrawRewards) {
                List<RewardClaim> winners = rewardService.getWinnersByRewardId(reward.getRewardId());
                if (winners != null && !winners.isEmpty()) {
                    RewardClaim latestWinner = winners.get(0);
                    winnersMap.put(reward.getRewardId(), new Object[] { latestWinner.getVisitorName(), winners.size() });
                }
            }
            
            // แก้ไขเส้นทางไปยัง admin/lucky-draw
            ModelAndView mv = new ModelAndView("admin/lucky-draw");
            mv.addObject("rewards", luckyDrawRewards);
            mv.addObject("winnersMap", winnersMap);
            
            // ถ้ามีการเลือกรางวัลแล้ว
            String rewardIdStr = request.getParameter("rewardId");
            if (rewardIdStr != null && !rewardIdStr.isEmpty()) {
                Long rewardId = Long.parseLong(rewardIdStr);
                Reward selectedReward = rewardService.getRewardById(rewardId);
                
                // ดึงรายชื่อผู้โชคดีที่เคยถูกรางวัลนี้
                List<RewardClaim> winners = rewardService.getWinnersByRewardId(rewardId);
                
                mv.addObject("selectedReward", selectedReward);
                mv.addObject("winners", winners);
            }
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mv = new ModelAndView("admin/lucky-draw");
            mv.addObject("error", "เกิดข้อผิดพลาดในการดึงข้อมูลรางวัล: " + e.getMessage());
            return mv;
        }
    }
    
    private ModelAndView handleLuckyDrawResult(HttpServletRequest request) {
        try {
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
            
            // สุ่มผู้โชคดี
            Visitor winner = rewardService.selectRandomWinner(rewardId, reward.getPointsRequired());
            
            // ถ้าไม่มีผู้มีสิทธิ์ลุ้นรางวัล
            if (winner == null) {
                // แก้ไขเส้นทางไปยัง admin/lucky-draw-result
                ModelAndView mv = new ModelAndView("admin/lucky-draw-result");
                mv.addObject("reward", reward);
                mv.addObject("noEligibleParticipants", true);
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
        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mv = new ModelAndView("admin/lucky-draw-result");
            mv.addObject("error", "เกิดข้อผิดพลาดในการสุ่มรางวัล: " + e.getMessage());
            return mv;
        }
    }
    
    private ModelAndView handleLuckyDrawDisplay(HttpServletRequest request) {
        try {
            String rewardIdStr = request.getParameter("rewardId");
            
            // ถ้าไม่มีการระบุรางวัล แสดงหน้าจอรอเลือกรางวัล
            ModelAndView mv = new ModelAndView("admin/lucky-draw-display");
            
            if (rewardIdStr != null && !rewardIdStr.isEmpty()) {
                Long rewardId = Long.parseLong(rewardIdStr);
                Reward reward = rewardService.getRewardById(rewardId);
                
                if (reward != null) {
                    // ดึงรายชื่อผู้โชคดีที่เคยถูกรางวัลนี้
                    List<RewardClaim> winners = rewardService.getWinnersByRewardId(rewardId);
                    
                    mv.addObject("reward", reward);
                    mv.addObject("winners", winners);
                }
            }
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mv = new ModelAndView("admin/lucky-draw-display");
            mv.addObject("error", "เกิดข้อผิดพลาดในการแสดงหน้าสุ่มรางวัล: " + e.getMessage());
            return mv;
        }
    }
    
    // API สำหรับดึงข้อมูลผู้โชคดี
    private ModelAndView handleGetWinner(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            String rewardIdStr = request.getParameter("rewardId");
            
            if (rewardIdStr == null || rewardIdStr.isEmpty()) {
                result.put("success", false);
                result.put("message", "ไม่ได้ระบุรหัสรางวัล");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            Long rewardId = Long.parseLong(rewardIdStr);
            Reward reward = rewardService.getRewardById(rewardId);
            
            // ตรวจสอบว่ารางวัลยังเหลืออยู่หรือไม่
            if (reward == null || reward.getRemaining() <= 0) {
                result.put("success", false);
                result.put("message", "รางวัลหมดแล้ว");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            // สุ่มผู้โชคดี
            Visitor winner = rewardService.selectRandomWinner(rewardId, reward.getPointsRequired());
            
            // ถ้าไม่มีผู้มีสิทธิ์ลุ้นรางวัล
            if (winner == null) {
                result.put("success", false);
                result.put("message", "ไม่พบผู้มีสิทธิ์ลุ้นรางวัล");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            // บันทึกการแลกรางวัล
            boolean success = rewardService.claimReward(winner.getVisitorId(), rewardId, true);
            
            if (success) {
                result.put("success", true);
                result.put("winner", winner);
                result.put("reward", reward);
            } else {
                result.put("success", false);
                result.put("message", "ไม่สามารถบันทึกการแลกรางวัลได้");
            }
            
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "เกิดข้อผิดพลาด: " + e.getMessage());
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        }
    }
    
    // API สำหรับเริ่มการสุ่มรางวัล
    private ModelAndView handleStartDraw(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            String rewardIdStr = request.getParameter("rewardId");
            
            if (rewardIdStr == null || rewardIdStr.isEmpty()) {
                result.put("success", false);
                result.put("message", "ไม่ได้ระบุรหัสรางวัล");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            Long rewardId = Long.parseLong(rewardIdStr);
            Reward reward = rewardService.getRewardById(rewardId);
            
            // ตรวจสอบว่ารางวัลยังเหลืออยู่หรือไม่
            if (reward == null || reward.getRemaining() <= 0) {
                result.put("success", false);
                result.put("message", "รางวัลหมดแล้ว");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            result.put("success", true);
            result.put("rewardId", rewardId);
            
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "เกิดข้อผิดพลาด: " + e.getMessage());
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        }
    }
    
    // API สำหรับดึงรายชื่อผู้โชคดีทั้งหมดของรางวัล
    private ModelAndView handleGetWinners(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            String rewardIdStr = request.getParameter("rewardId");
            
            if (rewardIdStr == null || rewardIdStr.isEmpty()) {
                result.put("success", false);
                result.put("message", "ไม่ได้ระบุรหัสรางวัล");
                objectMapper.writeValue(response.getWriter(), result);
                return null;
            }
            
            Long rewardId = Long.parseLong(rewardIdStr);
            
            // ดึงรายชื่อผู้โชคดีที่เคยถูกรางวัลนี้
            List<RewardClaim> winners = rewardService.getWinnersByRewardId(rewardId);
            
            // แปลงวันที่ให้เป็นรูปแบบที่อ่านง่าย
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            List<Map<String, Object>> formattedWinners = winners.stream().map(winner -> {
                Map<String, Object> map = new HashMap<>();
                map.put("claimId", winner.getClaimId());
                map.put("visitorId", winner.getVisitorId());
                map.put("visitorName", winner.getVisitorName());
                map.put("claimDate", dateFormat.format(winner.getClaimDate()));
                map.put("isReceived", winner.getIsReceived());
                return map;
            }).collect(Collectors.toList());
            
            result.put("success", true);
            result.put("winners", formattedWinners);
            
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "เกิดข้อผิดพลาด: " + e.getMessage());
            objectMapper.writeValue(response.getWriter(), result);
            return null;
        }
    }
}