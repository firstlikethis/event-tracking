package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.VisitorLog;

import java.util.List;

public interface VisitorLogDao {
    List<VisitorLog> findByVisitorId(Long visitorId);
    boolean hasVisitorScannedBooth(Long visitorId, Long boothId);
    Long save(VisitorLog visitorLog);
}