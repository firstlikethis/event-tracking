package th.or.studentloan.event.controller;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.service.RewardService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

public class RewardController extends AbstractController {
    private RewardService rewardService;
    
    public void setRewardService(RewardService rewardService) {
        this.rewardService = rewardService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (path.equals("/rewards")) {
            return handleRewards(request);
        } else if (path.equals("/claim-reward")) {
            return handleClaimReward(request);
        } else if (path.equals("/my-rewards")) {
            return handleMyRewards(request);
        }
        
        return new ModelAndView("redirect:/dashboard");
    }
    
    private ModelAndView handleRewards(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        // รายการรางวัลที่สามารถแลกได้ทันที
        List<Reward> exchangeRewards = rewardService.getAvailableRewardsForExchange();
        
        // รายการรางวัลสำหรับลุ้น
        List<Reward> luckyDrawRewards = rewardService.getAvailableRewardsForLuckyDraw(visitor.getVisitorType());
        
        ModelAndView mv = new ModelAndView("rewards");
        mv.addObject("visitor", visitor);
        mv.addObject("exchangeRewards", exchangeRewards);
        mv.addObject("luckyDrawRewards", luckyDrawRewards);
        
        return mv;
    }
    
    private ModelAndView handleClaimReward(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String rewardIdStr = request.getParameter("rewardId");
            String rewardTypeStr = request.getParameter("rewardType");
            
            if (rewardIdStr != null && rewardTypeStr != null) {
                Long rewardId = Long.parseLong(rewardIdStr);
                boolean isLuckyDraw = "1".equals(rewardTypeStr);
                
                // แลกรางวัล
                boolean success = rewardService.claimReward(visitor.getVisitorId(), rewardId, isLuckyDraw);
                
                if (success) {
                    // ดึงข้อมูลรางวัล
                    Reward reward = rewardService.getRewardById(rewardId);
                    
                    ModelAndView mv = new ModelAndView("claim-result");
                    mv.addObject("success", true);
                    mv.addObject("reward", reward);
                    mv.addObject("isLuckyDraw", isLuckyDraw);
                    return mv;
                } else {
                    ModelAndView mv = new ModelAndView("claim-result");
                    mv.addObject("success", false);
                    mv.addObject("message", "ไม่สามารถแลกรางวัลได้ คะแนนไม่เพียงพอหรือรางวัลหมด");
                    return mv;
                }
            }
        }
        
        return new ModelAndView("redirect:/rewards");
    }
    
    private ModelAndView handleMyRewards(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        // ประวัติการแลกรางวัล
        List<RewardClaim> myClaims = rewardService.getVisitorClaims(visitor.getVisitorId());
        
        ModelAndView mv = new ModelAndView("my-rewards");
        mv.addObject("visitor", visitor);
        mv.addObject("myClaims", myClaims);
        
        return mv;
    }
}