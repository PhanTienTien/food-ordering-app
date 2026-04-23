package com.tientien.foodapp.auth.dto.resp;

import com.tientien.foodapp.common.enums.UserRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String message = "Login success";
    private UserRole role;
}
