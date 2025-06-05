package th.or.studentloan.event.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import th.or.studentloan.event.dao.AdminDao;
import th.or.studentloan.event.model.Admin;

public class AdminServiceImpl implements AdminService {
    private AdminDao adminDao;
    
    public void setAdminDao(AdminDao adminDao) {
        this.adminDao = adminDao;
    }
    
    @Override
    public Admin login(String username, String password) {
        Admin admin = adminDao.findByUsername(username);
        
        if (admin != null && "1".equals(admin.getIsActive()) && isValidPassword(password, admin.getPassword())) {
            adminDao.updateLastLoginDate(admin.getAdminId());
            return admin;
        }
        
        return null;
    }
    
    @Override
    public List<Admin> getAllAdmins() {
        return adminDao.findAll();
    }
    
    @Override
    public Admin getAdminById(Long adminId) {
        return adminDao.findById(adminId);
    }
    
    @Override
    public Admin createAdmin(Admin admin) {
        admin.setIsActive("1");
        admin.setPassword(encryptPassword(admin.getPassword()));
        
        Long adminId = adminDao.save(admin);
        admin.setAdminId(adminId);
        
        return admin;
    }
    
    @Override
    public void updateAdmin(Admin admin) {
        // ถ้ารหัสผ่านถูกส่งมาเป็นค่าว่าง ไม่ต้องอัพเดทรหัสผ่าน
        if (admin.getPassword() != null && !admin.getPassword().isEmpty()) {
            admin.setPassword(encryptPassword(admin.getPassword()));
        } else {
            // ดึงรหัสผ่านเดิม
            Admin existingAdmin = adminDao.findById(admin.getAdminId());
            admin.setPassword(existingAdmin.getPassword());
        }
        
        adminDao.update(admin);
    }
    
    @Override
    public void deleteAdmin(Long adminId) {
        adminDao.delete(adminId);
    }
    
    @Override
    public boolean isValidPassword(String rawPassword, String storedPassword) {
        return encryptPassword(rawPassword).equals(storedPassword);
    }
    
    @Override
    public String encryptPassword(String rawPassword) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(
                    rawPassword.getBytes(StandardCharsets.UTF_8));
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}