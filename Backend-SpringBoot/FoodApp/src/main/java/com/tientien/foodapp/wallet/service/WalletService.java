package com.tientien.foodapp.wallet.service;

import com.tientien.foodapp.wallet.entity.Wallet;
import com.tientien.foodapp.wallet.entity.WalletTransaction;
import com.tientien.foodapp.wallet.enums.TransactionType;

import java.util.List;

public interface WalletService {
    Wallet getWalletByUser(Long userId);
    Wallet createWallet(Long userId);
    Wallet addBalance(Long userId, Double amount, String description);
    Wallet deductBalance(Long userId, Double amount, String description, Long referenceId, String referenceType);
    Wallet addPoints(Long userId, Integer points);
    Wallet redeemPoints(Long userId, Integer points);
    List<WalletTransaction> getTransactionHistory(Long userId);
}
