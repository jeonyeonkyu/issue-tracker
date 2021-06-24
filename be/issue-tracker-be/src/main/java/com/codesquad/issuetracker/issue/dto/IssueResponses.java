package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Issues;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.mapper.IssueDtoMapper;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.List;

@Data(staticConstructor = "from")
public class IssueResponses {

    @JsonValue
    private final List<IssueResponse> issueResponses;

    public static IssueResponses of(Issues issues, User loggedinUser) {
        return IssueDtoMapper.toResponses(issues, loggedinUser);
    }
}
