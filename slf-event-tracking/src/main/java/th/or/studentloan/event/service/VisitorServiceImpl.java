package th.or.studentloan.event.service;

import th.or.studentloan.event.dao.OtpDao;
import th.or.studentloan.event.dao.VisitorDao;
import th.or.studentloan.event.model.Visitor;

public class VisitorServiceImpl implements VisitorService {
    private VisitorDao visitorDao;
    private OtpDao otpDao;
    
    public void setVisitorDao(VisitorDao visitorDao) {
        this.visitorDao = visitorDao;
    }
    
    public void setOtpDao(OtpDao otpDao) {
        this.otpDao = otpDao;
    }
    
    @Override
    public boolean isPhoneNumberRegistered(String phoneNumber) {
        Visitor visitor = visitorDao.findByPhoneNumber(phoneNumber);
        return visitor != null;
    }
    
    @Override
    public Visitor registerVisitor(Visitor visitor) {
        visitor.setTotalPoints(0);
        Long visitorId = visitorDao.save(visitor);
        visitor.setVisitorId(visitorId);
        return visitor;
    }
    
    @Override
    public Visitor findVisitorByPhoneNumber(String phoneNumber) {
        return visitorDao.findByPhoneNumber(phoneNumber);
    }
    
    @Override
    public void updateVisitorPoints(Long visitorId, Integer points) {
        visitorDao.updatePoints(visitorId, points);
    }
    
    @Override
    public Visitor login(String phoneNumber) {
        Visitor visitor = visitorDao.findByPhoneNumber(phoneNumber);
        if (visitor != null) {
            visitorDao.updateLastLoginDate(visitor.getVisitorId());
        }
        return visitor;
    }
}