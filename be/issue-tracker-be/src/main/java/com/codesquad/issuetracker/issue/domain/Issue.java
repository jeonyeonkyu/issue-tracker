package com.codesquad.issuetracker.issue.domain;

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

    public Issue update(Issue issue) {
        this.title = issue.title;
        this.author = issue.author;
        this.assignees = issue.assignees;
        this.labels = issue.labels;
        this.milestone = issue.milestone;

        return this;
    }
}
