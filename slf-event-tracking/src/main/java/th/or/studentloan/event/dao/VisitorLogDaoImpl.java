package th.or.studentloan.event.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import th.or.studentloan.event.model.VisitorLog;

public class VisitorLogDaoImpl implements VisitorLogDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public List<VisitorLog> findByVisitorId(Long visitorId) {
        String sql = "SELECT vl.*, b.booth_name FROM slf_deb3.tb_visitor_log vl " +
                "JOIN slf_deb3.tb_booth b ON vl.booth_id = b.booth_id " +
                "WHERE vl.visitor_id = ? ORDER BY vl.scan_date DESC";
                
        return jdbcTemplate.query(sql, new VisitorLogRowMapper(), visitorId);
    }
    
    @Override
    public boolean hasVisitorScannedBooth(Long visitorId, Long boothId) {
        String sql = "SELECT COUNT(*) FROM slf_deb3.tb_visitor_log WHERE visitor_id = ? AND booth_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, visitorId, boothId);
        return count != null && count > 0;
    }
    
    @Override
    public Long save(VisitorLog visitorLog) {
        String sql = "INSERT INTO slf_deb3.tb_visitor_log (log_id, visitor_id, booth_id, points_earned) " +
                "VALUES (slf_deb3.tb_visitor_log_seq.NEXTVAL, ?, ?, ?)";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"log_id"});
            ps.setLong(1, visitorLog.getVisitorId());
            ps.setLong(2, visitorLog.getBoothId());
            ps.setInt(3, visitorLog.getPointsEarned());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }
    
    private static class VisitorLogRowMapper implements RowMapper<VisitorLog> {
        @Override
        public VisitorLog mapRow(ResultSet rs, int rowNum) throws SQLException {
            VisitorLog visitorLog = new VisitorLog();
            visitorLog.setLogId(rs.getLong("log_id"));
            visitorLog.setVisitorId(rs.getLong("visitor_id"));
            visitorLog.setBoothId(rs.getLong("booth_id"));
            visitorLog.setPointsEarned(rs.getInt("points_earned"));
            visitorLog.setScanDate(rs.getTimestamp("scan_date"));
            visitorLog.setBoothName(rs.getString("booth_name"));
            return visitorLog;
        }
    }
}