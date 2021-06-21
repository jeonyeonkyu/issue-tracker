package com.codesquad.issuetracker.user.dto;

import com.codesquad.issuetracker.issue.domain.User;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(of = {"id"})
@Builder
public class UserResponse {
    private long id;
    private String email;
    private String name;
    private String profileImage;

    public static UserResponse from(User user) {
        return UserResponse.builder()
                       .id(user.getId())
                       .email(user.getEmail())
                       .name(user.getName())
                       .profileImage(user.getProfileImage())
                       .build();
    }
}
