package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Issues;
import com.codesquad.issuetracker.issue.domain.User;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

@Data(staticConstructor = "from")
public class IssueResponses {

    @JsonValue
    private final List<IssueResponse> issueResponses;

    public static IssueResponses of(Issues issues, User user) {
        List<IssueResponse> issueResponses = issues.stream()
                                                     .map(issue -> IssueResponse.of(issue, user))
                                                     .collect(Collectors.toList());

        return new IssueResponses(issueResponses);
    }
}
