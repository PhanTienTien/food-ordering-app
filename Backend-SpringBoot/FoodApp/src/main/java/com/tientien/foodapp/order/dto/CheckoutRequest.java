package com.tientien.foodapp.order.dto;

import com.tientien.foodapp.common.enums.PaymentMethod;
import lombok.Data;

@Data
public class CheckoutRequest {
    private Long userId;
    private String shippingAddress;
    private String phoneNumber;
    private String note;
    private PaymentMethod paymentMethod;
    private String voucherCode;
}
