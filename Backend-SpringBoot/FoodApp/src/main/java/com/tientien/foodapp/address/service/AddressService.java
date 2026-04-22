package com.tientien.foodapp.address.service;

import com.tientien.foodapp.address.entity.Address;

import java.util.List;

public interface AddressService {
    List<Address> getAddressesByUser(Long userId);
    Address getDefaultAddress(Long userId);
    Address getAddressById(Long id);
    Address createAddress(AddressCreateRequest request);
    Address updateAddress(Long id, AddressUpdateRequest request);
    Address setDefaultAddress(Long id, Long userId);
    void deleteAddress(Long id);

    class AddressCreateRequest {
        public Long userId;
        public String fullName;
        public String phoneNumber;
        public String addressLine;
        public String city;
        public String district;
        public String ward;
        public Double latitude;
        public Double longitude;
        public Boolean isDefault;
    }

    class AddressUpdateRequest {
        public String fullName;
        public String phoneNumber;
        public String addressLine;
        public String city;
        public String district;
        public String ward;
        public Double latitude;
        public Double longitude;
        public Boolean isDefault;
    }
}
