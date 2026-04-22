package com.tientien.foodapp.banner.repository;

import com.tientien.foodapp.banner.entity.Banner;
import com.tientien.foodapp.banner.enums.BannerStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface BannerRepository extends JpaRepository<Banner, Long> {
    List<Banner> findByStatus(BannerStatus status);
    List<Banner> findByStatusOrderByDisplayOrderAsc(BannerStatus status);
    List<Banner> findByStatusAndStartDateBeforeAndEndDateAfter(
            BannerStatus status,
            LocalDateTime startDate,
            LocalDateTime endDate
    );
}
