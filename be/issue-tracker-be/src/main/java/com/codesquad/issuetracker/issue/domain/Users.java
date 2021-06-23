package com.codesquad.issuetracker.issue.domain;

import lombok.Data;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.stream.Stream;

@Data(staticConstructor = "from")
public class Users {
    private final List<User> users;

    public Stream<User> stream() {
        return users.stream();
    }

    public boolean isEmpty() {
        return CollectionUtils.isEmpty(users);
    }
}
