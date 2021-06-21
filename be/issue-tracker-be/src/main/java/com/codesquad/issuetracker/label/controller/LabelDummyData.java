package com.codesquad.issuetracker.label.controller;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.dto.LabelResponse;
import com.codesquad.issuetracker.label.dto.LabelResponses;
import com.codesquad.issuetracker.label.dto.LabelsCountResponse;

import java.util.Arrays;

public class LabelDummyData {
    private LabelDummyData() {
    }

    public static LabelResponses labelResponses() {
        return LabelResponses.from(Arrays.asList(
                labelResponseBe(),
                labelResponseFe()
        ));
    }

    public static Labels labels() {
        return Labels.from(Arrays.asList(
                labelBe(),
                labelFe()
        ));
    }

    public static LabelResponse labelResponseBe() {
        return LabelResponse.builder()
                       .id(1L)
                       .name("be")
                       .description("label for backend")
                       .color("#1679CF")
                       .build();
    }

    public static Label labelBe() {
        return Label.builder()
                       .id(1L)
                       .name("be")
                       .description("label for backend")
                       .color("#1679CF")
                       .build();
    }

    public static LabelResponse labelResponseFe() {
        return LabelResponse.builder()
                       .id(2L)
                       .name("fe")
                       .description("label for frontend")
                       .color("#3EFC68")
                       .build();
    }

    public static Label labelFe() {
        return Label.builder()
                       .id(2L)
                       .name("fe")
                       .description("label for frontend")
                       .color("#3EFC68")
                       .build();
    }

    public static LabelsCountResponse labelsCountResponses() {
        return LabelsCountResponse.from(3);
    }
}
