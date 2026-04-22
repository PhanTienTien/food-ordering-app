package com.tientien.foodapp.voucher.controller;

import com.tientien.foodapp.voucher.entity.Voucher;
import com.tientien.foodapp.voucher.service.VoucherService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vouchers")
@RequiredArgsConstructor
public class VoucherController {

    private final VoucherService voucherService;

    @GetMapping
    public List<Voucher> getAllVouchers() {
        return voucherService.getAllVouchers();
    }

    @GetMapping("/active")
    public List<Voucher> getActiveVouchers() {
        return voucherService.getActiveVouchers();
    }

    @GetMapping("/{id}")
    public Voucher getVoucherById(@PathVariable Long id) {
        return voucherService.getVoucherById(id);
    }

    @GetMapping("/code/{code}")
    public Voucher getVoucherByCode(@PathVariable String code) {
        return voucherService.getVoucherByCode(code);
    }

    @PostMapping
    public Voucher createVoucher(@RequestBody VoucherService.VoucherCreateRequest request) {
        return voucherService.createVoucher(request);
    }

    @PutMapping("/{id}")
    public Voucher updateVoucher(
            @PathVariable Long id,
            @RequestBody VoucherService.VoucherUpdateRequest request) {
        return voucherService.updateVoucher(id, request);
    }

    @PutMapping("/{id}/deactivate")
    public Voucher deactivateVoucher(@PathVariable Long id) {
        return voucherService.deactivateVoucher(id);
    }

    @PostMapping("/validate")
    public Double calculateDiscount(
            @RequestParam String code,
            @RequestParam Double orderAmount) {
        return voucherService.calculateDiscount(code, orderAmount);
    }

    @PostMapping("/use")
    public void useVoucher(@RequestParam String code) {
        voucherService.useVoucher(code);
    }
}
