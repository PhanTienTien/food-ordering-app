package com.tientien.foodapp.voucher.service.impl;

import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.voucher.entity.Voucher;
import com.tientien.foodapp.voucher.enums.DiscountType;
import com.tientien.foodapp.voucher.enums.VoucherStatus;
import com.tientien.foodapp.voucher.repository.VoucherRepository;
import com.tientien.foodapp.voucher.service.VoucherService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VoucherServiceImpl implements VoucherService {

    private final VoucherRepository voucherRepository;
    private final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public List<Voucher> getAllVouchers() {
        return voucherRepository.findAll();
    }

    @Override
    public Voucher getVoucherById(Long id) {
        return voucherRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Voucher not found"));
    }

    @Override
    public Voucher getVoucherByCode(String code) {
        return voucherRepository.findByCode(code)
                .orElseThrow(() -> new NotFoundException("Voucher not found with code: " + code));
    }

    @Override
    public List<Voucher> getActiveVouchers() {
        LocalDateTime now = LocalDateTime.now();
        return voucherRepository.findByStatusAndStartDateBeforeAndEndDateAfter(
                VoucherStatus.ACTIVE,
                now,
                now
        );
    }

    @Override
    public Voucher createVoucher(VoucherCreateRequest request) {
        if (voucherRepository.findByCode(request.code).isPresent()) {
            throw new RuntimeException("Voucher code already exists");
        }

        Voucher voucher = new Voucher();
        voucher.setCode(request.code);
        voucher.setDiscountType(DiscountType.valueOf(request.discountType));
        voucher.setDiscountValue(request.discountValue);
        voucher.setMinOrderAmount(request.minOrderAmount != null ? request.minOrderAmount : 0.0);
        voucher.setMaxDiscountAmount(request.maxDiscountAmount);
        voucher.setStartDate(request.startDate != null ? LocalDateTime.parse(request.startDate, formatter) : null);
        voucher.setEndDate(request.endDate != null ? LocalDateTime.parse(request.endDate, formatter) : null);
        voucher.setUsageLimit(request.usageLimit);
        voucher.setUsageCount(0);
        voucher.setStatus(VoucherStatus.ACTIVE);

        return voucherRepository.save(voucher);
    }

    @Override
    public Voucher updateVoucher(Long id, VoucherUpdateRequest request) {
        Voucher voucher = getVoucherById(id);

        if (request.discountType != null) voucher.setDiscountType(DiscountType.valueOf(request.discountType));
        if (request.discountValue != null) voucher.setDiscountValue(request.discountValue);
        if (request.minOrderAmount != null) voucher.setMinOrderAmount(request.minOrderAmount);
        if (request.maxDiscountAmount != null) voucher.setMaxDiscountAmount(request.maxDiscountAmount);
        if (request.startDate != null) voucher.setStartDate(LocalDateTime.parse(request.startDate, formatter));
        if (request.endDate != null) voucher.setEndDate(LocalDateTime.parse(request.endDate, formatter));
        if (request.usageLimit != null) voucher.setUsageLimit(request.usageLimit);
        if (request.status != null) voucher.setStatus(VoucherStatus.valueOf(request.status));

        return voucherRepository.save(voucher);
    }

    @Override
    public Voucher deactivateVoucher(Long id) {
        Voucher voucher = getVoucherById(id);
        voucher.setStatus(VoucherStatus.INACTIVE);
        return voucherRepository.save(voucher);
    }

    @Override
    public Double calculateDiscount(String code, Double orderAmount) {
        Voucher voucher = getVoucherByCode(code);

        // Check if voucher is active
        if (voucher.getStatus() != VoucherStatus.ACTIVE) {
            throw new RuntimeException("Voucher is not active");
        }

        // Check date validity
        LocalDateTime now = LocalDateTime.now();
        if (voucher.getStartDate() != null && now.isBefore(voucher.getStartDate())) {
            throw new RuntimeException("Voucher is not yet valid");
        }
        if (voucher.getEndDate() != null && now.isAfter(voucher.getEndDate())) {
            throw new RuntimeException("Voucher has expired");
        }

        // Check minimum order amount
        if (orderAmount < voucher.getMinOrderAmount()) {
            throw new RuntimeException("Minimum order amount not met");
        }

        // Check usage limit
        if (voucher.getUsageLimit() != null && voucher.getUsageCount() >= voucher.getUsageLimit()) {
            throw new RuntimeException("Voucher usage limit reached");
        }

        // Calculate discount
        double discount = 0.0;
        if (voucher.getDiscountType() == DiscountType.PERCENTAGE) {
            discount = orderAmount * (voucher.getDiscountValue() / 100);
        } else {
            discount = voucher.getDiscountValue();
        }

        // Apply max discount limit
        if (voucher.getMaxDiscountAmount() != null && discount > voucher.getMaxDiscountAmount()) {
            discount = voucher.getMaxDiscountAmount();
        }

        return discount;
    }

    @Override
    public void useVoucher(String code) {
        Voucher voucher = getVoucherByCode(code);
        voucher.setUsageCount(voucher.getUsageCount() + 1);
        voucherRepository.save(voucher);
    }
}
