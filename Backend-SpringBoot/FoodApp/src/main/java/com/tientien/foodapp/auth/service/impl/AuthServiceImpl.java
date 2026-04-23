package com.tientien.foodapp.auth.service.impl;

import com.tientien.foodapp.auth.dto.req.RegisterRequest;
import com.tientien.foodapp.auth.dto.resp.LoginResponse;
import com.tientien.foodapp.auth.service.AuthService;
import com.tientien.foodapp.common.enums.UserRole;
import com.tientien.foodapp.common.security.JwtUtil;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    @Override
    public String register(RegisterRequest request) {

        // 💣 CHECK EMAIL EXIST
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email already exists");
        }

        // 🔥 CREATE USER
        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());

        // 💣 HASH PASSWORD
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        user.setRole(UserRole.CUSTOMER);
        user.setStatus("ACTIVE");

        userRepository.save(user);

        try {
            return jwtUtil.generateToken(user);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public LoginResponse login(String email, String password) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Invalid email"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        String token = jwtUtil.generateToken(user);
        return new LoginResponse(token, "Login success", user.getRole());
    }
}
