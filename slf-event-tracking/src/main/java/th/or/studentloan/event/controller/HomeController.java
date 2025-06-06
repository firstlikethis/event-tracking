package th.or.studentloan.event.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import th.or.studentloan.event.service.VisitorService;

public class HomeController extends AbstractController {
    private VisitorService visitorService;
    
    public void setVisitorService(VisitorService visitorService) {
        this.visitorService = visitorService;
    }
    
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("views/home");
    }
}