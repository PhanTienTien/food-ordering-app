package com.tientien.foodapp.tracking.dto;

import lombok.Data;

@Data
public class LocationUpdateDTO {
    private Long orderId;
    private Double latitude;
    private Double longitude;
    private String status;
    private String timestamp;
}
