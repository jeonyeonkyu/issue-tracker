package com.codesquad.issuetracker.issue.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

@Data(staticConstructor = "from")
public class Issues {
    private final List<Issue> issues;

    public static Issues of(Issue... issues) {
        return from(new ArrayList<>(Arrays.asList(issues)));
    }

    public Stream<Issue> stream() {
        return issues.stream();
    }
}
