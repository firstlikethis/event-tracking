package th.or.studentloan.event.controller;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.model.Admin;
import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.service.RewardService;
import th.or.studentloan.event.service.VisitorService;

public class LuckyDrawController extends AbstractController {
    private RewardService rewardService;
    private VisitorService visitorService;
    
    public void setRewardService(RewardService rewardService) {
        this.rewardService = rewardService;
    }
    
    public void setVisitorService(VisitorService visitorService) {
        this.visitorService = visitorService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        System.out.println("LuckyDrawController Path: " + path); // Log ค่า path เพื่อดีบัก
        
        // Check if admin is logged in
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        if (admin == null && !path.equals("/admin/lucky-draw-display")) {
            return new ModelAndView("redirect:/admin");
        }
        
        if (path.equals("/admin/lucky-draw")) {
            return handleLuckyDraw(request);
        } else if (path.equals("/admin/lucky-draw-display")) {
            return handleLuckyDrawDisplay(request);
        } else if (path.equals("/admin/perform-lucky-draw")) {
            return handlePerformLuckyDraw(request, response);
        }
        
        return new ModelAndView("redirect:/admin/dashboard");
    }
    
    private ModelAndView handleLuckyDraw(HttpServletRequest request) {
        try {
            // Get all lucky draw rewards (reward_type = '1')
            List<Reward> luckyDrawRewards = rewardService.getAllActiveRewards().stream()
                    .filter(r -> "1".equals(r.getRewardType()) && r.getRemaining() > 0)
                    .collect(Collectors.toList());
            
            // Get the minimum points required for any lucky draw
            Integer minPoints = 0;
            if (!luckyDrawRewards.isEmpty()) {
                minPoints = luckyDrawRewards.stream()
                    .map(Reward::getPointsRequired)
                    .min(Integer::compare)
                    .orElse(0);
            }
            
            // Get winners history (claims with is_lucky_draw = '1')
            List<RewardClaim> winnersHistory = rewardService.getAllClaimsWithHistory().stream()
                    .filter(c -> "1".equals(c.getIsLuckyDraw()))
                    .collect(Collectors.toList());
            
            ModelAndView mv = new ModelAndView("admin/lucky-draw");
            mv.addObject("rewards", luckyDrawRewards);
            mv.addObject("minPoints", minPoints);
            mv.addObject("winnersHistory", winnersHistory);
            
            return mv;
        } catch (Exception e) {
            e.printStackTrace();
            // ในกรณีที่เกิดข้อผิดพลาด ส่งกลับหน้า error
            ModelAndView mv = new ModelAndView("admin/error");
            mv.addObject("errorMessage", "เกิดข้อผิดพลาดในการโหลดข้อมูลการสุ่มรางวัล: " + e.getMessage());
            return mv;
        }
    }
    
    private ModelAndView handleLuckyDrawDisplay(HttpServletRequest request) {
        return new ModelAndView("admin/lucky-draw-display");
    }
    
    private ModelAndView handlePerformLuckyDraw(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rewardIdStr = request.getParameter("rewardId");
        String minPointsStr = request.getParameter("minPoints");
        
        if (rewardIdStr == null || minPointsStr == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"รหัสรางวัลหรือคะแนนขั้นต่ำไม่ถูกต้อง\"}");
            return null;
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        Integer minPoints = Integer.parseInt(minPointsStr);
        
        // Get the reward
        Reward reward = rewardService.getRewardById(rewardId);
        
        if (reward == null || !"1".equals(reward.getRewardType()) || reward.getRemaining() <= 0) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"รางวัลไม่ถูกต้องหรือหมดแล้ว\"}");
            return null;
        }
        
        // ประเภทผู้เข้าร่วมที่มีสิทธิ์ลุ้นรางวัล: 1,2,3,4
        List<String> eligibleTypes = Arrays.asList("1", "2", "3", "4");
        
        // Select a random winner
        Visitor winner = rewardService.selectRandomWinner(rewardId, minPoints);
        
        if (winner == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"ไม่พบผู้มีสิทธิ์รับรางวัล\"}");
            return null;
        }
        
        // Claim the reward for the winner
        boolean claimSuccess = rewardService.claimReward(winner.getVisitorId(), rewardId, true);
        
        if (claimSuccess) {
            response.setContentType("application/json");
            response.getWriter().write("{" +
                "\"success\": true, " +
                "\"winner\": {" +
                    "\"id\": " + winner.getVisitorId() + ", " +
                    "\"name\": \"" + winner.getFullname() + "\", " +
                    "\"phone\": \"" + winner.getPhoneNumber() + "\"" +
                "}, " +
                "\"reward\": {" +
                    "\"id\": " + reward.getRewardId() + ", " +
                    "\"name\": \"" + reward.getRewardName() + "\", " +
                    "\"points\": " + reward.getPointsRequired() + "" +
                "}" +
            "}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"ไม่สามารถมอบรางวัลให้ผู้โชคดีได้\"}");
        }
        
        return null;
    }
}