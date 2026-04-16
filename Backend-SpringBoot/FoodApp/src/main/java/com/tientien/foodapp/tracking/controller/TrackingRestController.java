package com.tientien.foodapp.tracking.controller;

import com.tientien.foodapp.tracking.dto.LocationUpdateDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/tracking")
@RequiredArgsConstructor
public class TrackingRestController {

    private final TrackingController trackingController;

    // REST endpoint to update location (for testing without WebSocket client)
    @PostMapping("/{orderId}/update")
    public void updateLocationRest(
            @PathVariable Long orderId,
            @RequestBody LocationUpdateDTO locationUpdate) {
        
        locationUpdate.setOrderId(orderId);
        trackingController.sendLocationUpdate(orderId, locationUpdate);
    }

    // Get last known location (simplified - in production, use Redis/database)
    @GetMapping("/{orderId}")
    public LocationUpdateDTO getCurrentLocation(@PathVariable Long orderId) {
        // This is a placeholder - in production, fetch from cache/database
        LocationUpdateDTO dto = new LocationUpdateDTO();
        dto.setOrderId(orderId);
        dto.setLatitude(21.0285);
        dto.setLongitude(105.8542);
        dto.setStatus("IN_PROGRESS");
        return dto;
    }
}
