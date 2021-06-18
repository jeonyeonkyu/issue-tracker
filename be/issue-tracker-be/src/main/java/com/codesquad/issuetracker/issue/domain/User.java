package com.codesquad.issuetracker.issue.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = {"id"})
@Builder
public class User {
    private long id;
    private String email;
    private String name;
    private String profileImage;
}
