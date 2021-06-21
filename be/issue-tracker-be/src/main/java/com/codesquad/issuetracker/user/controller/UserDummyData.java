package com.codesquad.issuetracker.user.controller;

import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.user.dto.UserResponse;
import com.codesquad.issuetracker.user.dto.UserResponses;

import java.util.Arrays;

public class UserDummyData {
    private UserDummyData() {
    }

    public static UserResponses usersResponses() {
        return UserResponses.from(Arrays.asList(
                userResponseFreddie(),
                userResponseHiro()
        ));
    }

    public static Users users() {
        return Users.from(Arrays.asList(
                userFreddie(),
                userHiro()
        ));
    }

    public static UserResponse userResponseFreddie() {
        return UserResponse.builder()
                       .id(1L)
                       .email("freddie@freddie.com")
                       .name("freddie")
                       .profileImage("/images/소라게.jpg")
                       .build();
    }

    public static User userFreddie() {
        return User.builder()
                       .id(1L)
                       .email("freddie@freddie.com")
                       .name("freddie")
                       .profileImage("/images/소라게.jpg")
                       .build();
    }

    public static UserResponse userResponseHiro() {
        return UserResponse.builder()
                       .id(2L)
                       .email("hiro@hiro.com")
                       .name("hiro")
                       .profileImage("/images/소라게.jpg")
                       .build();
    }

    public static User userHiro() {
        return User.builder()
                       .id(2L)
                       .email("hiro@hiro.com")
                       .name("hiro")
                       .profileImage("/images/소라게.jpg")
                       .build();
    }
}
