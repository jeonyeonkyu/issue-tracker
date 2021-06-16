package com.codesquad.issuetracker.label.domain;

import lombok.*;

@AllArgsConstructor
@Getter
@EqualsAndHashCode(of = "id")
@ToString
@Builder
public class Label {
    private Long id;
    private String name;
    private String description;
    private String color;
}
