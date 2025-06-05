package th.or.studentloan.event.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import th.or.studentloan.event.model.Reward;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class RewardDaoImpl implements RewardDao {
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    @Override
    public List<Reward> findAll() {
        String sql = "SELECT * FROM slf_deb3.tb_reward ORDER BY reward_name";
        return jdbcTemplate.query(sql, new RewardRowMapper());
    }
    
    @Override
    public List<Reward> findAllActive() {
        String sql = "SELECT * FROM slf_deb3.tb_reward WHERE is_active = '1' ORDER BY reward_name";
        return jdbcTemplate.query(sql, new RewardRowMapper());
    }
    
    @Override
    public Reward findById(Long rewardId) {
        String sql = "SELECT * FROM slf_deb3.tb_reward WHERE reward_id = ?";
        List<Reward> rewards = jdbcTemplate.query(sql, new RewardRowMapper(), rewardId);
        return rewards.isEmpty() ? null : rewards.get(0);
    }
    
    @Override
    public Long save(Reward reward) {
        String sql = "INSERT INTO slf_deb3.tb_reward (reward_id, reward_name, reward_description, reward_type, " +
                "points_required, quantity, remaining, is_active) " +
                "VALUES (slf_deb3.tb_reward_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";
                
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[] {"reward_id"});
            ps.setString(1, reward.getRewardName());
            ps.setString(2, reward.getRewardDescription());
            ps.setString(3, reward.getRewardType());
            ps.setInt(4, reward.getPointsRequired());
            ps.setInt(5, reward.getQuantity());
            ps.setInt(6, reward.getRemaining() != null ? reward.getRemaining() : reward.getQuantity());
            ps.setString(7, reward.getIsActive());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }
    
    @Override
    public void update(Reward reward) {
        String sql = "UPDATE slf_deb3.tb_reward SET reward_name = ?, reward_description = ?, " +
                "reward_type = ?, points_required = ?, quantity = ?, remaining = ?, " +
                "updated_date = SYSTIMESTAMP, is_active = ? " +
                "WHERE reward_id = ?";
                
        jdbcTemplate.update(sql, 
            reward.getRewardName(),
            reward.getRewardDescription(),
            reward.getRewardType(),
            reward.getPointsRequired(),
            reward.getQuantity(),
            reward.getRemaining(),
            reward.getIsActive(),
            reward.getRewardId());
    }
    
    @Override
    public void delete(Long rewardId) {
        String sql = "DELETE FROM slf_deb3.tb_reward WHERE reward_id = ?";
        jdbcTemplate.update(sql, rewardId);
    }
    
    @Override
    public void decreaseRemaining(Long rewardId) {
        String sql = "UPDATE slf_deb3.tb_reward SET remaining = remaining - 1, " +
                "updated_date = SYSTIMESTAMP WHERE reward_id = ? AND remaining > 0";
        jdbcTemplate.update(sql, rewardId);
    }
    
    @Override
    public List<Reward> findAvailableForExchange() {
        String sql = "SELECT * FROM slf_deb3.tb_reward WHERE is_active = '1' AND reward_type = '2' " +
                "AND remaining > 0 ORDER BY points_required";
        return jdbcTemplate.query(sql, new RewardRowMapper());
    }
    
    @Override
    public List<Reward> findAvailableForLuckyDraw(String visitorType) {
        // ประเภทผู้เข้าร่วมที่มีสิทธิ์ลุ้นรางวัล: 1,2,3,4
        if (visitorType.equals("5") || visitorType.equals("6")) {
            return List.of();  // ไม่มีสิทธิ์ลุ้นรางวัล
        }
        
        String sql = "SELECT * FROM slf_deb3.tb_reward WHERE is_active = '1' AND reward_type = '1' " +
                "AND remaining > 0 ORDER BY points_required";
        return jdbcTemplate.query(sql, new RewardRowMapper());
    }
    
    private static class RewardRowMapper implements RowMapper<Reward> {
        @Override
        public Reward mapRow(ResultSet rs, int rowNum) throws SQLException {
            Reward reward = new Reward();
            reward.setRewardId(rs.getLong("reward_id"));
            reward.setRewardName(rs.getString("reward_name"));
            reward.setRewardDescription(rs.getString("reward_description"));
            reward.setRewardType(rs.getString("reward_type"));
            reward.setPointsRequired(rs.getInt("points_required"));
            reward.setQuantity(rs.getInt("quantity"));
            reward.setRemaining(rs.getInt("remaining"));
            reward.setCreatedDate(rs.getTimestamp("created_date"));
            reward.setUpdatedDate(rs.getTimestamp("updated_date"));
            reward.setIsActive(rs.getString("is_active"));
            return reward;
        }
    }
}