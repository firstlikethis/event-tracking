package th.or.studentloan.event.service;

import th.or.studentloan.event.model.Reward;
import th.or.studentloan.event.model.RewardClaim;
import th.or.studentloan.event.model.Visitor;

import java.util.List;

public interface RewardService {
    List<Reward> getAllRewards();
    List<Reward> getAllActiveRewards();
    Reward getRewardById(Long rewardId);
    Reward createReward(Reward reward);
    void updateReward(Reward reward);
    void deleteReward(Long rewardId);
    
    List<Reward> getAvailableRewardsForExchange();
    List<Reward> getAvailableRewardsForLuckyDraw(String visitorType);
    
    boolean claimReward(Long visitorId, Long rewardId, boolean isLuckyDraw);
    List<RewardClaim> getVisitorClaims(Long visitorId);
    
    List<RewardClaim> getAllClaims();
    List<RewardClaim> getPendingClaims();
    void markClaimAsReceived(Long claimId);
    
    List<RewardClaim> getWinnersByRewardId(Long rewardId);
    Visitor selectRandomWinner(Long rewardId, Integer minPoints);
}