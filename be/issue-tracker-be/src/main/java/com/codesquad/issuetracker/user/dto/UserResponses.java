package com.codesquad.issuetracker.user.dto;

import com.codesquad.issuetracker.issue.domain.Users;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.Collection;
import java.util.Collections;
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
        if (users == null || users.isEmpty()) {
            return UserResponses.from(Collections.emptySet());
        }

        Set<UserResponse> userResponses = users.stream()
                                                  .map(UserResponse::from)
                                                  .collect(Collectors.toSet());

        return UserResponses.from(userResponses);
    }
}
