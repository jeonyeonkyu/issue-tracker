package com.codesquad.issuetracker.issue.domain;

import lombok.Data;
import org.springframework.util.CollectionUtils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Data(staticConstructor = "from")
public class Comments {

    private final List<Comment> comments;

    public static Comments of(Comment... comments) {
        return new Comments(Arrays.stream(comments).collect(Collectors.toList()));
    }

    public Stream<Comment> stream() {
        return comments != null ? comments.stream() : Collections.<Comment>emptyList().stream();
    }

    public boolean isEmpty() {
        return CollectionUtils.isEmpty(comments);
    }
}
