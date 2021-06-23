package com.codesquad.issuetracker.label.dto;

import com.codesquad.issuetracker.label.domain.Labels;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Data;

import java.util.Collection;
import java.util.Collections;
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

    public static LabelResponses from(Labels labels) {
        if (labels.isEmpty()) {
            return LabelResponses.from(Collections.emptyList());
        }

        Set<LabelResponse> labelResponses = labels.stream()
                                                    .map(LabelResponse::from)
                                                    .collect(Collectors.toSet());

        return LabelResponses.from(labelResponses);
    }
}
