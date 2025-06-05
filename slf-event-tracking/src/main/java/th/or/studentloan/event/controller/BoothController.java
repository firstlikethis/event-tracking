package th.or.studentloan.event.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.model.Booth;
import th.or.studentloan.event.model.Visitor;
import th.or.studentloan.event.service.BoothService;
import th.or.studentloan.event.service.VisitorService;

public class BoothController extends AbstractController {
    private BoothService boothService;
    private VisitorService visitorService;
    
    public void setBoothService(BoothService boothService) {
        this.boothService = boothService;
    }
    
    public void setVisitorService(VisitorService visitorService) {
        this.visitorService = visitorService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (path.equals("/scan-qr")) {
            return handleScanQR(request);
        } else if (path.startsWith("/scan-result")) {
            return handleScanResult(request);
        }
        
        return new ModelAndView("redirect:/dashboard");
    }
    
    private ModelAndView handleScanQR(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String qrData = request.getParameter("qrData");
            
            if (qrData != null && qrData.startsWith("booth:")) {
                Long boothId = Long.parseLong(qrData.substring(6));
                
                boolean success = boothService.scanBoothQR(visitor.getVisitorId(), boothId);
                
                if (success) {
                    Booth booth = boothService.getBoothById(boothId);
                    
                    // Refresh visitor data
                    visitor = visitorService.findVisitorByPhoneNumber(visitor.getPhoneNumber());
                    session.setAttribute("visitor", visitor);
                    
                    ModelAndView mv = new ModelAndView("scan-result");
                    mv.addObject("success", true);
                    mv.addObject("booth", booth);
                    return mv;
                } else {
                    ModelAndView mv = new ModelAndView("scan-result");
                    mv.addObject("success", false);
                    mv.addObject("message", "คุณเคยสแกนบูธนี้แล้ว หรือบูธไม่ถูกต้อง");
                    return mv;
                }
            }
        }
        
        return new ModelAndView("scan-qr");
    }
    
    private ModelAndView handleScanResult(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Visitor visitor = (Visitor) session.getAttribute("visitor");
        
        if (visitor == null) {
            return new ModelAndView("redirect:/");
        }
        
        return new ModelAndView("scan-result");
    }
}