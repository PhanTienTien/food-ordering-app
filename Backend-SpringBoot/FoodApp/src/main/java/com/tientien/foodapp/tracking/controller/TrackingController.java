package com.tientien.foodapp.tracking.controller;

import com.tientien.foodapp.tracking.dto.LocationUpdateDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class TrackingController {

    private final SimpMessagingTemplate messagingTemplate;

    // Driver updates location
    @MessageMapping("/tracking/{orderId}/update")
    @SendTo("/topic/tracking/{orderId}")
    public LocationUpdateDTO updateLocation(
            @DestinationVariable Long orderId,
            @Payload LocationUpdateDTO locationUpdate) {
        
        locationUpdate.setOrderId(orderId);
        return locationUpdate;
    }

    // Driver marks order as delivered
    @MessageMapping("/tracking/{orderId}/delivered")
    @SendTo("/topic/tracking/{orderId}")
    public LocationUpdateDTO markDelivered(
            @DestinationVariable Long orderId) {
        
        LocationUpdateDTO update = new LocationUpdateDTO();
        update.setOrderId(orderId);
        update.setStatus("DELIVERED");
        return update;
    }

    // Method to send updates programmatically
    public void sendLocationUpdate(Long orderId, LocationUpdateDTO locationUpdate) {
        messagingTemplate.convertAndSend("/topic/tracking/" + orderId, locationUpdate);
    }
}
