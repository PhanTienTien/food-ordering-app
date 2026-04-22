package com.tientien.foodapp.voucher.service;

import com.tientien.foodapp.voucher.entity.Voucher;

import java.util.List;

public interface VoucherService {
    List<Voucher> getAllVouchers();
    Voucher getVoucherById(Long id);
    Voucher getVoucherByCode(String code);
    List<Voucher> getActiveVouchers();
    Voucher createVoucher(VoucherCreateRequest request);
    Voucher updateVoucher(Long id, VoucherUpdateRequest request);
    Voucher deactivateVoucher(Long id);
    Double calculateDiscount(String code, Double orderAmount);
    void useVoucher(String code);

    class VoucherCreateRequest {
        public String code;
        public String discountType;
        public Double discountValue;
        public Double minOrderAmount;
        public Double maxDiscountAmount;
        public String startDate;
        public String endDate;
        public Integer usageLimit;
    }

    class VoucherUpdateRequest {
        public String discountType;
        public Double discountValue;
        public Double minOrderAmount;
        public Double maxDiscountAmount;
        public String startDate;
        public String endDate;
        public Integer usageLimit;
        public String status;
    }
}
