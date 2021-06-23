package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Milestone;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IssueRequest {
    @NotEmpty
    private String title;

    private String mainCommentContents;

    @NotNull
    private Long authorId;

    private Set<Long> assigneeIds;
    private Set<Long> labelIds;
    private Long milestoneId;

    public User author() {
        return User.builder().id(authorId).build();
    }

    public Users assignees() {
        List<User> assignees = assigneeIds != null ?
                                       assigneeIds.stream()
                                               .map(assigneeId -> User.builder().id(assigneeId).build())
                                               .collect(Collectors.toList()) :
                                       Collections.emptyList();

        return Users.from(assignees);
    }

    public Labels labels() {
        List<Label> labels = labelIds != null ?
                                     labelIds.stream()
                                             .map(labelId -> Label.builder().id(labelId).build())
                                             .collect(Collectors.toList()) :
                                     Collections.emptyList();

        return Labels.from(labels);
    }

    public Milestone milestone() {
        return Milestone.builder().id(milestoneId).build();
    }
}
