package th.or.studentloan.event.dao;

import java.util.List;

import th.or.studentloan.event.model.VisitorLog;

public interface VisitorLogDao {
    List<VisitorLog> findByVisitorId(Long visitorId);
    boolean hasVisitorScannedBooth(Long visitorId, Long boothId);
    Long save(VisitorLog visitorLog);
}