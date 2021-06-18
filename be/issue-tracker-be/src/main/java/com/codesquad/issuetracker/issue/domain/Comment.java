package com.codesquad.issuetracker.issue.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.time.LocalDateTime;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = {"id"})
@Builder
public class Comment {
    private Long id;
    private User author;
    private String contents;
    private LocalDateTime createDateTime;
}
