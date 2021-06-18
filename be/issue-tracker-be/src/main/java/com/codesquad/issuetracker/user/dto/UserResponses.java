package com.codesquad.issuetracker.user.dto;

import com.codesquad.issuetracker.issue.domain.Users;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Data(staticConstructor = "from")
public class UserResponses {

    @JsonValue
    private final Set<UserResponse> userResponses;

    public static UserResponses from(Collection<UserResponse> userResponses) {
        return new UserResponses(new HashSet<>(userResponses));
    }

    public static UserResponses from(Users users) {
        Set<UserResponse> userResponses = users.stream()
                                                  .map(UserResponse::from)
                                                  .collect(Collectors.toSet());

        return new UserResponses(userResponses);
    }
}
