package com.codesquad.issuetracker.user.dto;

import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.user.mapper.UserDtoMapper;
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
        return UserDtoMapper.toResponse(user);
    }
}
