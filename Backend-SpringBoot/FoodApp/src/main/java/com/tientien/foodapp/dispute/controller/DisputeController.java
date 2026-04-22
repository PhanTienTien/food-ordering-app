package com.tientien.foodapp.dispute.controller;

import com.tientien.foodapp.dispute.entity.Dispute;
import com.tientien.foodapp.dispute.enums.DisputeStatus;
import com.tientien.foodapp.dispute.repository.DisputeRepository;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/disputes")
@RequiredArgsConstructor
public class DisputeController {

    private final DisputeRepository disputeRepository;
    private final OrderRepository orderRepository;

    @GetMapping
    public List<Dispute> getAllDisputes() {
        return disputeRepository.findAll();
    }

    @GetMapping("/{id}")
    public Dispute getDisputeById(@PathVariable Long id) {
        return disputeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dispute not found"));
    }

    @GetMapping("/order/{orderId}")
    public List<Dispute> getDisputesByOrder(@PathVariable Long orderId) {
        return disputeRepository.findByOrderId(orderId);
    }

    @GetMapping("/status/{status}")
    public List<Dispute> getDisputesByStatus(@PathVariable DisputeStatus status) {
        return disputeRepository.findByStatus(status);
    }

    @PostMapping
    public Dispute createDispute(
            @RequestParam Long orderId,
            @RequestParam String type,
            @RequestParam String description) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        Dispute dispute = new Dispute();
        dispute.setOrder(order);
        dispute.setType(com.tientien.foodapp.dispute.enums.DisputeType.valueOf(type));
        dispute.setStatus(DisputeStatus.OPEN);
        dispute.setDescription(description);

        return disputeRepository.save(dispute);
    }

    @PutMapping("/{id}/resolve")
    public Dispute resolveDispute(
            @PathVariable Long id,
            @RequestParam String resolution,
            @RequestParam(required = false) Double refundAmount,
            @RequestParam Long resolvedBy) {
        Dispute dispute = getDisputeById(id);
        dispute.setStatus(DisputeStatus.RESOLVED);
        dispute.setResolution(resolution);
        dispute.setRefundAmount(refundAmount);
        dispute.setResolvedBy(resolvedBy);
        return disputeRepository.save(dispute);
    }

    @PutMapping("/{id}/status")
    public Dispute updateStatus(
            @PathVariable Long id,
            @RequestParam DisputeStatus status) {
        Dispute dispute = getDisputeById(id);
        dispute.setStatus(status);
        return disputeRepository.save(dispute);
    }

    @DeleteMapping("/{id}")
    public void deleteDispute(@PathVariable Long id) {
        Dispute dispute = getDisputeById(id);
        disputeRepository.delete(dispute);
    }
}
