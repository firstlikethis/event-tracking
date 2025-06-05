package th.or.studentloan.event.dao;

import java.util.List;

import th.or.studentloan.event.model.Booth;

public interface BoothDao {
    List<Booth> findAllActive();
    Booth findById(Long boothId);
    Long save(Booth booth);
    void update(Booth booth);
    void delete(Long boothId);
    void setActive(Long boothId, boolean isActive);
}