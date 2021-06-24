package com.codesquad.issuetracker.user.mapper;

import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.user.dto.UserResponse;
import com.codesquad.issuetracker.user.dto.UserResponses;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class UserDtoMapper {
    private UserDtoMapper() {
    }

    public static User toEntity(long id) {
        return User.builder().id(id).build();
    }

    public static Users toEntities(Collection<Long> userIds) {
        List<User> users = userIds != null ?
                                   userIds.stream()
                                           .map(userId -> User.builder().id(userId).build())
                                           .collect(Collectors.toList()) :
                                   Collections.emptyList();

        return Users.from(users);
    }

    public static UserResponse toResponse(User user) {
        return UserResponse.builder()
                       .id(user.getId())
                       .email(user.getEmail())
                       .name(user.getName())
                       .profileImage(user.getProfileImage())
                       .build();
    }

    public static UserResponses toResponses(Users users) {
        if (users == null) {
            return UserResponses.from(Collections.emptySet());
        }

        Set<UserResponse> userResponses = users.stream()
                                                  .map(UserResponse::from)
                                                  .collect(Collectors.toSet());

        return UserResponses.from(userResponses);
    }
}
