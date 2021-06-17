package com.codesquad.issuetracker.label.service;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.dto.LabelRequest;
import com.codesquad.issuetracker.label.dto.LabelResponse;
import com.codesquad.issuetracker.label.dto.LabelResponses;
import com.codesquad.issuetracker.label.repository.LabelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LabelService {

    private final LabelRepository labelRepository;

    public LabelResponses readAll() {
        Labels labels = labelRepository.readAll();

        return LabelResponses.from(labels);
    }

    public LabelResponse create(LabelRequest labelRequest) {
        Label savedLabel = labelRepository.save(labelRequest.toEntity());

        return LabelResponse.from(savedLabel);
    }
}
