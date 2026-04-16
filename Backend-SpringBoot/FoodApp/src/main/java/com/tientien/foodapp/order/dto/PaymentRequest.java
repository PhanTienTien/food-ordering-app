package com.tientien.foodapp.order.dto;

import com.tientien.foodapp.common.enums.PaymentMethod;
import lombok.Data;

@Data
public class PaymentRequest {
    private PaymentMethod paymentMethod;
    private String transactionId;  // For online payments
    private boolean simulateSuccess; // For testing - true to simulate successful payment
}
