package com.tientien.foodapp.auth.service;

import com.tientien.foodapp.auth.dto.req.RegisterRequest;

public interface AuthService {

    String login(String email, String password);
    String register(RegisterRequest request);
}
