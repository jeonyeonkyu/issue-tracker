package com.codesquad.issuetracker.issue.domain;

import com.codesquad.issuetracker.comment.dto.CommentResponses;
import lombok.Data;

import java.util.List;
import java.util.stream.Stream;

@Data(staticConstructor = "from")
public class Comments {

    private final List<Comment> comments;

    public Stream<Comment> stream() {
        return comments.stream();
    }
}
