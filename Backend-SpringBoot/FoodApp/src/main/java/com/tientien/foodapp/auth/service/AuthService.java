package com.tientien.foodapp.auth.service;

import com.tientien.foodapp.auth.dto.req.RegisterRequest;
import com.tientien.foodapp.auth.dto.resp.LoginResponse;

public interface AuthService {

    LoginResponse login(String email, String password);
    String register(RegisterRequest request);
}
