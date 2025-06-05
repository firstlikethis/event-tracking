package th.or.studentloan.event.service;

import java.util.List;

import th.or.studentloan.event.model.Booth;
import th.or.studentloan.event.model.VisitorLog;

public interface BoothService {
    List<Booth> getAllActiveBooths();
    Booth getBoothById(Long boothId);
    Booth createBooth(Booth booth);
    void updateBooth(Booth booth);
    void deleteBooth(Long boothId);
    boolean scanBoothQR(Long visitorId, Long boothId);
    List<VisitorLog> getVisitorLogs(Long visitorId);
    String generateQRCode(Long boothId);
}