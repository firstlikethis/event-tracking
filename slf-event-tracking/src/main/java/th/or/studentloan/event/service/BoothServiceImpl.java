package th.or.studentloan.event.service;

import java.util.List;

import th.or.studentloan.event.dao.BoothDao;
import th.or.studentloan.event.dao.VisitorDao;
import th.or.studentloan.event.dao.VisitorLogDao;
import th.or.studentloan.event.model.Booth;
import th.or.studentloan.event.model.VisitorLog;
import th.or.studentloan.event.util.QrCodeUtil;

public class BoothServiceImpl implements BoothService {
    private BoothDao boothDao;
    private VisitorLogDao visitorLogDao;
    private VisitorDao visitorDao;
    private QrCodeUtil qrCodeUtil;
    
    public void setBoothDao(BoothDao boothDao) {
        this.boothDao = boothDao;
    }
    
    public void setVisitorLogDao(VisitorLogDao visitorLogDao) {
        this.visitorLogDao = visitorLogDao;
    }
    
    public void setVisitorDao(VisitorDao visitorDao) {
        this.visitorDao = visitorDao;
    }
    
    public void setQrCodeUtil(QrCodeUtil qrCodeUtil) {
        this.qrCodeUtil = qrCodeUtil;
    }
    
    @Override
    public List<Booth> getAllActiveBooths() {
        return boothDao.findAllActive();
    }
    
    @Override
    public Booth getBoothById(Long boothId) {
        return boothDao.findById(boothId);
    }
    
    @Override
    public Booth createBooth(Booth booth) {
        booth.setIsActive("1");
        Long boothId = boothDao.save(booth);
        booth.setBoothId(boothId);
        
        // Generate QR Code
        String qrCodeUrl = generateQRCode(boothId);
        booth.setQrCodeUrl(qrCodeUrl);
        boothDao.update(booth);
        
        return booth;
    }
    
    @Override
    public void updateBooth(Booth booth) {
        boothDao.update(booth);
    }
    
    @Override
    public void deleteBooth(Long boothId) {
        boothDao.delete(boothId);
    }
    
    @Override
    public boolean scanBoothQR(Long visitorId, Long boothId) {
        // Check if booth exists and is active
        Booth booth = boothDao.findById(boothId);
        if (booth == null || !"1".equals(booth.getIsActive())) {
            return false;
        }
        
        // Check if visitor has already scanned this booth
        if (visitorLogDao.hasVisitorScannedBooth(visitorId, boothId)) {
            return false; // Already scanned
        }
        
        // Create log entry
        VisitorLog visitorLog = new VisitorLog();
        visitorLog.setVisitorId(visitorId);
        visitorLog.setBoothId(boothId);
        visitorLog.setPointsEarned(booth.getPoints());
        
        visitorLogDao.save(visitorLog);
        
        // Update visitor points
        visitorDao.updatePoints(visitorId, booth.getPoints());
        
        return true;
    }
    
    @Override
    public List<VisitorLog> getVisitorLogs(Long visitorId) {
        return visitorLogDao.findByVisitorId(visitorId);
    }
    
    @Override
    public String generateQRCode(Long boothId) {
        String qrCodeData = "booth:" + boothId;
        String fileName = "booth_" + boothId + ".png";
        
        return qrCodeUtil.generateQRCode(qrCodeData, fileName);
    }
}