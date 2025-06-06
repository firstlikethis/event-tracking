package th.or.studentloan.event.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import th.or.studentloan.event.model.Visitor;

public class VisitorDaoImpl implements VisitorDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public Visitor findByPhoneNumber(String phoneNumber) {
        String sql = "SELECT * FROM slf_deb3.tb_visitor WHERE phone_number = ?";
        List<Visitor> visitors = jdbcTemplate.query(sql, new VisitorRowMapper(), phoneNumber);
        return visitors.isEmpty() ? null : visitors.get(0);
    }
    
    @Override
    public Visitor findById(Long visitorId) {
        String sql = "SELECT * FROM slf_deb3.tb_visitor WHERE visitor_id = ?";
        List<Visitor> visitors = jdbcTemplate.query(sql, new VisitorRowMapper(), visitorId);
        return visitors.isEmpty() ? null : visitors.get(0);
    }
    
    @Override
    public Long save(Visitor visitor) {
        // ไม่ใช้ Sequence แต่หา MAX และ +1
        String getMaxIdSql = "SELECT NVL(MAX(visitor_id), 0) + 1 FROM slf_deb3.tb_visitor";
        Long nextId = jdbcTemplate.queryForObject(getMaxIdSql, Long.class);
        
        String sql = "INSERT INTO slf_deb3.tb_visitor (visitor_id, fullname, phone_number, email, visitor_type, total_points) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"visitor_id"});
            ps.setLong(1, nextId);
            ps.setString(2, visitor.getFullname());
            ps.setString(3, visitor.getPhoneNumber());
            ps.setString(4, visitor.getEmail());
            ps.setString(5, visitor.getVisitorType());
            ps.setInt(6, visitor.getTotalPoints() != null ? visitor.getTotalPoints() : 0);
            return ps;
        }, keyHolder);
        
        return nextId;
    }
    
    @Override
    public void update(Visitor visitor) {
        String sql = "UPDATE slf_deb3.tb_visitor SET fullname = ?, phone_number = ?, email = ?, " +
                "visitor_type = ?, total_points = ? WHERE visitor_id = ?";
                
        jdbcTemplate.update(sql, 
            visitor.getFullname(),
            visitor.getPhoneNumber(),
            visitor.getEmail(),
            visitor.getVisitorType(),
            visitor.getTotalPoints(),
            visitor.getVisitorId());
    }
    
    @Override
    public void updatePoints(Long visitorId, Integer points) {
        String sql = "UPDATE slf_deb3.tb_visitor SET total_points = total_points + ? WHERE visitor_id = ?";
        jdbcTemplate.update(sql, points, visitorId);
    }
    
    @Override
    public void updateLastLoginDate(Long visitorId) {
        String sql = "UPDATE slf_deb3.tb_visitor SET last_login_date = SYSTIMESTAMP WHERE visitor_id = ?";
        jdbcTemplate.update(sql, visitorId);
    }
    
    private static class VisitorRowMapper implements RowMapper<Visitor> {
        @Override
        public Visitor mapRow(ResultSet rs, int rowNum) throws SQLException {
            Visitor visitor = new Visitor();
            visitor.setVisitorId(rs.getLong("visitor_id"));
            visitor.setFullname(rs.getString("fullname"));
            visitor.setPhoneNumber(rs.getString("phone_number"));
            visitor.setEmail(rs.getString("email"));
            visitor.setVisitorType(rs.getString("visitor_type"));
            visitor.setTotalPoints(rs.getInt("total_points"));
            visitor.setRegistrationDate(rs.getTimestamp("registration_date"));
            visitor.setLastLoginDate(rs.getTimestamp("last_login_date"));
            return visitor;
        }
    }
}