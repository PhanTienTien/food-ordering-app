package com.tientien.foodapp.banner.controller;

import com.tientien.foodapp.banner.entity.Banner;
import com.tientien.foodapp.banner.enums.BannerStatus;
import com.tientien.foodapp.banner.repository.BannerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/admin/banners")
@RequiredArgsConstructor
public class BannerController {

    private final BannerRepository bannerRepository;

    @GetMapping
    public List<Banner> getAllBanners() {
        return bannerRepository.findAll();
    }

    @GetMapping("/active")
    public List<Banner> getActiveBanners() {
        LocalDateTime now = LocalDateTime.now();
        return bannerRepository.findByStatusAndStartDateBeforeAndEndDateAfter(
                BannerStatus.ACTIVE,
                now,
                now
        );
    }

    @GetMapping("/{id}")
    public Banner getBannerById(@PathVariable Long id) {
        return bannerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Banner not found"));
    }

    @PostMapping
    public Banner createBanner(@RequestBody Banner banner) {
        return bannerRepository.save(banner);
    }

    @PutMapping("/{id}")
    public Banner updateBanner(
            @PathVariable Long id,
            @RequestBody Banner banner) {
        Banner existing = getBannerById(id);

        if (banner.getTitle() != null) existing.setTitle(banner.getTitle());
        if (banner.getDescription() != null) existing.setDescription(banner.getDescription());
        if (banner.getImageUrl() != null) existing.setImageUrl(banner.getImageUrl());
        if (banner.getTargetUrl() != null) existing.setTargetUrl(banner.getTargetUrl());
        if (banner.getStatus() != null) existing.setStatus(banner.getStatus());
        if (banner.getDisplayOrder() != null) existing.setDisplayOrder(banner.getDisplayOrder());
        if (banner.getStartDate() != null) existing.setStartDate(banner.getStartDate());
        if (banner.getEndDate() != null) existing.setEndDate(banner.getEndDate());

        return bannerRepository.save(existing);
    }

    @PutMapping("/{id}/status")
    public Banner updateStatus(
            @PathVariable Long id,
            @RequestParam BannerStatus status) {
        Banner banner = getBannerById(id);
        banner.setStatus(status);
        return bannerRepository.save(banner);
    }

    @PutMapping("/{id}/click")
    public Banner incrementClickCount(@PathVariable Long id) {
        Banner banner = getBannerById(id);
        banner.setClickCount(banner.getClickCount() + 1);
        return bannerRepository.save(banner);
    }

    @DeleteMapping("/{id}")
    public void deleteBanner(@PathVariable Long id) {
        Banner banner = getBannerById(id);
        bannerRepository.delete(banner);
    }
}
