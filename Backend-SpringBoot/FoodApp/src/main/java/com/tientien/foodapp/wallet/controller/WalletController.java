package com.tientien.foodapp.wallet.controller;

import com.tientien.foodapp.wallet.entity.Wallet;
import com.tientien.foodapp.wallet.entity.WalletTransaction;
import com.tientien.foodapp.wallet.service.WalletService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/wallets")
@RequiredArgsConstructor
public class WalletController {

    private final WalletService walletService;

    @GetMapping("/user/{userId}")
    public Wallet getWalletByUser(@PathVariable Long userId) {
        return walletService.getWalletByUser(userId);
    }

    @PostMapping("/user/{userId}")
    public Wallet createWallet(@PathVariable Long userId) {
        return walletService.createWallet(userId);
    }

    @PostMapping("/user/{userId}/deposit")
    public Wallet addBalance(
            @PathVariable Long userId,
            @RequestParam Double amount,
            @RequestParam String description) {
        return walletService.addBalance(userId, amount, description);
    }

    @PostMapping("/user/{userId}/deduct")
    public Wallet deductBalance(
            @PathVariable Long userId,
            @RequestParam Double amount,
            @RequestParam String description,
            @RequestParam(required = false) Long referenceId,
            @RequestParam(required = false) String referenceType) {
        return walletService.deductBalance(userId, amount, description, referenceId, referenceType);
    }

    @PostMapping("/user/{userId}/points/add")
    public Wallet addPoints(
            @PathVariable Long userId,
            @RequestParam Integer points) {
        return walletService.addPoints(userId, points);
    }

    @PostMapping("/user/{userId}/points/redeem")
    public Wallet redeemPoints(
            @PathVariable Long userId,
            @RequestParam Integer points) {
        return walletService.redeemPoints(userId, points);
    }

    @GetMapping("/user/{userId}/transactions")
    public List<WalletTransaction> getTransactionHistory(@PathVariable Long userId) {
        return walletService.getTransactionHistory(userId);
    }
}
