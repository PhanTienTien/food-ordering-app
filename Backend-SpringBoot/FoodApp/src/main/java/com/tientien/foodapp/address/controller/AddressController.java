package com.tientien.foodapp.address.controller;

import com.tientien.foodapp.address.entity.Address;
import com.tientien.foodapp.address.service.AddressService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/addresses")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService addressService;

    @GetMapping("/user/{userId}")
    public List<Address> getAddressesByUser(@PathVariable Long userId) {
        return addressService.getAddressesByUser(userId);
    }

    @GetMapping("/user/{userId}/default")
    public Address getDefaultAddress(@PathVariable Long userId) {
        return addressService.getDefaultAddress(userId);
    }

    @GetMapping("/{id}")
    public Address getAddressById(@PathVariable Long id) {
        return addressService.getAddressById(id);
    }

    @PostMapping
    public Address createAddress(@RequestBody AddressService.AddressCreateRequest request) {
        return addressService.createAddress(request);
    }

    @PutMapping("/{id}")
    public Address updateAddress(
            @PathVariable Long id,
            @RequestBody AddressService.AddressUpdateRequest request) {
        return addressService.updateAddress(id, request);
    }

    @PutMapping("/{id}/default")
    public Address setDefaultAddress(
            @PathVariable Long id,
            @RequestParam Long userId) {
        return addressService.setDefaultAddress(id, userId);
    }

    @DeleteMapping("/{id}")
    public void deleteAddress(@PathVariable Long id) {
        addressService.deleteAddress(id);
    }
}
