package th.or.studentloan.event.service;

import th.or.studentloan.event.model.OTP;

public interface OtpService {
    OTP generateAndSendOTP(String phoneNumber);
    boolean verifyOTP(String phoneNumber, String otpCode);
}