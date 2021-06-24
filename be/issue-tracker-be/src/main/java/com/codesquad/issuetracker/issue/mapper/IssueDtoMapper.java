package com.codesquad.issuetracker.issue.mapper;

import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.Issues;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.dto.IssueRequest;
import com.codesquad.issuetracker.issue.dto.IssueResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponses;
import com.codesquad.issuetracker.issue.dto.IssueUpdateRequest;
import com.codesquad.issuetracker.label.dto.LabelResponses;
import com.codesquad.issuetracker.milestone.dto.MilestoneResponse;
import com.codesquad.issuetracker.user.dto.UserResponse;
import com.codesquad.issuetracker.user.dto.UserResponses;

import java.util.List;
import java.util.stream.Collectors;

public class IssueDtoMapper {
    private IssueDtoMapper() {
    }

    public static Issue toEntity(IssueRequest issueRequest) {
        return Issue.builder()
                       .title(issueRequest.getTitle())
                       .author(issueRequest.author())
                       .mainComment(issueRequest.mainComment())
                       .assignees(issueRequest.assignees())
                       .labels(issueRequest.labels())
                       .milestone(issueRequest.milestone())
                       .build();
    }

    public static Issue toEntity(IssueUpdateRequest issueUpdateRequest) {
        return Issue.builder()
                       .title(issueUpdateRequest.getTitle())
                       .isClosed(issueUpdateRequest.isClosed())
                       .assignees(issueUpdateRequest.assignees())
                       .labels(issueUpdateRequest.labels())
                       .milestone(issueUpdateRequest.milestone())
                       .build();
    }

    public static IssueResponses toResponses(Issues issues, User loggedinUser) {
        List<IssueResponse> issueResponses = issues.stream()
                                                     .map(issue -> toResponse(issue, loggedinUser))
                                                     .collect(Collectors.toList());

        return IssueResponses.from(issueResponses);
    }

    public static IssueResponse toResponse(Issue issue, User loggedinUser) {
        return IssueResponse.builder()
                       .id(issue.getId())
                       .number(issue.getNumber())
                       .title(issue.getTitle())
                       .description(issue.description())
                       .isClosed(issue.isClosed())
                       .hasSameAuthorComments(issue.hasSameAuthorComments(loggedinUser))
                       .createDateTime(issue.getCreateDateTime())
                       .author(UserResponse.from(issue.getAuthor()))
                       .assignees(UserResponses.from(issue.getAssignees()))
                       .labels(LabelResponses.from(issue.getLabels()))
                       .milestone(MilestoneResponse.from(issue.getMilestone()))
                       .build();
    }
}
