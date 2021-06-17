package com.codesquad.issuetracker.auth.controller;

import com.codesquad.issuetracker.auth.dto.AuthResponse;
import com.codesquad.issuetracker.auth.service.AuthService;
import com.codesquad.issuetracker.auth.dto.GitHubAccessTokenResponse;
import com.codesquad.issuetracker.auth.util.JwtUtil;
import com.codesquad.issuetracker.user.UserDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.security.auth.message.AuthException;

@RequestMapping("/auth")
@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    //Fixme : front로 변경
    @GetMapping("/callback")
    public void callback(@RequestParam(value = "code") String code) throws AuthException {
        auth(code);
    }

    @GetMapping()
    public ResponseEntity<AuthResponse> auth(String code) throws AuthException {
        GitHubAccessTokenResponse token = authService.getAccessToken(code);
        String accessToken = token.getAccessToken();

        UserDto userDto = authService.getUserFromGitHub(accessToken);

        AuthResponse authResponse = new AuthResponse(JwtUtil.createJwt(userDto));
        
        ResponseEntity<AuthResponse> authResponseResponseEntity = ResponseEntity.status(HttpStatus.CREATED).
                body(new AuthResponse(JwtUtil.createJwt(userDto)));

        return authResponseResponseEntity;
    }


}
