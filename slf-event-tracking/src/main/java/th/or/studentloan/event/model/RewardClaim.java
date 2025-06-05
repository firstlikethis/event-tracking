package th.or.studentloan.event.model;

import java.util.Date;

public class RewardClaim {
    private Long claimId;
    private Long visitorId;
    private Long rewardId;
    private Integer pointsUsed;
    private Date claimDate;
    private String isLuckyDraw;  // 0=แลกทันที, 1=ได้จากการสุ่ม
    private String isReceived;   // 0=ยังไม่รับ, 1=รับแล้ว
    private Date receivedDate;
    
    // สำหรับแสดงผล
    private String visitorName;
    private String rewardName;
    
    // Getters and Setters
    public Long getClaimId() {
        return claimId;
    }

    public void setClaimId(Long claimId) {
        this.claimId = claimId;
    }

    public Long getVisitorId() {
        return visitorId;
    }

    public void setVisitorId(Long visitorId) {
        this.visitorId = visitorId;
    }

    public Long getRewardId() {
        return rewardId;
    }

    public void setRewardId(Long rewardId) {
        this.rewardId = rewardId;
    }

    public Integer getPointsUsed() {
        return pointsUsed;
    }

    public void setPointsUsed(Integer pointsUsed) {
        this.pointsUsed = pointsUsed;
    }

    public Date getClaimDate() {
        return claimDate;
    }

    public void setClaimDate(Date claimDate) {
        this.claimDate = claimDate;
    }

    public String getIsLuckyDraw() {
        return isLuckyDraw;
    }

    public void setIsLuckyDraw(String isLuckyDraw) {
        this.isLuckyDraw = isLuckyDraw;
    }

    public String getIsReceived() {
        return isReceived;
    }

    public void setIsReceived(String isReceived) {
        this.isReceived = isReceived;
    }

    public Date getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getVisitorName() {
        return visitorName;
    }

    public void setVisitorName(String visitorName) {
        this.visitorName = visitorName;
    }

    public String getRewardName() {
        return rewardName;
    }

    public void setRewardName(String rewardName) {
        this.rewardName = rewardName;
    }
}