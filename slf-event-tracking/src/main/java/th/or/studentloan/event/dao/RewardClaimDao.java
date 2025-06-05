package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.RewardClaim;

import java.util.List;

public interface RewardClaimDao {
    List<RewardClaim> findAll();
    List<RewardClaim> findByVisitorId(Long visitorId);
    RewardClaim findById(Long claimId);
    List<RewardClaim> findPendingClaims();
    Long save(RewardClaim rewardClaim);
    void markAsReceived(Long claimId);
    List<RewardClaim> findWinnersByRewardId(Long rewardId);
    List<Long> findVisitorsEligibleForLuckyDraw(Integer minPoints, List<String> eligibleTypes);
}