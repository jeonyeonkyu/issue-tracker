package com.codesquad.issuetracker.issue.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.time.LocalDate;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = {"id"})
@Builder
public class Milestone {
    private Long id;
    private String name;
    private String description;
    private LocalDate dueDate;
    private boolean isClosed;
    private int openedIssueCount;
    private int closedIssueCount;
}
