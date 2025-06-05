package th.or.studentloan.event.dao;

import java.util.List;

import th.or.studentloan.event.model.Reward;

public interface RewardDao {
    List<Reward> findAll();
    List<Reward> findAllActive();
    Reward findById(Long rewardId);
    Long save(Reward reward);
    void update(Reward reward);
    void delete(Long rewardId);
    void decreaseRemaining(Long rewardId);
    List<Reward> findAvailableForExchange();
    List<Reward> findAvailableForLuckyDraw(String visitorType);
}