package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.Reward;

import java.util.List;

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