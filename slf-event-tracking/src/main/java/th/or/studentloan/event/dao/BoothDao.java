package th.or.studentloan.event.dao;

import th.or.studentloan.event.model.Booth;

import java.util.List;

public interface BoothDao {
    List<Booth> findAllActive();
    Booth findById(Long boothId);
    Long save(Booth booth);
    void update(Booth booth);
    void delete(Long boothId);
    void setActive(Long boothId, boolean isActive);
}