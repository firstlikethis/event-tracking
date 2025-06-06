package th.or.studentloan.event.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import th.or.studentloan.event.model.Admin;

public class AdminDaoImpl implements AdminDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public Admin findByUsername(String username) {
        String sql = "SELECT * FROM slf_deb3.tb_admin WHERE username = ?";
        List<Admin> admins = jdbcTemplate.query(sql, new AdminRowMapper(), username);
        return admins.isEmpty() ? null : admins.get(0);
    }
    
    @Override
    public Admin findById(Long adminId) {
        String sql = "SELECT * FROM slf_deb3.tb_admin WHERE admin_id = ?";
        List<Admin> admins = jdbcTemplate.query(sql, new AdminRowMapper(), adminId);
        return admins.isEmpty() ? null : admins.get(0);
    }
    
    @Override
    public List<Admin> findAll() {
        String sql = "SELECT * FROM slf_deb3.tb_admin ORDER BY username";
        return jdbcTemplate.query(sql, new AdminRowMapper());
    }
    
    @Override
    public Long save(Admin admin) {
        // ไม่ใช้ Sequence แต่หา MAX และ +1
        String getMaxIdSql = "SELECT NVL(MAX(admin_id), 0) + 1 FROM slf_deb3.tb_admin";
        Long nextId = jdbcTemplate.queryForObject(getMaxIdSql, Long.class);
        
        String sql = "INSERT INTO slf_deb3.tb_admin (admin_id, username, password, fullname, role, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"admin_id"});
            ps.setLong(1, nextId);
            ps.setString(2, admin.getUsername());
            ps.setString(3, admin.getPassword());
            ps.setString(4, admin.getFullname());
            ps.setString(5, admin.getRole());
            ps.setString(6, admin.getIsActive());
            return ps;
        }, keyHolder);
        
        return nextId;
    }
    
    @Override
    public void update(Admin admin) {
        String sql = "UPDATE slf_deb3.tb_admin SET username = ?, password = ?, " +
                "fullname = ?, role = ?, is_active = ? WHERE admin_id = ?";
                
        jdbcTemplate.update(sql, 
            admin.getUsername(),
            admin.getPassword(),
            admin.getFullname(),
            admin.getRole(),
            admin.getIsActive(),
            admin.getAdminId());
    }
    
    @Override
    public void delete(Long adminId) {
        String sql = "DELETE FROM slf_deb3.tb_admin WHERE admin_id = ?";
        jdbcTemplate.update(sql, adminId);
    }
    
    @Override
    public void updateLastLoginDate(Long adminId) {
        String sql = "UPDATE slf_deb3.tb_admin SET last_login_date = SYSTIMESTAMP WHERE admin_id = ?";
        jdbcTemplate.update(sql, adminId);
    }
    
    private static class AdminRowMapper implements RowMapper<Admin> {
        @Override
        public Admin mapRow(ResultSet rs, int rowNum) throws SQLException {
            Admin admin = new Admin();
            admin.setAdminId(rs.getLong("admin_id"));
            admin.setUsername(rs.getString("username"));
            admin.setPassword(rs.getString("password"));
            admin.setFullname(rs.getString("fullname"));
            admin.setRole(rs.getString("role"));
            admin.setCreatedDate(rs.getTimestamp("created_date"));
            admin.setLastLoginDate(rs.getTimestamp("last_login_date"));
            admin.setIsActive(rs.getString("is_active"));
            return admin;
        }
    }
}