package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.Visitor;

public interface VisitorDao {
    Visitor findByPhoneNumber(String phoneNumber);
    Visitor findById(Long visitorId);
    Long save(Visitor visitor);
    void update(Visitor visitor);
    void updatePoints(Long visitorId, Integer points);
    void updateLastLoginDate(Long visitorId);
}