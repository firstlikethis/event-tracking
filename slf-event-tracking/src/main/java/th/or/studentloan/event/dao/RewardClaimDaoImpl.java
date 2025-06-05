package th.or.studentloan.event.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import th.or.studentloan.event.model.RewardClaim;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class RewardClaimDaoImpl implements RewardClaimDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public List<RewardClaim> findAll() {
        String sql = "SELECT rc.*, v.fullname AS visitor_name, r.reward_name " +
                "FROM slf_deb3.tb_reward_claim rc " +
                "JOIN slf_deb3.tb_visitor v ON rc.visitor_id = v.visitor_id " +
                "JOIN slf_deb3.tb_reward r ON rc.reward_id = r.reward_id " +
                "ORDER BY rc.claim_date DESC";
        return jdbcTemplate.query(sql, new RewardClaimRowMapper());
    }
    
    @Override
    public List<RewardClaim> findByVisitorId(Long visitorId) {
        String sql = "SELECT rc.*, v.fullname AS visitor_name, r.reward_name " +
                "FROM slf_deb3.tb_reward_claim rc " +
                "JOIN slf_deb3.tb_visitor v ON rc.visitor_id = v.visitor_id " +
                "JOIN slf_deb3.tb_reward r ON rc.reward_id = r.reward_id " +
                "WHERE rc.visitor_id = ? " +
                "ORDER BY rc.claim_date DESC";
        return jdbcTemplate.query(sql, new RewardClaimRowMapper(), visitorId);
    }
    
    @Override
    public RewardClaim findById(Long claimId) {
        String sql = "SELECT rc.*, v.fullname AS visitor_name, r.reward_name " +
                "FROM slf_deb3.tb_reward_claim rc " +
                "JOIN slf_deb3.tb_visitor v ON rc.visitor_id = v.visitor_id " +
                "JOIN slf_deb3.tb_reward r ON rc.reward_id = r.reward_id " +
                "WHERE rc.claim_id = ?";
        List<RewardClaim> claims = jdbcTemplate.query(sql, new RewardClaimRowMapper(), claimId);
        return claims.isEmpty() ? null : claims.get(0);
    }
    
    @Override
    public List<RewardClaim> findPendingClaims() {
        String sql = "SELECT rc.*, v.fullname AS visitor_name, r.reward_name " +
                "FROM slf_deb3.tb_reward_claim rc " +
                "JOIN slf_deb3.tb_visitor v ON rc.visitor_id = v.visitor_id " +
                "JOIN slf_deb3.tb_reward r ON rc.reward_id = r.reward_id " +
                "WHERE rc.is_received = '0' " +
                "ORDER BY rc.claim_date";
        return jdbcTemplate.query(sql, new RewardClaimRowMapper());
    }
    
    @Override
    public Long save(RewardClaim rewardClaim) {
        String sql = "INSERT INTO slf_deb3.tb_reward_claim (claim_id, visitor_id, reward_id, " +
                "points_used, is_lucky_draw, is_received) " +
                "VALUES (slf_deb3.tb_reward_claim_seq.NEXTVAL, ?, ?, ?, ?, '0')";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"claim_id"});
            ps.setLong(1, rewardClaim.getVisitorId());
            ps.setLong(2, rewardClaim.getRewardId());
            ps.setInt(3, rewardClaim.getPointsUsed());
            ps.setString(4, rewardClaim.getIsLuckyDraw());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }
    
    @Override
    public void markAsReceived(Long claimId) {
        String sql = "UPDATE slf_deb3.tb_reward_claim SET is_received = '1', " +
                "received_date = SYSTIMESTAMP WHERE claim_id = ?";
        jdbcTemplate.update(sql, claimId);
    }
    
    @Override
    public List<RewardClaim> findWinnersByRewardId(Long rewardId) {
        String sql = "SELECT rc.*, v.fullname AS visitor_name, r.reward_name " +
                "FROM slf_deb3.tb_reward_claim rc " +
                "JOIN slf_deb3.tb_visitor v ON rc.visitor_id = v.visitor_id " +
                "JOIN slf_deb3.tb_reward r ON rc.reward_id = r.reward_id " +
                "WHERE rc.reward_id = ? AND rc.is_lucky_draw = '1' " +
                "ORDER BY rc.claim_date DESC";
        return jdbcTemplate.query(sql, new RewardClaimRowMapper(), rewardId);
    }
    
    @Override
    public List<Long> findVisitorsEligibleForLuckyDraw(Integer minPoints, List<String> eligibleTypes) {
        // สร้าง IN clause สำหรับ eligibleTypes
        String typeClause = String.join(",", eligibleTypes.stream().map(type -> "'" + type + "'").toArray(String[]::new));
        
        String sql = "SELECT visitor_id FROM slf_deb3.tb_visitor " +
                "WHERE total_points >= ? AND visitor_type IN (" + typeClause + ")";
                
        return jdbcTemplate.queryForList(sql, Long.class, minPoints);
    }
    
    private static class RewardClaimRowMapper implements RowMapper<RewardClaim> {
        @Override
        public RewardClaim mapRow(ResultSet rs, int rowNum) throws SQLException {
            RewardClaim claim = new RewardClaim();
            claim.setClaimId(rs.getLong("claim_id"));
            claim.setVisitorId(rs.getLong("visitor_id"));
            claim.setRewardId(rs.getLong("reward_id"));
            claim.setPointsUsed(rs.getInt("points_used"));
            claim.setClaimDate(rs.getTimestamp("claim_date"));
            claim.setIsLuckyDraw(rs.getString("is_lucky_draw"));
            claim.setIsReceived(rs.getString("is_received"));
            claim.setReceivedDate(rs.getTimestamp("received_date"));
            
            // ข้อมูลเพิ่มเติมสำหรับการแสดงผล
            try {
                claim.setVisitorName(rs.getString("visitor_name"));
                claim.setRewardName(rs.getString("reward_name"));
            } catch (SQLException e) {
                // อาจไม่มีคอลัมน์นี้ในบางกรณี
            }
            
            return claim;
        }
    }
}