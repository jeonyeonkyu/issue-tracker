package com.codesquad.issuetracker.label.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

@Data(staticConstructor = "from")
public class Labels {
    private final List<Label> labels;

    public static Labels of(Label ... labels) {
        return from(new ArrayList<>(Arrays.asList(labels)));
    }

    public Stream<Label> stream() {
        return labels.stream();
    }
}
