package com.codesquad.issuetracker.label.dto;

import com.fasterxml.jackson.annotation.JsonValue;
import com.codesquad.issuetracker.label.domain.Labels;
import lombok.Data;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Data(staticConstructor = "from")
public class LabelResponses {

    @JsonValue
    private final Set<LabelResponse> labelResponses;

    public static LabelResponses from(Collection<LabelResponse> labelResponses) {
        return new LabelResponses(new HashSet<>(labelResponses));
    }

    public static LabelResponses from(Labels labelEntities) {
        Set<LabelResponse> labelResponses = labelEntities.stream()
                                                    .map(LabelResponse::from)
                                                    .collect(Collectors.toSet());

        return LabelResponses.from(labelResponses);
    }
}
