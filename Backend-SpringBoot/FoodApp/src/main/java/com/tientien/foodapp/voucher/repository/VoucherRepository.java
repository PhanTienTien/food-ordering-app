package com.tientien.foodapp.voucher.repository;

import com.tientien.foodapp.voucher.entity.Voucher;
import com.tientien.foodapp.voucher.enums.VoucherStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface VoucherRepository extends JpaRepository<Voucher, Long> {
    Optional<Voucher> findByCode(String code);
    List<Voucher> findByStatus(VoucherStatus status);
    List<Voucher> findByStatusAndStartDateBeforeAndEndDateAfter(
            VoucherStatus status,
            LocalDateTime startDate,
            LocalDateTime endDate
    );
}
