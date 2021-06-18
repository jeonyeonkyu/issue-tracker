package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.label.dto.LabelResponses;
import com.codesquad.issuetracker.milestone.dto.MilestoneResponse;
import com.codesquad.issuetracker.user.dto.UserResponse;
import com.codesquad.issuetracker.user.dto.UserResponses;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(of = {"id"})
@Builder
public class IssueResponse {
    private Long id;
    private long number;
    private String title;
    private String description;
    private boolean isClosed;
    private boolean hasSameAuthorComments;
    private LocalDateTime createDateTime;
    private UserResponse author;
    private UserResponses assignees;
    private LabelResponses labels;
    private MilestoneResponse milestone;

    public static IssueResponse of(Issue issue, User user) {
        return IssueResponse.builder()
                       .id(issue.getId())
                       .number(issue.getNumber())
                       .title(issue.getTitle())
                       .description(issue.description())
                       .isClosed(issue.isClosed())
                       .hasSameAuthorComments(issue.hasSameAuthorComments(user))
                       .createDateTime(issue.getCreateDateTime())
                       .author(UserResponse.from(issue.getAuthor()))
                       .assignees(UserResponses.from(issue.getAssignees()))
                       .labels(LabelResponses.from(issue.getLabels()))
                       .milestone(MilestoneResponse.from(issue.getMilestone()))
                       .build();
    }
}
