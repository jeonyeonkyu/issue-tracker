package com.codesquad.issuetracker.milestone.dto;

import com.codesquad.issuetracker.issue.domain.Milestone;
import com.codesquad.issuetracker.milestone.mapper.MilestoneDtoMapper;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

@Data
@EqualsAndHashCode(of = {"id"})
@Builder
public class MilestoneResponse {
    private Long id;
    private String name;
    private String description;
    private LocalDate dueDate;
    private boolean isClosed;
    private int openedIssueCount;
    private int closedIssueCount;

    public static MilestoneResponse from(Milestone milestone) {
        return MilestoneDtoMapper.toResponse(milestone);
    }
}
