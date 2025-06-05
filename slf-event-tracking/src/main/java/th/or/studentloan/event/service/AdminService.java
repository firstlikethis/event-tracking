package th.or.studentloan.event.service;

import th.or.studentloan.event.model.Admin;

import java.util.List;

public interface AdminService {
    Admin login(String username, String password);
    List<Admin> getAllAdmins();
    Admin getAdminById(Long adminId);
    Admin createAdmin(Admin admin);
    void updateAdmin(Admin admin);
    void deleteAdmin(Long adminId);
    boolean isValidPassword(String rawPassword, String storedPassword);
    String encryptPassword(String rawPassword);
}