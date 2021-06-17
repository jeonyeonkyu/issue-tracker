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

    public Label update(Label labelForUpdate) {
        name = labelForUpdate.getName();
        description = labelForUpdate.getDescription();
        color = labelForUpdate.getColor();

        return this;
    }
}
