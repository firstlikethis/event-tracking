package th.or.studentloan.event.service;

import th.or.studentloan.event.model.Visitor;

public interface VisitorService {
    boolean isPhoneNumberRegistered(String phoneNumber);
    Visitor registerVisitor(Visitor visitor);
    Visitor findVisitorByPhoneNumber(String phoneNumber);
    void updateVisitorPoints(Long visitorId, Integer points);
    Visitor login(String phoneNumber);
}