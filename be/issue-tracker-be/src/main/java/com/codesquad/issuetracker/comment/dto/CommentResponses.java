package com.codesquad.issuetracker.comment.dto;

import com.codesquad.issuetracker.issue.domain.Comments;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

@Data(staticConstructor = "from")
public class CommentResponses {

    @JsonValue
    private final List<CommentResponse> commentResponses;

    public static CommentResponses from(Comments comments) {
        List<CommentResponse> commentResponses = comments.stream()
                                                         .map(CommentResponse::from)
                                                         .collect(Collectors.toList());

        return new CommentResponses(commentResponses);
    }
}
