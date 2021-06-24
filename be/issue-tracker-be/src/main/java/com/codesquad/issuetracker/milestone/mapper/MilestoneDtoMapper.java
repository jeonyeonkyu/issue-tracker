package com.codesquad.issuetracker.milestone.mapper;

import com.codesquad.issuetracker.issue.domain.Milestone;
import com.codesquad.issuetracker.milestone.dto.MilestoneResponse;

public class MilestoneDtoMapper {
    private MilestoneDtoMapper() {
    }

    public static Milestone toEntity(Long id) {
        return Milestone.builder().id(id).build();
    }

    public static MilestoneResponse toResponse(Milestone milestone) {
        return MilestoneResponse.builder()
                       .id(milestone.getId())
                       .name(milestone.getName())
                       .description(milestone.getDescription())
                       .dueDate(milestone.getDueDate())
                       .isClosed(milestone.isClosed())
                       .openedIssueCount(milestone.getOpenedIssueCount())
                       .closedIssueCount(milestone.getClosedIssueCount())
                       .build();
    }
}
