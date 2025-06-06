package th.or.studentloan.event.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.model.OTP;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.model.VisitorLog;
import th.or.studentloan.event.service.BoothService;
import th.or.studentloan.event.service.OtpService;
import th.or.studentloan.event.service.VisitorService;

public class VisitorController extends AbstractController {
    private VisitorService visitorService;
    private OtpService otpService;
    private BoothService boothService;
    
    public void setVisitorService(VisitorService visitorService) {
        this.visitorService = visitorService;
    }
    
    public void setOtpService(OtpService otpService) {
        this.otpService = otpService;
    }
    
    public void setBoothService(BoothService boothService) {
        this.boothService = boothService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (path.equals("/register")) {
            return handleRegister(request);
        } else if (path.equals("/login")) {
            return handleLogin(request);
        } else if (path.equals("/verify-otp")) {
            return handleVerifyOtp(request);
        } else if (path.equals("/dashboard")) {
            return handleDashboard(request);
        } else if (path.equals("/logout")) {
            return handleLogout(request);
        }
        
        return new ModelAndView("redirect:/");
    }
    
    private ModelAndView handleRegister(HttpServletRequest request) {
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String fullname = request.getParameter("fullname");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String visitorType = request.getParameter("visitorType");
            
            // Validate input
            if (fullname == null || fullname.trim().isEmpty() || 
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                visitorType == null || visitorType.trim().isEmpty()) {
                
                ModelAndView mv = new ModelAndView("views/register");
                mv.addObject("error", "กรุณากรอกข้อมูลให้ครบถ้วน");
                return mv;
            }
            
            // Check if phone number is already registered
            if (visitorService.isPhoneNumberRegistered(phoneNumber)) {
                ModelAndView mv = new ModelAndView("views/register");
                mv.addObject("error", "เบอร์โทรศัพท์นี้ลงทะเบียนแล้ว กรุณาเข้าสู่ระบบ");
                return mv;
            }
            
            // Create new visitor
            Visitor visitor = new Visitor();
            visitor.setFullname(fullname);
            visitor.setPhoneNumber(phoneNumber);
            visitor.setEmail(email);
            visitor.setVisitorType(visitorType);
            visitor.setTotalPoints(0);
            
            // Save visitor to database
            visitor = visitorService.registerVisitor(visitor);
            
            // Generate and send OTP
            OTP otp = otpService.generateAndSendOTP(phoneNumber);
            
            // Store phone number in session for OTP verification
            HttpSession session = request.getSession();
            session.setAttribute("registerPhoneNumber", phoneNumber);
            
            return new ModelAndView("views/verify-otp");
        }
        
        return new ModelAndView("views/register");
    }
    
    private ModelAndView handleLogin(HttpServletRequest request) {
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String phoneNumber = request.getParameter("phoneNumber");
            
            // Validate input
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                ModelAndView mv = new ModelAndView("views/login");
                mv.addObject("error", "กรุณากรอกเบอร์โทรศัพท์");
                return mv;
            }
            
            // Check if phone number exists
            if (!visitorService.isPhoneNumberRegistered(phoneNumber)) {
                ModelAndView mv = new ModelAndView("views/login");
                mv.addObject("error", "ไม่พบเบอร์โทรศัพท์นี้ในระบบ กรุณาลงทะเบียนก่อน");
                return mv;
            }
            
            // Generate and send OTP
            OTP otp = otpService.generateAndSendOTP(phoneNumber);
            
            // Store phone number in session for OTP verification
            HttpSession session = request.getSession();
            session.setAttribute("loginPhoneNumber", phoneNumber);
            
            return new ModelAndView("views/verify-otp");
        }
        
        return new ModelAndView("views/login");
    }
    
    private ModelAndView handleVerifyOtp(HttpServletRequest request) {
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String otpCode = request.getParameter("otpCode");
            
            // Validate input
            if (otpCode == null || otpCode.trim().isEmpty()) {
                ModelAndView mv = new ModelAndView("views/verify-otp");
                mv.addObject("error", "กรุณากรอกรหัส OTP");
                return mv;
            }
            
            HttpSession session = request.getSession();
            String registerPhoneNumber = (String) session.getAttribute("registerPhoneNumber");
            String loginPhoneNumber = (String) session.getAttribute("loginPhoneNumber");
            String phoneNumber = registerPhoneNumber != null ? registerPhoneNumber : loginPhoneNumber;
            
            // Verify OTP
            boolean isValid = otpService.verifyOTP(phoneNumber, otpCode);
            
            if (!isValid) {
                ModelAndView mv = new ModelAndView("views/verify-otp");
                mv.addObject("error", "รหัส OTP ไม่ถูกต้องหรือหมดอายุแล้ว");
                return mv;
            }
            
            // OTP is valid, login user
            Visitor visitor = visitorService.findVisitorByPhoneNumber(phoneNumber);
            
            // Update last login date for login case
            if (loginPhoneNumber != null) {
                visitorService.login(phoneNumber);
            }
            
            // Store visitor in session
            session.setAttribute("visitor", visitor);
            
            // Clear phone number attributes
            session.removeAttribute("registerPhoneNumber");
            session.removeAttribute("loginPhoneNumber");
            
            return new ModelAndView("redirect:/dashboard");
        }
        
        return new ModelAndView("views/verify-otp");
    }
    
    private ModelAndView handleDashboard(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        // Get fresh visitor data
        visitor = visitorService.findVisitorByPhoneNumber(visitor.getPhoneNumber());
        session.setAttribute("visitor", visitor);
        
        // Get visitor activity logs
        List<VisitorLog> activityLogs = boothService.getVisitorLogs(visitor.getVisitorId());
        
        ModelAndView mv = new ModelAndView("views/dashboard");
        mv.addObject("visitor", visitor);
        mv.addObject("activityLogs", activityLogs);
        
        return mv;
    }
    
    private ModelAndView handleLogout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        
        return new ModelAndView("redirect:/");
    }
}