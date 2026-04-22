package com.tientien.foodapp.dispute.repository;

import com.tientien.foodapp.dispute.entity.Dispute;
import com.tientien.foodapp.dispute.enums.DisputeStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DisputeRepository extends JpaRepository<Dispute, Long> {
    List<Dispute> findByOrderId(Long orderId);
    List<Dispute> findByStatus(DisputeStatus status);
}
