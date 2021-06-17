package com.codesquad.issuetracker.auth.service;

import com.codesquad.issuetracker.auth.dto.GitHubAccessTokenRequest;
import com.codesquad.issuetracker.auth.dto.GitHubAccessTokenResponse;
import com.codesquad.issuetracker.user.UserDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.*;

import javax.security.auth.message.AuthException;
import java.util.Optional;

@PropertySource(value = "classpath:auth.properties")
@Service
public class AuthService {
    @Value("${gitHub_AccessTokenUri}")
    private String gitHubAccessTokenUri;

    @Value("${gitHub_UserUri}")
    private String gitHubUserUri;

    @Value("${client_id}")
    private String clientId;

    @Value("${client_secret}")
    private String clientSecret;

    private static RestTemplate restTemplate = new RestTemplate();

    public GitHubAccessTokenResponse getAccessToken(String code) throws AuthException {
        RequestEntity<GitHubAccessTokenRequest> request = RequestEntity
                .post(gitHubAccessTokenUri)
                .header("Accept", "application/json")
                .body(new GitHubAccessTokenRequest(clientId, clientSecret, code));

        ResponseEntity<GitHubAccessTokenResponse> response = restTemplate
                .exchange(request, GitHubAccessTokenResponse.class);

        return Optional.ofNullable(response.getBody())
                .orElseThrow(() -> new AuthException("Access Token 획득 실패"));
    }

    public UserDto getUserFromGitHub(String accessToken) throws AuthException {
        RequestEntity<Void> request = RequestEntity
                .get(gitHubUserUri)
                .header("Accept", "application/json")
                .header("Authorization", "token " + accessToken)
                .build();

        ResponseEntity<UserDto> response = restTemplate
                .exchange(request, UserDto.class);

        return Optional.ofNullable(response.getBody())
                .orElseThrow(() -> new AuthException("유저 정보 획득 실패"));
    }


}
