package com.tientien.foodapp.shipper.controller;

import com.tientien.foodapp.shipper.entity.Shipper;
import com.tientien.foodapp.shipper.enums.ShipperStatus;
import com.tientien.foodapp.shipper.repository.ShipperRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shippers")
@RequiredArgsConstructor
public class ShipperController {

    private final ShipperRepository shipperRepository;

    @GetMapping
    public List<Shipper> getAllShippers() {
        return shipperRepository.findAll();
    }

    @GetMapping("/{id}")
    public Shipper getShipperById(@PathVariable Long id) {
        return shipperRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Shipper not found"));
    }

    @GetMapping("/available")
    public List<Shipper> getAvailableShippers() {
        return shipperRepository.findByIsAvailableTrue();
    }

    @GetMapping("/status/{status}")
    public List<Shipper> getShippersByStatus(@PathVariable ShipperStatus status) {
        return shipperRepository.findByStatus(status);
    }

    @PostMapping
    public Shipper createShipper(@RequestBody Shipper shipper) {
        return shipperRepository.save(shipper);
    }

    @PutMapping("/{id}")
    public Shipper updateShipper(
            @PathVariable Long id,
            @RequestBody Shipper shipper) {
        Shipper existing = getShipperById(id);
        
        if (shipper.getName() != null) existing.setName(shipper.getName());
        if (shipper.getPhone() != null) existing.setPhone(shipper.getPhone());
        if (shipper.getEmail() != null) existing.setEmail(shipper.getEmail());
        if (shipper.getLicensePlate() != null) existing.setLicensePlate(shipper.getLicensePlate());
        if (shipper.getVehicleType() != null) existing.setVehicleType(shipper.getVehicleType());
        if (shipper.getStatus() != null) existing.setStatus(shipper.getStatus());
        if (shipper.getLatitude() != null) existing.setLatitude(shipper.getLatitude());
        if (shipper.getLongitude() != null) existing.setLongitude(shipper.getLongitude());
        if (shipper.getIsAvailable() != null) existing.setIsAvailable(shipper.getIsAvailable());
        if (shipper.getRating() != null) existing.setRating(shipper.getRating());
        if (shipper.getTotalDeliveries() != null) existing.setTotalDeliveries(shipper.getTotalDeliveries());

        return shipperRepository.save(existing);
    }

    @PutMapping("/{id}/location")
    public Shipper updateLocation(
            @PathVariable Long id,
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        Shipper shipper = getShipperById(id);
        shipper.setLatitude(latitude);
        shipper.setLongitude(longitude);
        return shipperRepository.save(shipper);
    }

    @PutMapping("/{id}/status")
    public Shipper updateStatus(
            @PathVariable Long id,
            @RequestParam ShipperStatus status) {
        Shipper shipper = getShipperById(id);
        shipper.setStatus(status);
        return shipperRepository.save(shipper);
    }

    @PutMapping("/{id}/availability")
    public Shipper updateAvailability(
            @PathVariable Long id,
            @RequestParam Boolean isAvailable) {
        Shipper shipper = getShipperById(id);
        shipper.setIsAvailable(isAvailable);
        return shipperRepository.save(shipper);
    }

    @DeleteMapping("/{id}")
    public void deleteShipper(@PathVariable Long id) {
        Shipper shipper = getShipperById(id);
        shipperRepository.delete(shipper);
    }
}
