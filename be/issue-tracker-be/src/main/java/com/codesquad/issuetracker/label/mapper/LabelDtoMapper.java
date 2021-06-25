package com.codesquad.issuetracker.label.mapper;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.dto.LabelRequest;
import com.codesquad.issuetracker.label.dto.LabelResponse;
import com.codesquad.issuetracker.label.dto.LabelResponses;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class LabelDtoMapper {
    private LabelDtoMapper() {
    }

    public static Labels toEntities(Collection<Long> labelIds) {
        List<Label> labels = labelIds != null ?
                                     labelIds.stream()
                                             .map(LabelDtoMapper::toEntity)
                                             .collect(Collectors.toList()) :
                                     Collections.emptyList();

        return Labels.from(labels);
    }

    public static Label toEntity(Long id) {
        return Label.builder().id(id).build();
    }

    public static Label toEntity(LabelRequest labelRequest) {
        return Label.builder()
                       .name(labelRequest.getName())
                       .description(labelRequest.getDescription())
                       .color(labelRequest.getColor())
                       .build();
    }

    public static LabelResponses toResponses(Labels labels) {
        if (labels == null) {
            return LabelResponses.from(Collections.emptyList());
        }

        Set<LabelResponse> labelResponses = labels.stream()
                                                    .map(LabelResponse::from)
                                                    .collect(Collectors.toSet());

        return LabelResponses.from(labelResponses);
    }

    public static LabelResponse toResponse(Label label) {
        return LabelResponse.builder()
                       .id(label.getId())
                       .name(label.getName())
                       .description(label.getDescription())
                       .color(label.getColor())
                       .build();
    }
}
