package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.OTP;

public interface OtpDao {
    OTP findByPhoneNumberAndCode(String phoneNumber, String otpCode);
    Long save(OTP otp);
    void markAsUsed(Long otpId);
    void deleteExpiredOTPs();
}