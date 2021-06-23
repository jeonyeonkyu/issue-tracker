package com.codesquad.issuetracker.issue.domain;

import com.codesquad.issuetracker.comment.vo.Emojis;
import com.codesquad.issuetracker.issue.dto.IssueRequest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = {"id"})
@Builder
public class Comment {
    private Long id;
    private User author;
    private String contents;
    private LocalDateTime createDateTime;
    private Emojis emojis;

    public static Comment from(IssueRequest issueRequest) {
        User author = User.builder().id(issueRequest.getAuthorId()).build();

        String mainCommentContents = issueRequest.getMainCommentContents() != null ?
                                             issueRequest.getMainCommentContents() : "";

        return Comment.builder()
                       .author(author)
                       .contents(mainCommentContents)
                       .createDateTime(LocalDateTime.now())
                       .build();
    }
}
