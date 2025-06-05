package th.or.studentloan.event.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import th.or.studentloan.event.model.OTP;

public class OtpDaoImpl implements OtpDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public OTP findByPhoneNumberAndCode(String phoneNumber, String otpCode) {
        String sql = "SELECT * FROM slf_deb3.tb_otp WHERE phone_number = ? AND otp_code = ? " +
                "AND is_used = '0' AND expired_date > SYSTIMESTAMP";
                
        List<OTP> otpList = jdbcTemplate.query(sql, new OtpRowMapper(), phoneNumber, otpCode);
        return otpList.isEmpty() ? null : otpList.get(0);
    }
    
    @Override
    public Long save(OTP otp) {
        String sql = "INSERT INTO slf_deb3.tb_otp (otp_id, phone_number, otp_code, expired_date, is_used) " +
                "VALUES (slf_deb3.tb_otp_seq.NEXTVAL, ?, ?, ?, '0')";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"otp_id"});
            ps.setString(1, otp.getPhoneNumber());
            ps.setString(2, otp.getOtpCode());
            ps.setTimestamp(3, new Timestamp(otp.getExpiredDate().getTime()));
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }
    
    @Override
    public void markAsUsed(Long otpId) {
        String sql = "UPDATE slf_deb3.tb_otp SET is_used = '1' WHERE otp_id = ?";
        jdbcTemplate.update(sql, otpId);
    }
    
    @Override
    public void deleteExpiredOTPs() {
        String sql = "DELETE FROM slf_deb3.tb_otp WHERE expired_date < SYSTIMESTAMP";
        jdbcTemplate.update(sql);
    }
    
    private static class OtpRowMapper implements RowMapper<OTP> {
        @Override
        public OTP mapRow(ResultSet rs, int rowNum) throws SQLException {
            OTP otp = new OTP();
            otp.setOtpId(rs.getLong("otp_id"));
            otp.setPhoneNumber(rs.getString("phone_number"));
            otp.setOtpCode(rs.getString("otp_code"));
            otp.setCreatedDate(rs.getTimestamp("created_date"));
            otp.setExpiredDate(rs.getTimestamp("expired_date"));
            otp.setIsUsed(rs.getString("is_used"));
            return otp;
        }
    }
}