package com.tientien.foodapp.auth.controller;

import com.tientien.foodapp.auth.dto.resp.AuthResponse;
import com.tientien.foodapp.auth.dto.req.LoginRequest;
import com.tientien.foodapp.auth.dto.req.RegisterRequest;
import com.tientien.foodapp.auth.dto.resp.LoginResponse;
import com.tientien.foodapp.auth.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public AuthResponse register(@Validated @RequestBody RegisterRequest request) {
        String token = authService.register(request);
        return new AuthResponse(token);
    }

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest loginRequest) {
        String email = loginRequest.getEmail();
        String password = loginRequest.getPassword();
        String token = authService.login(email, password);
        return new LoginResponse(token, "Login success");
    }
}
