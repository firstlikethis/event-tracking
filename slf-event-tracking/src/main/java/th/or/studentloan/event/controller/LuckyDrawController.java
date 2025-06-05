package th.or.studentloan.event.controller;

import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.service.RewardService;

public class LuckyDrawController extends AbstractController {
    private RewardService rewardService;
    
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
        }
        
        return new ModelAndView("redirect:/admin");
    }
    
    private ModelAndView handleLuckyDraw(HttpServletRequest request) {
        // ดึงรายการรางวัลที่สามารถสุ่มได้ (ประเภท 1)
        List<Reward> luckyDrawRewards = rewardService.getAllActiveRewards().stream()
                .filter(reward -> "1".equals(reward.getRewardType()) && reward.getRemaining() > 0)
                .collect(Collectors.toList()); // แก้ไขจาก .toList() เป็น .collect(Collectors.toList())
        
        ModelAndView mv = new ModelAndView("lucky-draw");
        mv.addObject("rewards", luckyDrawRewards);
        
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
    }
    
    private ModelAndView handleLuckyDrawResult(HttpServletRequest request) {
        String rewardIdStr = request.getParameter("rewardId");
        
        if (rewardIdStr == null || rewardIdStr.isEmpty()) {
            return new ModelAndView("redirect:/lucky-draw");
        }
        
        Long rewardId = Long.parseLong(rewardIdStr);
        Reward reward = rewardService.getRewardById(rewardId);
        
        if (reward == null) {
            return new ModelAndView("redirect:/lucky-draw");
        }
        
        // สุ่มผู้โชคดี
        Visitor winner = rewardService.selectRandomWinner(rewardId, reward.getPointsRequired());
        
        // ถ้าไม่มีผู้มีสิทธิ์ลุ้นรางวัล
        if (winner == null) {
            ModelAndView mv = new ModelAndView("lucky-draw-result");
            mv.addObject("reward", reward);
            mv.addObject("noEligibleParticipants", true);
            return mv;
        }
        
        // บันทึกการแลกรางวัล
        boolean success = rewardService.claimReward(winner.getVisitorId(), rewardId, true);
        
        ModelAndView mv = new ModelAndView("lucky-draw-result");
        mv.addObject("reward", reward);
        mv.addObject("winner", winner);
        mv.addObject("success", success);
        
        return mv;
    }
}