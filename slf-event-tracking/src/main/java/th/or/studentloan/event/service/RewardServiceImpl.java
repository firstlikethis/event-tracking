package th.or.studentloan.event.service;

import th.or.studentloan.event.dao.RewardClaimDao;
import th.or.studentloan.event.dao.RewardDao;
import th.or.studentloan.event.dao.VisitorDao;
import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class RewardServiceImpl implements RewardService {
    private RewardDao rewardDao;
    private RewardClaimDao rewardClaimDao;
    private VisitorDao visitorDao;
    
    public void setRewardDao(RewardDao rewardDao) {
        this.rewardDao = rewardDao;
    }
    
    public void setRewardClaimDao(RewardClaimDao rewardClaimDao) {
        this.rewardClaimDao = rewardClaimDao;
    }
    
    public void setVisitorDao(VisitorDao visitorDao) {
        this.visitorDao = visitorDao;
    }
    
    @Override
    public List<Reward> getAllRewards() {
        return rewardDao.findAll();
    }
    
    @Override
    public List<Reward> getAllActiveRewards() {
        return rewardDao.findAllActive();
    }
    
    @Override
    public Reward getRewardById(Long rewardId) {
        return rewardDao.findById(rewardId);
    }
    
    @Override
    public Reward createReward(Reward reward) {
        reward.setIsActive("1");
        if (reward.getRemaining() == null) {
            reward.setRemaining(reward.getQuantity());
        }
        Long rewardId = rewardDao.save(reward);
        reward.setRewardId(rewardId);
        return reward;
    }
    
    @Override
    public void updateReward(Reward reward) {
        rewardDao.update(reward);
    }
    
    @Override
    public void deleteReward(Long rewardId) {
        rewardDao.delete(rewardId);
    }
    
    @Override
    public List<Reward> getAvailableRewardsForExchange() {
        return rewardDao.findAvailableForExchange();
    }
    
    @Override
    public List<Reward> getAvailableRewardsForLuckyDraw(String visitorType) {
        return rewardDao.findAvailableForLuckyDraw(visitorType);
    }
    
    @Override
    public boolean claimReward(Long visitorId, Long rewardId, boolean isLuckyDraw) {
        // ตรวจสอบว่ารางวัลนี้มีอยู่และยังมีของเหลือ
        Reward reward = rewardDao.findById(rewardId);
        if (reward == null || !"1".equals(reward.getIsActive()) || reward.getRemaining() <= 0) {
            return false;
        }
        
        // ตรวจสอบว่าผู้ใช้มีคะแนนเพียงพอ
        Visitor visitor = visitorDao.findById(visitorId);
        if (visitor == null || visitor.getTotalPoints() < reward.getPointsRequired()) {
            return false;
        }
        
        // สร้างบันทึกการแลกรางวัล
        RewardClaim claim = new RewardClaim();
        claim.setVisitorId(visitorId);
        claim.setRewardId(rewardId);
        claim.setPointsUsed(reward.getPointsRequired());
        claim.setIsLuckyDraw(isLuckyDraw ? "1" : "0");
        claim.setIsReceived("0");
        
        Long claimId = rewardClaimDao.save(claim);
        
        // หักคะแนน
        visitorDao.updatePoints(visitorId, -reward.getPointsRequired());
        
        // ลดจำนวนรางวัลที่เหลือ
        rewardDao.decreaseRemaining(rewardId);
        
        return true;
    }
    
    @Override
    public List<RewardClaim> getVisitorClaims(Long visitorId) {
        return rewardClaimDao.findByVisitorId(visitorId);
    }
    
    @Override
    public List<RewardClaim> getAllClaims() {
        return rewardClaimDao.findAll();
    }
    
    @Override
    public List<RewardClaim> getPendingClaims() {
        return rewardClaimDao.findPendingClaims();
    }
    
    @Override
    public void markClaimAsReceived(Long claimId) {
        rewardClaimDao.markAsReceived(claimId);
    }
    
    @Override
    public List<RewardClaim> getWinnersByRewardId(Long rewardId) {
        return rewardClaimDao.findWinnersByRewardId(rewardId);
    }
    
    @Override
    public Visitor selectRandomWinner(Long rewardId, Integer minPoints) {
        // รายชื่อประเภทผู้เข้าร่วมที่มีสิทธิ์ลุ้นรางวัล
        List<String> eligibleTypes = Arrays.asList("1", "2", "3", "4");
        
        // หารายการผู้เข้าร่วมที่มีสิทธิ์ลุ้นรางวัล
        List<Long> eligibleVisitors = rewardClaimDao.findVisitorsEligibleForLuckyDraw(minPoints, eligibleTypes);
        
        if (eligibleVisitors.isEmpty()) {
            return null;
        }
        
        // สุ่มเลือกผู้โชคดี
        Random random = new Random();
        Long winnerId = eligibleVisitors.get(random.nextInt(eligibleVisitors.size()));
        
        return visitorDao.findById(winnerId);
    }
}