package th.or.studentloan.event.service;

import java.util.Calendar;
import java.util.Date;
import java.util.Random;

import th.or.studentloan.event.dao.OtpDao;
import th.or.studentloan.event.model.OTP;
import th.or.studentloan.event.util.SmsUtil;

public class OtpServiceImpl implements OtpService {
    private OtpDao otpDao;
    private SmsUtil smsUtil;
    
    public void setOtpDao(OtpDao otpDao) {
        this.otpDao = otpDao;
    }
    
    public void setSmsUtil(SmsUtil smsUtil) {
        this.smsUtil = smsUtil;
    }
    
    @Override
    public OTP generateAndSendOTP(String phoneNumber) {
        // Clean up expired OTPs
        otpDao.deleteExpiredOTPs();
        
        // Generate random 6-digit OTP
        Random random = new Random();
        String otpCode = String.format("%06d", random.nextInt(1000000));
        
        // Set expiration time (5 minutes from now)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 5);
        Date expiredDate = calendar.getTime();
        
        // Create OTP object
        OTP otp = new OTP();
        otp.setPhoneNumber(phoneNumber);
        otp.setOtpCode(otpCode);
        otp.setExpiredDate(expiredDate);
        otp.setIsUsed("0");
        
        // Save OTP to database
        Long otpId = otpDao.save(otp);
        otp.setOtpId(otpId);
        
        // Send OTP via SMS
        String message = "รหัส OTP ของคุณคือ " + otpCode + " (หมดอายุใน 5 นาที)";
        smsUtil.sendSMS(phoneNumber, message);
        
        return otp;
    }
    
    @Override
    public boolean verifyOTP(String phoneNumber, String otpCode) {
        OTP otp = otpDao.findByPhoneNumberAndCode(phoneNumber, otpCode);
        
        if (otp != null) {
            otpDao.markAsUsed(otp.getOtpId());
            return true;
        }
        
        return false;
    }
}