package com.tientien.foodapp.shipper.repository;

import com.tientien.foodapp.shipper.entity.Shipper;
import com.tientien.foodapp.shipper.enums.ShipperStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ShipperRepository extends JpaRepository<Shipper, Long> {
    List<Shipper> findByStatus(ShipperStatus status);
    List<Shipper> findByIsAvailableTrue();
}
