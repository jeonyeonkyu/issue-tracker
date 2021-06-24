package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Milestone;
import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.mapper.LabelDtoMapper;
import com.codesquad.issuetracker.milestone.mapper.MilestoneDtoMapper;
import com.codesquad.issuetracker.user.mapper.UserDtoMapper;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IssueUpdateRequest {
    @NotEmpty
    private String title;

    private boolean isClosed;
    private Set<Long> assigneeIds;
    private Set<Long> labelIds;
    private Long milestoneId;

    public Users assignees() {
        return UserDtoMapper.toEntities(assigneeIds);
    }

    public Labels labels() {
        return LabelDtoMapper.toEntities(labelIds);
    }

    public Milestone milestone() {
        return MilestoneDtoMapper.toEntity(milestoneId);
    }
}
