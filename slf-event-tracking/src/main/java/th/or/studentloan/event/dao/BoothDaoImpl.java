package th.or.studentloan.event.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import th.or.studentloan.event.model.Booth;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class BoothDaoImpl implements BoothDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public List<Booth> findAllActive() {
        String sql = "SELECT * FROM slf_deb3.tb_booth WHERE is_active = '1' ORDER BY booth_name";
        return jdbcTemplate.query(sql, new BoothRowMapper());
    }
    
    @Override
    public Booth findById(Long boothId) {
        String sql = "SELECT * FROM slf_deb3.tb_booth WHERE booth_id = ?";
        List<Booth> booths = jdbcTemplate.query(sql, new BoothRowMapper(), boothId);
        return booths.isEmpty() ? null : booths.get(0);
    }
    
    @Override
    public Long save(Booth booth) {
        String sql = "INSERT INTO slf_deb3.tb_booth (booth_id, booth_name, booth_description, points, qr_code_url, is_active) " +
                "VALUES (slf_deb3.tb_booth_seq.NEXTVAL, ?, ?, ?, ?, ?)";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"booth_id"});
            ps.setString(1, booth.getBoothName());
            ps.setString(2, booth.getBoothDescription());
            ps.setInt(3, booth.getPoints());
            ps.setString(4, booth.getQrCodeUrl());
            ps.setString(5, booth.getIsActive());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }
    
    @Override
    public void update(Booth booth) {
        String sql = "UPDATE slf_deb3.tb_booth SET booth_name = ?, booth_description = ?, " +
                "points = ?, qr_code_url = ?, updated_date = SYSTIMESTAMP, is_active = ? " +
                "WHERE booth_id = ?";
                
        jdbcTemplate.update(sql, 
            booth.getBoothName(),
            booth.getBoothDescription(),
            booth.getPoints(),
            booth.getQrCodeUrl(),
            booth.getIsActive(),
            booth.getBoothId());
    }
    
    @Override
    public void delete(Long boothId) {
        String sql = "DELETE FROM slf_deb3.tb_booth WHERE booth_id = ?";
        jdbcTemplate.update(sql, boothId);
    }
    
    @Override
    public void setActive(Long boothId, boolean isActive) {
        String sql = "UPDATE slf_deb3.tb_booth SET is_active = ?, updated_date = SYSTIMESTAMP WHERE booth_id = ?";
        jdbcTemplate.update(sql, isActive ? "1" : "0", boothId);
    }
    
    private static class BoothRowMapper implements RowMapper<Booth> {
        @Override
        public Booth mapRow(ResultSet rs, int rowNum) throws SQLException {
            Booth booth = new Booth();
            booth.setBoothId(rs.getLong("booth_id"));
            booth.setBoothName(rs.getString("booth_name"));
            booth.setBoothDescription(rs.getString("booth_description"));
            booth.setPoints(rs.getInt("points"));
            booth.setQrCodeUrl(rs.getString("qr_code_url"));
            booth.setCreatedDate(rs.getTimestamp("created_date"));
            booth.setUpdatedDate(rs.getTimestamp("updated_date"));
            booth.setIsActive(rs.getString("is_active"));
            return booth;
        }
    }
}