package th.or.studentloan.event.dao;

import java.util.List;

import th.or.studentloan.event.model.Admin;

public interface AdminDao {
    Admin findByUsername(String username);
    Admin findById(Long adminId);
    List<Admin> findAll();
    Long save(Admin admin);
    void update(Admin admin);
    void delete(Long adminId);
    void updateLastLoginDate(Long adminId);
}