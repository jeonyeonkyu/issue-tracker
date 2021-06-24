package com.codesquad.issuetracker.label.dto;

import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.mapper.LabelDtoMapper;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

@Data(staticConstructor = "from")
public class LabelResponses {

    @JsonValue
    private final Set<LabelResponse> labelResponses;

    public static LabelResponses from(Collection<LabelResponse> labelResponses) {
        return new LabelResponses(new HashSet<>(labelResponses));
    }

    public static LabelResponses from(Labels labels) {
        return LabelDtoMapper.toResponses(labels);
    }
}
