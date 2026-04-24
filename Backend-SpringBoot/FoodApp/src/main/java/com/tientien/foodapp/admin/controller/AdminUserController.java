package com.tientien.foodapp.admin.controller;

import com.tientien.foodapp.common.enums.UserRole;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // Get all users
    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Get users by role
    @GetMapping("/role/{role}")
    public List<User> getUsersByRole(@PathVariable UserRole role) {
        return userRepository.findByRole(role);
    }

    // Get user by ID
    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // Lock user account
    @PutMapping("/{id}/lock")
    public User lockUser(@PathVariable Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setStatus("SUSPENDED");
        return userRepository.save(user);
    }

    // Unlock user account
    @PutMapping("/{id}/unlock")
    public User unlockUser(@PathVariable Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setStatus("ACTIVE");
        return userRepository.save(user);
    }

    // Create staff user
    @PostMapping("/staff")
    public User createStaffUser(@RequestBody CreateStaffRequest request) {
        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.STAFF);
        user.setStatus("ACTIVE");
        // TODO: Link to restaurant
        return userRepository.save(user);
    }

    // Delete user
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userRepository.deleteById(id);
    }

    // Request DTO
    @lombok.Data
    public static class CreateStaffRequest {
        private String name;
        private String email;
        private String password;
        private Long restaurantId;
    }
}
