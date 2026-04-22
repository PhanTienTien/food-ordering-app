package com.tientien.foodapp.wallet.service.impl;

import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import com.tientien.foodapp.wallet.entity.Wallet;
import com.tientien.foodapp.wallet.entity.WalletTransaction;
import com.tientien.foodapp.wallet.enums.TransactionType;
import com.tientien.foodapp.wallet.repository.WalletRepository;
import com.tientien.foodapp.wallet.repository.WalletTransactionRepository;
import com.tientien.foodapp.wallet.service.WalletService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class WalletServiceImpl implements WalletService {

    private final WalletRepository walletRepository;
    private final WalletTransactionRepository transactionRepository;
    private final UserRepository userRepository;

    private static final int POINTS_TO_MONEY_RATIO = 100; // 100 điểm = 1 VND

    @Override
    public Wallet getWalletByUser(Long userId) {
        return walletRepository.findByUserId(userId)
                .orElseThrow(() -> new NotFoundException("Wallet not found for user"));
    }

    @Override
    public Wallet createWallet(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        if (walletRepository.findByUserId(userId).isPresent()) {
            throw new RuntimeException("Wallet already exists for user");
        }

        Wallet wallet = new Wallet();
        wallet.setUser(user);
        wallet.setBalance(0.0);
        wallet.setPoints(0);
        wallet.setTotalEarned(0.0);
        wallet.setTotalSpent(0.0);

        return walletRepository.save(wallet);
    }

    @Override
    public Wallet addBalance(Long userId, Double amount, String description) {
        Wallet wallet = getWalletByUser(userId);

        wallet.setBalance(wallet.getBalance() + amount);
        wallet.setTotalEarned(wallet.getTotalEarned() + amount);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setType(TransactionType.DEPOSIT);
        transaction.setAmount(amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setDescription(description);

        transactionRepository.save(transaction);
        return walletRepository.save(wallet);
    }

    @Override
    public Wallet deductBalance(Long userId, Double amount, String description, Long referenceId, String referenceType) {
        Wallet wallet = getWalletByUser(userId);

        if (wallet.getBalance() < amount) {
            throw new RuntimeException("Insufficient balance");
        }

        wallet.setBalance(wallet.getBalance() - amount);
        wallet.setTotalSpent(wallet.getTotalSpent() + amount);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setType(TransactionType.PAYMENT);
        transaction.setAmount(-amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setDescription(description);
        transaction.setReferenceId(referenceId);
        transaction.setReferenceType(referenceType);

        transactionRepository.save(transaction);
        return walletRepository.save(wallet);
    }

    @Override
    public Wallet addPoints(Long userId, Integer points) {
        Wallet wallet = getWalletByUser(userId);

        wallet.setPoints(wallet.getPoints() + points);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setType(TransactionType.REWARD);
        transaction.setAmount((double) points);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setDescription("Points reward: " + points);

        transactionRepository.save(transaction);
        return walletRepository.save(wallet);
    }

    @Override
    public Wallet redeemPoints(Long userId, Integer points) {
        Wallet wallet = getWalletByUser(userId);

        if (wallet.getPoints() < points) {
            throw new RuntimeException("Insufficient points");
        }

        double moneyValue = points / POINTS_TO_MONEY_RATIO;
        wallet.setPoints(wallet.getPoints() - points);
        wallet.setBalance(wallet.getBalance() + moneyValue);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setType(TransactionType.POINTS_REDEEM);
        transaction.setAmount(moneyValue);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setDescription("Redeem " + points + " points");

        transactionRepository.save(transaction);
        return walletRepository.save(wallet);
    }

    @Override
    public List<WalletTransaction> getTransactionHistory(Long userId) {
        Wallet wallet = getWalletByUser(userId);
        return transactionRepository.findByWalletIdOrderByCreatedAtDesc(wallet.getId());
    }
}
