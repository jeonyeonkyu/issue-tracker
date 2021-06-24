package com.codesquad.issuetracker.issue.domain;

import com.codesquad.issuetracker.issue.dto.IssueRequest;
import com.codesquad.issuetracker.label.domain.Labels;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = {"id"})
@Builder
public class Issue {
    private Long id;
    private long number;
    private String title;
    private boolean isClosed;
    private LocalDateTime createDateTime;
    private User author;
    private Users assignees;
    private Labels labels;
    private Milestone milestone;
    private Comment mainComment;
    private Comments comments;

    public static Issue from(IssueRequest issueRequest) {
        // FIXME: IssueRequest에서 변환하도록 수정하는게 좋을 듯(엔티티가 DTO를 알고 있음)
        return Issue.builder()
                       .title(issueRequest.getTitle())
                       .author(issueRequest.author())
                       // TODO: comment도 issueRequest에서 뽑아내는게 좋지 않나?
                       .mainComment(Comment.from(issueRequest))
                       .assignees(issueRequest.assignees())
                       .labels(issueRequest.labels())
                       .milestone(issueRequest.milestone())
                       .build();
    }

    public String description() {
        return getMainComment().getContents();
    }

    public boolean hasSameAuthorComments(User user) {
        return comments != null && comments.stream()
                                           .anyMatch(comment -> comment.getAuthor().equals(user));
    }

    public boolean hasComments() {
        return comments != null && !comments.isEmpty();
    }

    public boolean hasAssignee() {
        return assignees != null && !assignees.isEmpty();
    }

    public boolean hasMilestone() {
        return milestone != null;
    }

    public Issue update(IssueRequest issueRequest) {
        title = issueRequest.getTitle();
        author = issueRequest.author();
        assignees = issueRequest.assignees();
        labels = issueRequest.labels();
        milestone = issueRequest.milestone();

        return this;
    }
}
