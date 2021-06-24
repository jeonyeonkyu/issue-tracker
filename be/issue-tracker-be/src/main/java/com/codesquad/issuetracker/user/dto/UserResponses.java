package com.codesquad.issuetracker.user.dto;

import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.user.mapper.UserDtoMapper;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

@Data(staticConstructor = "from")
public class UserResponses {

    @JsonValue
    private final Set<UserResponse> userResponses;

    public static UserResponses from(Collection<UserResponse> userResponses) {
        return new UserResponses(new HashSet<>(userResponses));
    }

    public static UserResponses from(Users users) {
        return UserDtoMapper.toResponses(users);
    }
}
