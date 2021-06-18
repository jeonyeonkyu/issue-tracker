package com.codesquad.issuetracker.label.dto;

import com.codesquad.issuetracker.label.domain.Label;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(of = {"id"})
@Builder
public class LabelResponse {
    private Long id;
    private String name;
    private String description;
    private String color;

    public static LabelResponse from(Label label) {
        return LabelResponse.builder()
                       .id(label.getId())
                       .name(label.getName())
                       .description(label.getDescription())
                       .color(label.getColor())
                       .build();
    }
}
