package com.codesquad.issuetracker.label.dto;

import com.codesquad.issuetracker.label.domain.Label;
import lombok.Data;

import javax.validation.constraints.NotEmpty;

@Data
public class LabelRequest {

    @NotEmpty
    private String name;

    private String description;

    @NotEmpty
    private String color;

    public static LabelRequest from(Label label) {
        LabelRequest labelRequest = new LabelRequest();

        labelRequest.name = label.getName();
        labelRequest.description = label.getDescription();
        labelRequest.color = label.getColor();

        return labelRequest;
    }

    public Label toEntity() {
        return Label.builder()
                       .name(name)
                       .description(description)
                       .color(color)
                       .build();
    }

    public Label toEntity(long id) {
        return Label.builder()
                       .name(name)
                       .description(description)
                       .color(color)
                       .build();
    }
}
