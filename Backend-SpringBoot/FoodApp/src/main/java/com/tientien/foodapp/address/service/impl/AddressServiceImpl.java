package com.tientien.foodapp.address.service.impl;

import com.tientien.foodapp.address.entity.Address;
import com.tientien.foodapp.address.repository.AddressRepository;
import com.tientien.foodapp.address.service.AddressService;
import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AddressServiceImpl implements AddressService {

    private final AddressRepository addressRepository;
    private final UserRepository userRepository;

    @Override
    public List<Address> getAddressesByUser(Long userId) {
        return addressRepository.findByUserId(userId);
    }

    @Override
    public Address getDefaultAddress(Long userId) {
        return addressRepository.findByUserIdAndIsDefaultTrue(userId)
                .orElseThrow(() -> new NotFoundException("No default address found"));
    }

    @Override
    public Address getAddressById(Long id) {
        return addressRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Address not found"));
    }

    @Override
    public Address createAddress(AddressCreateRequest request) {
        User user = userRepository.findById(request.userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        Address address = new Address();
        address.setUser(user);
        address.setFullName(request.fullName);
        address.setPhoneNumber(request.phoneNumber);
        address.setAddressLine(request.addressLine);
        address.setCity(request.city);
        address.setDistrict(request.district);
        address.setWard(request.ward);
        address.setLatitude(request.latitude);
        address.setLongitude(request.longitude);
        address.setIsDefault(request.isDefault != null ? request.isDefault : false);

        // If setting as default, remove default from other addresses
        if (address.getIsDefault()) {
            addressRepository.findByUserId(request.userId).forEach(a -> a.setIsDefault(false));
        }

        return addressRepository.save(address);
    }

    @Override
    public Address updateAddress(Long id, AddressUpdateRequest request) {
        Address address = getAddressById(id);

        if (request.fullName != null) address.setFullName(request.fullName);
        if (request.phoneNumber != null) address.setPhoneNumber(request.phoneNumber);
        if (request.addressLine != null) address.setAddressLine(request.addressLine);
        if (request.city != null) address.setCity(request.city);
        if (request.district != null) address.setDistrict(request.district);
        if (request.ward != null) address.setWard(request.ward);
        if (request.latitude != null) address.setLatitude(request.latitude);
        if (request.longitude != null) address.setLongitude(request.longitude);

        if (request.isDefault != null && request.isDefault) {
            addressRepository.findByUserId(address.getUser().getId())
                    .forEach(a -> a.setIsDefault(false));
            address.setIsDefault(true);
        }

        return addressRepository.save(address);
    }

    @Override
    public Address setDefaultAddress(Long id, Long userId) {
        Address address = getAddressById(id);

        if (!address.getUser().getId().equals(userId)) {
            throw new NotFoundException("Address does not belong to user");
        }

        addressRepository.findByUserId(userId).forEach(a -> a.setIsDefault(false));
        address.setIsDefault(true);

        return addressRepository.save(address);
    }

    @Override
    public void deleteAddress(Long id) {
        Address address = getAddressById(id);
        addressRepository.delete(address);
    }
}
